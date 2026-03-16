
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
    cidr_blocks = ["0.0.0.0/0"]
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

   ami = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-minimal-kernel-default-arm64"
   instance_type = var.instance_type
   key_name = var.key_name
   vpc_security_group_ids = [aws_security_group.server_region1_sg[count.index].id]
   subnet_id = aws_subnet.server_a_region1_subnet[count.index].id
   iam_instance_profile = "AmazonSSMRoleForInstancesQuickSetup"
   private_ip = cidrhost(aws_subnet.server_a_region1_subnet[count.index].cidr_block, 10)
   associate_public_ip_address = true

   lifecycle {
     ignore_changes = [ ami ]
   }

   tags = {
       Name = "linux-host-private-${count.index}"
   }
 }

####################################################################################################################################
# REGION 2
####################################################################################################################################

resource "aws_security_group" "server_region2_sg" {
  provider = aws.secondary
  count = var.vpc_amount

  name        = "allow-ssh-ping-${count.index}"
  description = "Allow SSH"
  vpc_id      = aws_vpc.region2_vpc[count.index].id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

 resource "aws_instance" "linux_region2_instance" {
   provider = aws.secondary
   count = var.vpc_amount

   ami = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-minimal-kernel-default-arm64"
   instance_type = var.instance_type
   key_name = var.key_name
   vpc_security_group_ids = [aws_security_group.server_region2_sg[count.index].id]
   subnet_id = aws_subnet.server_a_region2_subnet[count.index].id
   iam_instance_profile = "AmazonSSMRoleForInstancesQuickSetup"
   private_ip = cidrhost(aws_subnet.server_a_region2_subnet[count.index].cidr_block, 10)
   associate_public_ip_address = true
   
   lifecycle {
     ignore_changes = [ ami ]
   }

   tags = {
       Name = "linux-host-private-${count.index}"
   }
 }