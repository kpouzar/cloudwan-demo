################################################################################
# VPC FW TEST
################################################################################

resource "aws_vpc" "fw_test_vpc" {
  provider = aws.primary
  
  cidr_block           = "10.254.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = {
    Name = "fw-test-vpc"
  }
}

################################################################################
# Internet Gateway
################################################################################
resource "aws_internet_gateway" "fw_test_igw" {
  provider = aws.primary
  vpc_id = aws_vpc.fw_test_vpc.id

  tags = {
    Name = "fw-test-igw"
  }
}


################################################################################
# Subnets 
################################################################################
resource "aws_subnet" "tgw_fw_test_subnet_a" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_test_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_test_vpc.cidr_block, 8, 0)
  availability_zone = "${var.aws_region1}a"

  tags = {
    Name = "tgw-fw-test-subnet-a"
  }
}

resource "aws_subnet" "tgw_fw_test_subnet_b" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_test_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_test_vpc.cidr_block, 8, 1)
  availability_zone = "${var.aws_region1}b"

  tags = {
    Name = "tgw-fw-test-subnet-b"
  }
}

resource "aws_subnet" "tgw_fw_test_subnet_c" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_test_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_test_vpc.cidr_block, 8, 2)
  availability_zone = "${var.aws_region1}c"

  tags = {
    Name = "tgw-fw-test-subnet-c"
  }
}

resource "aws_subnet" "gwlbe_fw_test_subnet_a" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_test_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_test_vpc.cidr_block, 8, 4)
  availability_zone = "${var.aws_region1}a"

  tags = {
    Name = "gwlbe-fw-test-subnet-a"
  }
}

resource "aws_subnet" "gwlbe_fw_test_subnet_b" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_test_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_test_vpc.cidr_block, 8, 5)
  availability_zone = "${var.aws_region1}b"


  tags = {
    Name = "gwlbe-fw-test-subnet-b"
  }
}

resource "aws_subnet" "gwlbe_fw_test_subnet_c" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_test_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_test_vpc.cidr_block, 8, 6)
  availability_zone = "${var.aws_region1}c"


  tags = {
    Name = "gwlbe-fw-test-subnet-c"
  }
}


resource "aws_subnet" "server_fw_test_subnet_a" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_test_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_test_vpc.cidr_block, 8, 8)
  availability_zone = "${var.aws_region1}a"

  tags = {
    Name = "server-fw-test-subnet-a"
  }
}

resource "aws_subnet" "server_fw_test_subnet_b" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_test_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_test_vpc.cidr_block, 8, 9)
  availability_zone = "${var.aws_region1}b"

  tags = {
    Name = "server-fw-test-subnet-b"
  }
}

resource "aws_subnet" "server_fw_test_subnet_c" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_test_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_test_vpc.cidr_block, 8, 10)
  availability_zone = "${var.aws_region1}c"

  tags = {
    Name = "server-fw-test-subnet-c"
  }
}

resource "aws_subnet" "public_fw_test_subnet_a" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_test_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_test_vpc.cidr_block, 8, 12)
  availability_zone = "${var.aws_region1}a"

  tags = {
    Name = "public-fw-test-subnet-a"
  }
}

resource "aws_subnet" "public_fw_test_subnet_b" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_test_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_test_vpc.cidr_block, 8, 13)
  availability_zone = "${var.aws_region1}b"


  tags = {
    Name = "public-fw-test-subnet-b"
  }
}

resource "aws_subnet" "public_fw_test_subnet_c" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_test_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_test_vpc.cidr_block, 8, 14)
  availability_zone = "${var.aws_region1}c"


  tags = {
    Name = "public-fw-test-subnet-c"
  }
}


#############################################################################
# Routing table create
#############################################################################
resource "aws_route_table" "server_fw_test_rt" {
  provider = aws.primary

  vpc_id = aws_vpc.fw_test_vpc.id

  tags = {
    Name = "server-fw-test-rt"
  }
}

