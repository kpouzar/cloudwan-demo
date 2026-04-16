########################################################################################################################
# Transit Gateway 
########################################################################################################################

resource "aws_ec2_transit_gateway" "eg_tgw" {
    provider = aws.primary
    description = "EG Transit Gateway for CloudWAN demo"
    amazon_side_asn = 64512
    auto_accept_shared_attachments = "enable"
    default_route_table_association = "disable"
    default_route_table_propagation = "disable"
    dns_support = "enable"
    vpn_ecmp_support = "enable"
    tags = {
        Name = "eg-tgw"
    }
}

########################################################################################################################
# Transit Gateway - EG TEST 
########################################################################################################################

resource "aws_ec2_transit_gateway_route_table" "eg_test_rt" {
    provider = aws.primary
    transit_gateway_id = aws_ec2_transit_gateway.eg_tgw.id
    tags = {
        Name = "eg-test-rt"
    }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "eg_test_vpc_attachment" {
    provider = aws.primary
    transit_gateway_id = aws_ec2_transit_gateway.eg_tgw.id
    vpc_id = aws_vpc.region1_vpc[4].id
    subnet_ids = [aws_subnet.tgw_a_region1_subnet[4].id]
    tags = {
        Name = "eg-test-vpc-attachment"
    }
}

resource "aws_ec2_transit_gateway_route_table_association" "eg_test_rt_association" {
    provider = aws.primary
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.eg_test_vpc_attachment.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.eg_test_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "eg_test_rt_propagation" {
    provider = aws.primary
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.eg_test_vpc_attachment.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.eg_test_rt.id
}


########################################################################################################################
# Transit Gateway EG PROD
########################################################################################################################


resource "aws_ec2_transit_gateway_route_table" "eg_prod_rt" {
    provider = aws.primary
    transit_gateway_id = aws_ec2_transit_gateway.eg_tgw.id
    tags = {
        Name = "eg-prod-rt"
    }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "eg_prod_vpc_attachment" {
    provider = aws.primary
    transit_gateway_id = aws_ec2_transit_gateway.eg_tgw.id
    vpc_id = aws_vpc.region1_vpc[5].id
    subnet_ids = [aws_subnet.tgw_a_region1_subnet[5].id]
    tags = {
        Name = "eg-prod-vpc-attachment"
    }
}

resource "aws_ec2_transit_gateway_route_table_association" "eg_prod_rt_association" {
    provider = aws.primary
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.eg_prod_vpc_attachment.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.eg_prod_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "eg_prod_rt_propagation" {
    provider = aws.primary
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.eg_prod_vpc_attachment.id
    transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.eg_prod_rt.id
}

########################################################################################################################
# Transit Gateway - policy table
########################################################################################################################

resource "aws_ec2_transit_gateway_policy_table" "eg_tgw_policy_table" {
    provider = aws.primary
    transit_gateway_id = aws_ec2_transit_gateway.eg_tgw.id
    tags = {
        Name = "eg-policy-table"
     }
}