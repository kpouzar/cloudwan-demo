################################################################################
# VPC FW TEST
################################################################################

resource "aws_vpc" "fw_prod_vpc" {
  provider = aws.primary
  
  cidr_block           = "10.253.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = {
    Name = "fw-prod-vpc"
  }
}

################################################################################
# Internet Gateway
################################################################################
resource "aws_internet_gateway" "fw_prod_igw" {
  provider = aws.primary
  vpc_id = aws_vpc.fw_prod_vpc.id

  tags = {
    Name = "fw-prod-igw"
  }
}


################################################################################
# Subnets 
################################################################################
resource "aws_subnet" "cw_fw_prod_subnet_a" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_prod_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_prod_vpc.cidr_block, 8, 0)
  availability_zone = "${var.aws_region1}a"

  tags = {
    Name = "cw-fw-prod-subnet-a"
  }
}

resource "aws_subnet" "cw_fw_prod_subnet_b" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_prod_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_prod_vpc.cidr_block, 8, 1)
  availability_zone = "${var.aws_region1}b"

  tags = {
    Name = "cw-fw-prod-subnet-b"
  }
}

resource "aws_subnet" "cw_fw_prod_subnet_c" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_prod_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_prod_vpc.cidr_block, 8, 2)
  availability_zone = "${var.aws_region1}c"

  tags = {
    Name = "cw-fw-prod-subnet-c"
  }
}

resource "aws_subnet" "gwlbe_fw_prod_subnet_a" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_prod_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_prod_vpc.cidr_block, 8, 4)
  availability_zone = "${var.aws_region1}a"

  tags = {
    Name = "gwlbe-fw-prod-subnet-a"
  }
}

resource "aws_subnet" "gwlbe_fw_prod_subnet_b" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_prod_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_prod_vpc.cidr_block, 8, 5)
  availability_zone = "${var.aws_region1}b"


  tags = {
    Name = "gwlbe-fw-prod-subnet-b"
  }
}

resource "aws_subnet" "gwlbe_fw_prod_subnet_c" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_prod_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_prod_vpc.cidr_block, 8, 6)
  availability_zone = "${var.aws_region1}c"


  tags = {
    Name = "gwlbe-fw-prod-subnet-c"
  }
}


resource "aws_subnet" "server_fw_prod_subnet_a" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_prod_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_prod_vpc.cidr_block, 8, 8)
  availability_zone = "${var.aws_region1}a"

  tags = {
    Name = "server-fw-prod-subnet-a"
  }
}

resource "aws_subnet" "server_fw_prod_subnet_b" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_prod_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_prod_vpc.cidr_block, 8, 9)
  availability_zone = "${var.aws_region1}b"

  tags = {
    Name = "server-fw-prod-subnet-b"
  }
}

resource "aws_subnet" "server_fw_prod_subnet_c" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_prod_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_prod_vpc.cidr_block, 8, 10)
  availability_zone = "${var.aws_region1}c"

  tags = {
    Name = "server-fw-prod-subnet-c"
  }
}

resource "aws_subnet" "public_fw_prod_subnet_a" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_prod_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_prod_vpc.cidr_block, 8, 12)
  availability_zone = "${var.aws_region1}a"

  tags = {
    Name = "public-fw-prod-subnet-a"
  }
}

resource "aws_subnet" "public_fw_prod_subnet_b" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_prod_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_prod_vpc.cidr_block, 8, 13)
  availability_zone = "${var.aws_region1}b"


  tags = {
    Name = "public-fw-prod-subnet-b"
  }
}

resource "aws_subnet" "public_fw_prod_subnet_c" {
  provider = aws.primary
  
  vpc_id            = aws_vpc.fw_prod_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.fw_prod_vpc.cidr_block, 8, 14)
  availability_zone = "${var.aws_region1}c"


  tags = {
    Name = "public-fw-prod-subnet-c"
  }
}


#############################################################################
# Routing table create
#############################################################################
resource "aws_route_table" "server_fw_prod_rt" {
  provider = aws.primary

  vpc_id = aws_vpc.fw_prod_vpc.id

  tags = {
    Name = "server-fw-prod-rt"
  }
}

resource "aws_route_table" "gwlbe_fw_prod_rt" {
  provider = aws.primary

  vpc_id = aws_vpc.fw_prod_vpc.id

  tags = {
    Name = "gwlb-fw-prod-rt"
  }
}

resource "aws_route_table" "public_fw_prod_rt" {
  provider = aws.primary

  vpc_id = aws_vpc.fw_prod_vpc.id

  tags = {
    Name = "public-fw-prod-rt"
  }
}

resource "aws_route_table" "cw_fw_prod_rt" {
  provider = aws.primary

  vpc_id = aws_vpc.fw_prod_vpc.id

  tags = {
    Name = "cw-fw-prod-rt"
  }
}

####################################################################
# Routing table association
####################################################################
resource "aws_route_table_association" "server_fw_prod_rt_assoc_a" {
  provider = aws.primary

  subnet_id      = aws_subnet.server_fw_prod_subnet_a.id
  route_table_id = aws_route_table.server_fw_prod_rt.id
}

resource "aws_route_table_association" "server_fw_prod_rt_assoc_b" {
  provider = aws.primary

  subnet_id      = aws_subnet.server_fw_prod_subnet_b.id
  route_table_id = aws_route_table.server_fw_prod_rt.id
}

resource "aws_route_table_association" "server_fw_prod_rt_assoc_c" {
  provider = aws.primary

  subnet_id      = aws_subnet.server_fw_prod_subnet_c.id
  route_table_id = aws_route_table.server_fw_prod_rt.id
}