resource "aws_route_table" "gwlbe_fw_test_rt" {
  provider = aws.primary

  vpc_id = aws_vpc.fw_test_vpc.id

  tags = {
    Name = "gwlb-fw-test-rt"
  }
}

resource "aws_route_table" "public_fw_test_rt" {
  provider = aws.primary

  vpc_id = aws_vpc.fw_test_vpc.id

  tags = {
    Name = "public-fw-test-rt"
  }
}

resource "aws_route_table" "tgw_fw_test_rt" {
  provider = aws.primary

  vpc_id = aws_vpc.fw_test_vpc.id

  tags = {
    Name = "tgw-fw-test-rt"
  }
}

####################################################################
# Routing table association
####################################################################
resource "aws_route_table_association" "server_fw_test_rt_assoc_a" {
  provider = aws.primary

  subnet_id      = aws_subnet.server_fw_test_subnet_a.id
  route_table_id = aws_route_table.server_fw_test_rt.id
}

resource "aws_route_table_association" "server_fw_test_rt_assoc_b" {
  provider = aws.primary

  subnet_id      = aws_subnet.server_fw_test_subnet_b.id
  route_table_id = aws_route_table.server_fw_test_rt.id
}

resource "aws_route_table_association" "server_fw_test_rt_assoc_c" {
  provider = aws.primary

  subnet_id      = aws_subnet.server_fw_test_subnet_c.id
  route_table_id = aws_route_table.server_fw_test_rt.id
}

resource "aws_route_table_association" "tgw_fw_test_rt_assoc_a" {
  provider = aws.primary

  subnet_id      = aws_subnet.tgw_fw_test_subnet_a.id
  route_table_id = aws_route_table.tgw_fw_test_rt.id
}

resource "aws_route_table_association" "tgw_fw_test_rt_assoc_b" {
  provider = aws.primary

  subnet_id      = aws_subnet.tgw_fw_test_subnet_b.id
  route_table_id = aws_route_table.tgw_fw_test_rt.id
}

resource "aws_route_table_association" "tgw_fw_test_rt_assoc_c" {
  provider = aws.primary

  subnet_id      = aws_subnet.tgw_fw_test_subnet_c.id
  route_table_id = aws_route_table.tgw_fw_test_rt.id
}

resource "aws_route_table_association" "gwlbe_fw_test_rt_assoc_a" {
  provider = aws.primary

  subnet_id      = aws_subnet.gwlbe_fw_test_subnet_a.id
  route_table_id = aws_route_table.gwlbe_fw_test_rt.id
}

resource "aws_route_table_association" "gwlbe_fw_test_rt_assoc_b" {
  provider = aws.primary

  subnet_id      = aws_subnet.gwlbe_fw_test_subnet_b.id
  route_table_id = aws_route_table.gwlbe_fw_test_rt.id
}

resource "aws_route_table_association" "gwlb_fw_test_rt_assoc_c" {
  provider = aws.primary

  subnet_id      = aws_subnet.gwlbe_fw_test_subnet_c.id
  route_table_id = aws_route_table.gwlbe_fw_test_rt.id
}

resource "aws_route_table_association" "public_fw_test_rt_assoc_a" {
  provider = aws.primary

  subnet_id      = aws_subnet.public_fw_test_subnet_a.id
  route_table_id = aws_route_table.public_fw_test_rt.id
}

resource "aws_route_table_association" "public_fw_test_rt_assoc_b" {
  provider = aws.primary

  subnet_id      = aws_subnet.public_fw_test_subnet_b.id
  route_table_id = aws_route_table.public_fw_test_rt.id
}

resource "aws_route_table_association" "public_fw_test_rt_assoc_c" {
  provider = aws.primary

  subnet_id      = aws_subnet.public_fw_test_subnet_c.id
  route_table_id = aws_route_table.public_fw_test_rt.id
}


#############################################################################
# Routing table content
#############################################################################

