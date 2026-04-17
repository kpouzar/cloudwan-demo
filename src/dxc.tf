
resource "aws_dx_gateway" "dxc_gw" {
  provider = aws.primary
  
  name            = "dxc-gw"
  amazon_side_asn = 65499

  tags = {
    Name = "dxc-gw"
  }
}

resource "aws_vpn_gateway" "dxc_vpn_gw" {
  provider = aws.primary

  vpc_id = aws_vpc.dxc_vpc.id

  tags = {
    Name = "dxc-vpn-gw"
  }
}


resource "aws_dx_gateway_association" "dxc_gw_assoc" {
  provider = aws.primary

  dx_gateway_id = aws_dx_gateway.dxc_gw.id
  associated_gateway_id = aws_vpn_gateway.dxc_vpn_gw.id
}

# resource "aws_dx_gateway_association_proposal" "dxc_gw_assoc_proposal" {
#   provider = aws.primary

#   dx_gateway_id = aws_dx_gateway.dxc_gw.id
#   vpn_gateway_id = aws_vpn_gateway.dxc_vpn_gw.id

#   tags = {
#     Name = "dxc-gw-assoc-proposal"
#   }
# }

# resource "aws_dx_gateway_association_proposal_accepter" "dxc_gw_assoc_proposal_accepter" {
#   provider = aws.primary

#   dx_gateway_id = aws_dx_gateway.dxc_gw.id
#   vpn_gateway_id = aws_vpn_gateway.dxc_vpn_gw.id

#   tags = {
#     Name = "dxc-gw-assoc-proposal-accepter"
#   }
# }

# resource "aws_dx_gateway_attachment" "dxc_gw_attachment" {
#   provider = aws.primary

#   dx_gateway_id = aws_dx_gateway.dxc_gw.id
#   vpn_gateway_id = aws_vpn_gateway.dxc_vpn_gw.id

#   tags = {
#     Name = "dxc-gw-attachment"
#   }

#     attachment_policy {
#         attachment_policy_label = "labelDxcRequest"
#         attachment_policy_rule_number = 100
#         attachment_policy_action = "accept" 
        