resource "aws_route_table_association" "cw_fw_prod_rt_assoc_a" {
  provider = aws.primary

  subnet_id      = aws_subnet.cw_fw_prod_subnet_a.id
  route_table_id = aws_route_table.cw_fw_prod_rt.id
}

resource "aws_route_table_association" "cw_fw_prod_rt_assoc_b" {
  provider = aws.primary

  subnet_id      = aws_subnet.cw_fw_prod_subnet_b.id
  route_table_id = aws_route_table.cw_fw_prod_rt.id
}

resource "aws_route_table_association" "cw_fw_prod_rt_assoc_c" {
  provider = aws.primary

  subnet_id      = aws_subnet.cw_fw_prod_subnet_c.id
  route_table_id = aws_route_table.cw_fw_prod_rt.id
}

resource "aws_route_table_association" "gwlbe_fw_prod_rt_assoc_a" {
  provider = aws.primary

  subnet_id      = aws_subnet.gwlbe_fw_prod_subnet_a.id
  route_table_id = aws_route_table.gwlbe_fw_prod_rt.id
}

resource "aws_route_table_association" "gwlbe_fw_prod_rt_assoc_b" {
  provider = aws.primary

  subnet_id      = aws_subnet.gwlbe_fw_prod_subnet_b.id
  route_table_id = aws_route_table.gwlbe_fw_prod_rt.id
}

resource "aws_route_table_association" "gwlb_fw_prod_rt_assoc_c" {
  provider = aws.primary

  subnet_id      = aws_subnet.gwlbe_fw_prod_subnet_c.id
  route_table_id = aws_route_table.gwlbe_fw_prod_rt.id
}

resource "aws_route_table_association" "public_fw_prod_rt_assoc_a" {
  provider = aws.primary

  subnet_id      = aws_subnet.public_fw_prod_subnet_a.id
  route_table_id = aws_route_table.public_fw_prod_rt.id
}

resource "aws_route_table_association" "public_fw_prod_rt_assoc_b" {
  provider = aws.primary

  subnet_id      = aws_subnet.public_fw_prod_subnet_b.id
  route_table_id = aws_route_table.public_fw_prod_rt.id
}

resource "aws_route_table_association" "public_fw_prod_rt_assoc_c" {
  provider = aws.primary

  subnet_id      = aws_subnet.public_fw_prod_subnet_c.id
  route_table_id = aws_route_table.public_fw_prod_rt.id
}


#############################################################################
# Routing table content
#############################################################################

resource "aws_route" "public_igw_fw_prod_route" {
  provider = aws.primary
  
  route_table_id = aws_route_table.public_fw_prod_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.fw_prod_igw.id
}

resource "aws_route" "cw_gwlb_fw_prod_route" {
  provider = aws.primary
  
  route_table_id = aws_route_table.cw_fw_prod_rt.id
  destination_cidr_block = "0.0.0.0/0"
  #vpc_endpoint_id = "value"
  network_interface_id = aws_instance.cisco_fw_prod_instance_1.primary_network_interface_id
}

resource "aws_route" "server_fw_prod_route" {
  provider = aws.primary
  depends_on = [ aws_networkmanager_core_network_policy_attachment.cloudwan_better_policy_attachment]

  route_table_id = aws_route_table.server_fw_prod_rt.id
  destination_cidr_block = "0.0.0.0/0"
  core_network_arn = aws_networkmanager_core_network.core_network.arn
 
}


####################################################################################################################################
# Cisco Cat 8000v
####################################################################################################################################

resource "aws_security_group" "server_fw_prod_sg" {
  provider = aws.primary
  
  name        = "allow-any"
  description = "Allow anything"
  vpc_id      = aws_vpc.fw_prod_vpc.id

# Allow all inbound traffic for proding purposes
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

 resource "aws_instance" "cisco_fw_prod_instance_1" {
   provider = aws.primary
   
   ami = "ami-011a3f02bf1fbe77a"
   instance_type = "t3.medium"
   key_name = var.key_name
   vpc_security_group_ids = [aws_security_group.server_fw_prod_sg.id]
   subnet_id = aws_subnet.server_fw_prod_subnet_a.id
   iam_instance_profile = aws_iam_instance_profile.linux_ec2_instance_profile.name
   private_ip = cidrhost(aws_subnet.server_fw_prod_subnet_a.cidr_block, 10)
   associate_public_ip_address = false
   source_dest_check = false

   user_data = <<-EOF
Section: IOS configuration 
hostname fw-prod-1
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
EOF

  tags = {
       Name = "cisco-fw-prod-instance-1"
   }
 }

# ####################################################################################################################################
# # gateway load balancer
# ####################################################################################################################################

# resource "aws_lb" "fw_prod_gwlb" {
#   provider = aws.primary
#   load_balancer_type = "gateway"
#   name = "fw-prod-gwlb"
#   internal = true
#   enable_deletion_protection = false

  
#   subnets = [
#     aws_subnet.gwlb_fw_prod_subnet_a.id,
#     aws_subnet.gwlb_fw_prod_subnet_b.id,
#     aws_subnet.gwlb_fw_prod_subnet_c.id
#   ]
#   tags = {
#     Name = "fw-prod-gwlb"
#   }
# }

# resource "aws_lb_target_group" "fw_prod_tg" {
#   provider = aws.primary
#   name = "fw-prod-tg"
#   port = 6081
#   protocol = "GENEVE"
#   target_type = "instance"
#   vpc_id = aws_vpc.fw_prod_vpc.id
#   tags = {
#     Name = "fw-prod-tg" 
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

# resource "aws_lb_target_group_attachment" "fw_prod_tg_attachment_1" {
#   provider = aws.primary
#   target_group_arn = aws_lb_target_group.fw_prod_tg.arn
#   target_id = aws_instance.cisco_fw_prod_instance_1.id
#   port = 6081
# }