resource "aws_route" "public_igw_fw_test_route" {
  provider = aws.primary
  
  route_table_id = aws_route_table.public_fw_test_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.fw_test_igw.id
}

resource "aws_route" "tgw_gwlb_fw_test_route" {
  provider = aws.primary
  
  route_table_id = aws_route_table.tgw_fw_test_rt.id
  destination_cidr_block = "0.0.0.0/0"
  #vpc_endpoint_id = "value"
  network_interface_id = aws_instance.cisco_fw_test_instance_1.primary_network_interface_id
}

resource "aws_route" "server_fw_test_route" {
  provider = aws.primary
  
  route_table_id = aws_route_table.server_fw_test_rt.id
  destination_cidr_block = "10.0.0.0/8"
  core_network_arn = aws_networkmanager_core_network.core_network.arn
 
}


####################################################################################################################################
# Cisco Cat 8000v
####################################################################################################################################

resource "aws_security_group" "server_fw_test_sg" {
  provider = aws.primary
  
  name        = "allow-any"
  description = "Allow anything"
  vpc_id      = aws_vpc.fw_test_vpc.id

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

 resource "aws_instance" "cisco_fw_test_instance_1" {
   provider = aws.primary
   
   ami = "ami-011a3f02bf1fbe77a"
   instance_type = "t3.medium"
   key_name = var.key_name
   vpc_security_group_ids = [aws_security_group.server_fw_test_sg.id]
   subnet_id = aws_subnet.server_fw_test_subnet_a.id
   iam_instance_profile = aws_iam_instance_profile.linux_ec2_instance_profile.name
   private_ip = cidrhost(aws_subnet.server_fw_test_subnet_a.cidr_block, 10)
   associate_public_ip_address = false
   source_dest_check = false

user_data = <<-EOF
Content-Type: multipart/mixed; boundary="===============CISCO=="
MIME-Version: 1.0

--===============CISCO==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="iosxe_config.txt"

hostname fw-test-1
username cisco privilege 15 secret Password123
aaa new-model
aaa authentication login default local
aaa authorization exec default local
ip domain-name csast.cz
crypto key generate rsa general-keys modulus 4096
ip ssh version 2
ip ssh server  authenticate user keyboard
line con 0
 login authentication default
line vty 0 4
 transport input ssh
 login authentication default
interface GigabitEthernet1
 ip address dhcp
 no shut
ip route 0.0.0.0 0.0.0.0 ${cidrhost(aws_subnet.server_fw_prod_subnet_a.cidr_block, 1)}

--===============CISCO==--
EOF

  tags = {
       Name = "cisco-fw-test-instance-1"
   }
 }

# ####################################################################################################################################
# # gateway load balancer
# ####################################################################################################################################

# resource "aws_lb" "fw_test_gwlb" {
#   provider = aws.primary
#   load_balancer_type = "gateway"
#   name = "fw-test-gwlb"
#   internal = true
#   enable_deletion_protection = false

  
#   subnets = [
#     aws_subnet.gwlb_fw_test_subnet_a.id,
#     aws_subnet.gwlb_fw_test_subnet_b.id,
#     aws_subnet.gwlb_fw_test_subnet_c.id
#   ]
#   tags = {
#     Name = "fw-test-gwlb"
#   }
# }

# resource "aws_lb_target_group" "fw_test_tg" {
#   provider = aws.primary
#   name = "fw-test-tg"
#   port = 6081
#   protocol = "GENEVE"
#   target_type = "instance"
#   vpc_id = aws_vpc.fw_test_vpc.id
#   tags = {
#     Name = "fw-test-tg" 
#   }

#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout            = 5
#     interval           = 10
#     protocol           = "TCP"
#     port               = "6081"
#   }
# }

# resource "aws_lb_target_group_attachment" "fw_test_tg_attachment_1" {
#   provider = aws.primary
#   target_group_arn = aws_lb_target_group.fw_test_tg.arn
#   target_id = aws_instance.cisco_fw_test_instance_1.id
#   port = 6081
# }

