
####################################################################################################################################
# IAM role
####################################################################################################################################

resource "aws_iam_role" "linux_ec2_role" {
  name               = "linux-ec2-role"
  description        = "Allows EC2 to access SSM"
  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": ["ec2.amazonaws.com"]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
 POLICY  
}

resource "aws_iam_role_policy_attachment" "linux_ec2_role_attachment" {
  role       = aws_iam_role.linux_ec2_role.name
  policy_arn ="arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
}

resource "aws_iam_instance_profile" "linux_ec2_instance_profile" {
  name = "linux-ec2-instance-profile"
  role = aws_iam_role.linux_ec2_role.name
}

####################################################################################################################################
# REGION 1
####################################################################################################################################
resource "aws_security_group" "server_region1_sg" {
  provider = aws.primary
  count = var.vpc_amount

  name        = "allow-ssh-ping-${count.index}"
  description = "Allow SSH"
  vpc_id      = aws_vpc.region1_vpc[count.index].id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "193.239.0.0/22", "81.90.251.153/32"]
  }

  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

 resource "aws_instance" "linux_region1_instance" {
   provider = aws.primary
   count = var.vpc_amount

   ami = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-arm64"
   instance_type = var.instance_type
   key_name = var.key_name
   vpc_security_group_ids = [aws_security_group.server_region1_sg[count.index].id]
   subnet_id = aws_subnet.server_a_region1_subnet[count.index].id
   iam_instance_profile = aws_iam_instance_profile.linux_ec2_instance_profile.name
   private_ip = cidrhost(aws_subnet.server_a_region1_subnet[count.index].cidr_block, 10)
   associate_public_ip_address = true
   
   user_data = <<-EOF
#!/bin/bash
# Vytvoříme uživatele
useradd lab
# heslo lab 
echo "lab:lab" | chpasswd
# Změníníme nastavení SSH pro povolení přihlášení pomocí hesla
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
# odkomentujeme řádek, pokud je zakomentovaný (defultně by neměl být ale jistota je jistota)
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
# PAM musí být povoleno pro použití hesel
sed -i 's/^UsePAM no/UsePAM yes/' /etc/ssh/sshd_config
# Restart SSH service
systemctl restart sshd
EOF

   lifecycle {
     ignore_changes = [ ami ]
   }

   tags = {
       Name = "linux-host-private-${count.index}"
   }
 }


####################################################################################################################################
# Cisco Cat 8000v
####################################################################################################################################

resource "aws_security_group" "server_fw_test_test_sg" {
  provider = aws.primary
  
  name        = "allow-any"
  description = "Allow anything"
  vpc_id      = aws_vpc.region1_vpc[0].id

# Allow all inbound traffic for testing purposes
  ingress {
    description = "All traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

 resource "aws_instance" "cisco_fw_test_instance_test" {
   provider = aws.primary
   
   ami = "ami-011a3f02bf1fbe77a"
   instance_type = "t3.medium"
   key_name = var.key_name
   vpc_security_group_ids = [aws_security_group.server_fw_test_test_sg.id]
   subnet_id = aws_subnet.server_a_region1_subnet[0].id
   iam_instance_profile = aws_iam_instance_profile.linux_ec2_instance_profile.name
   private_ip = cidrhost(aws_subnet.server_a_region1_subnet[0].cidr_block, 11)
   associate_public_ip_address = true
   source_dest_check = false
user_data = <<-EOF
Content-Type: multipart/mixed; boundary="===============cisco=="
MIME-Version: 1.0

--===============cisco==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="iosxe_config.txt"
hostname fw-test-1
aaa new-model
username cisco privilege 15 secret cisco
aaa authentication login default local
aaa authorization exec default local
ip domain name csast.cz
crypto key generate rsa general-keys modulus 4096
ip ssh version 2
ip ssh server algorithm authentication password keyboard
line con 0
 login authentication default
line vty 0 4
 transport input ssh
 login authentication default
interface GigabitEthernet1
 ip address dhcp
 no shut
ip route 0.0.0.0 0.0.0.0 10.0.10.1
end

--===============cisco==--
EOF

  tags = {
       Name = "cisco-fw-test-instance-test"
   }
 }