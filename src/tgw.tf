# aws trasint gateway peered with cloudwan
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


# tgw rt
resource "aws_ec2_transit_gateway_route_table" "eg_tgw_rt" {
    provider = aws.primary
    transit_gateway_id = aws_ec2_transit_gateway.eg_tgw.id
    tags = {
        Name = "eg-tgw-rt"
    }
}

resource "aws_ec2_transit_gateway_route_table" "dc_tgw_rt" {
    provider = aws.primary
    transit_gateway_id = aws_ec2_transit_gateway.eg_tgw.id
    tags = {
        Name = "dc-tgw-rt"
    }
}

# resource "aws_ec2_transit_gateway_route" "eg_tgw_rt_route_1" {
#     provider = aws.primary
#     destination_cidr_block = "1.0.0.0/8"
#     blackhole = true
#     transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.eg_tgw_rt.id
# }

# resource "aws_ec2_transit_gateway_route" "eg_tgw_rt_route_2" {
#     provider = aws.primary
#     destination_cidr_block = "2.0.0.0/8"
#     transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.eg_tgw_rt.id
# }

