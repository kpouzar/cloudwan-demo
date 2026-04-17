
resource aws_networkmanager_global_network "global_network" {
    provider = aws.primary
    
    description = "Global Network for CloudWAN demo"
}


data "aws_networkmanager_core_network_policy_document" "cloudwan_base_policy" {
  version = "2025.11"

  core_network_configuration {
    asn_ranges = ["65500-65510"]

    edge_locations {
      location = var.aws_region1
      asn      = "65500"
    }

    # edge_locations {
    #   location = var.aws_region2
    #   asn      = "65501"
    # }
  }

  segments {
    name = "test"
  }

 }


resource "aws_networkmanager_core_network" "core_network" {
  provider = aws.primary
  
  global_network_id = aws_networkmanager_global_network.global_network.id
  description       = "Core Network for CloudWAN lab"

  base_policy_document = data.aws_networkmanager_core_network_policy_document.cloudwan_base_policy.json
  create_base_policy   = true

  tags = {
    Name = "cloudwan-core-network"
  }
}

########################################################################################################################
# CloudWAN Attachments
########################################################################################################################


resource "aws_networkmanager_vpc_attachment" "vpc_region1_attachment" {
  provider = aws.primary
  count = 4

  core_network_id = aws_networkmanager_core_network.core_network.id
  subnet_arns     = [aws_subnet.tgw_a_region1_subnet[count.index].arn]
  vpc_arn         = aws_vpc.region1_vpc[count.index].arn
  
  tags = {
    Name = "vpc${count.index}-${var.aws_region1}-attachment"
    Environment = var.vpc_environment[count.index]
  }
}

# resource "aws_networkmanager_attachment_routing_policy_label" "vpc_region1_attachment_label" {
#   provider = aws.primary
#   count = 4

#   core_network_id      = aws_networkmanager_core_network.core_network.id
#   attachment_id        = aws_networkmanager_vpc_attachment.vpc_region1_attachment[count.index].id
#   routing_policy_label = "${var.attachment_policy_label[count.index]}"
# }

resource "aws_networkmanager_vpc_attachment" "fw_prod_attachment" {
  provider = aws.primary

  core_network_id = aws_networkmanager_core_network.core_network.id
  subnet_arns     = [aws_subnet.cw_fw_prod_subnet_a.arn, aws_subnet.cw_fw_prod_subnet_b.arn, aws_subnet.cw_fw_prod_subnet_c.arn]
  vpc_arn         = aws_vpc.fw_prod_vpc.arn
  
  tags = {
    Name = "vpc-fw-prod-attachment"
    Environment = "fwprod"
  }
}

resource "aws_networkmanager_vpc_attachment" "fw_test_attachment" {
  provider = aws.primary

  core_network_id = aws_networkmanager_core_network.core_network.id
  subnet_arns     = [aws_subnet.cw_fw_test_subnet_a.arn, aws_subnet.cw_fw_test_subnet_b.arn, aws_subnet.cw_fw_test_subnet_c.arn]
  vpc_arn         = aws_vpc.fw_test_vpc.arn
  
  tags = {
    Name = "vpc-fw-test-attachment"
    Environment = "fwtest"
  }
}

resource "aws_networkmanager_vpc_attachment" "vpc_rtr_test_attachment" {
  provider = aws.primary

  core_network_id = aws_networkmanager_core_network.core_network.id
  subnet_arns     = [aws_subnet.cw_rtr_test_subnet_a.arn, aws_subnet.cw_rtr_test_subnet_b.arn, aws_subnet.cw_rtr_test_subnet_c.arn]
  vpc_arn         = aws_vpc.rtr_test_vpc.arn
  
  tags = {
    Name = "vpc-rtr-test-attachment"
    Environment = "rtrtest"
  }
}

resource "aws_networkmanager_connect_attachment" "cisco_rtr_test_connect_attachment" {
  provider = aws.primary

  core_network_id = aws_networkmanager_core_network.core_network.id
  transport_attachment_id = aws_networkmanager_vpc_attachment.vpc_rtr_test_attachment.id
  edge_location = var.aws_region1
  options {
    protocol = "NO_ENCAP"
  }
  tags = {
    Name = "connect-rtr-test-vpc-attachment"
    Environment = "rtrtest"
  }
}

resource "aws_networkmanager_connect_peer" "cisco_rtr_test_peer_1" {
  provider = aws.primary
  
  subnet_arn = aws_subnet.cw_rtr_test_subnet_a.arn
  connect_attachment_id = aws_networkmanager_connect_attachment.cisco_rtr_test_connect_attachment.id
  peer_address = aws_network_interface.cisco_dxc_1_g3_int.private_ip

  bgp_options {
    peer_asn = 65530
  }
  
  tags = {
    Name = "cisco-1-rtr-test-peer"
    Environment = "rtrtest"
  }
}

resource "aws_networkmanager_vpc_attachment" "vpc_rtr_prod_attachment" {
  provider = aws.primary

  core_network_id = aws_networkmanager_core_network.core_network.id
  subnet_arns     = [aws_subnet.cw_rtr_prod_subnet_a.arn, aws_subnet.cw_rtr_prod_subnet_b.arn, aws_subnet.cw_rtr_prod_subnet_c.arn]
  vpc_arn         = aws_vpc.rtr_prod_vpc.arn
  
  tags = {
    Name = "vpc-rtr-prod-attachment"
    Environment = "rtrprod"
  }
}

resource "aws_networkmanager_connect_attachment" "cisco_rtr_prod_connect_attachment" {
  provider = aws.primary

  core_network_id = aws_networkmanager_core_network.core_network.id
  transport_attachment_id = aws_networkmanager_vpc_attachment.vpc_rtr_prod_attachment.id
  edge_location = var.aws_region1
  options {
    protocol = "NO_ENCAP"
  }
  tags = {
    Name = "connect-rtr-prod-vpc-attachment"
    Environment = "rtrprod"
  }
}

resource "aws_networkmanager_connect_peer" "cisco_rtr_prod_peer_1" {
  provider = aws.primary
  
  subnet_arn = aws_subnet.cw_rtr_prod_subnet_a.arn
  connect_attachment_id = aws_networkmanager_connect_attachment.cisco_rtr_prod_connect_attachment.id
  peer_address = aws_network_interface.cisco_dxc_1_g4_int.private_ip

  bgp_options {
    peer_asn = 65530
  }
  
  tags = {
    Name = "cisco-1-rtr-prod-peer"
    Environment = "rtrprod"
  }
}

resource "aws_networkmanager_transit_gateway_route_table_attachment" "eg_test_rt_attachment" {
  provider = aws.primary

  transit_gateway_route_table_arn = aws_ec2_transit_gateway_route_table.eg_test_rt.arn
  peering_id = aws_networkmanager_transit_gateway_peering.eg_tgw_cwan_peering.id
  
  tags = {
    Name = "tgw-eg-test-rt-attachment"
    Environment = "rtrtest"
  }
}

resource "aws_networkmanager_transit_gateway_route_table_attachment" "eg_prod_rt_attachment" {
  provider = aws.primary

  transit_gateway_route_table_arn = aws_ec2_transit_gateway_route_table.eg_prod_rt.arn
  peering_id = aws_networkmanager_transit_gateway_peering.eg_tgw_cwan_peering.id
  
  tags = {
    Name = "tgw-eg-prod-rt-attachment"
    Environment = "rtrprod"
  }
}


########################################################################################################################
# CloudWAN TGW peering
########################################################################################################################

resource "aws_networkmanager_transit_gateway_peering" "eg_tgw_cwan_peering" {
  provider = aws.primary
  depends_on = [ aws_networkmanager_core_network_policy_attachment.cloudwan_better_policy_attachment]

  core_network_id = aws_networkmanager_core_network.core_network.id
  transit_gateway_arn = aws_ec2_transit_gateway.eg_tgw.arn

  tags = {
    Name = "tgw-cwan-peering"
  }
}

resource "aws_ec2_transit_gateway_policy_table_association" "eg_tgw_policy_table_association" {
 provider = aws.primary

 transit_gateway_policy_table_id = aws_ec2_transit_gateway_policy_table.eg_tgw_policy_table.id
 transit_gateway_attachment_id = aws_networkmanager_transit_gateway_peering.eg_tgw_cwan_peering.transit_gateway_peering_attachment_id
}

########################################################################################################################
# CloudWAN Policy
########################################################################################################################

data "aws_networkmanager_core_network_policy_document" "cloudwan_better_policy" {
  version = "2025.11"

  core_network_configuration {
    asn_ranges = ["65500-65510"]
    inside_cidr_blocks = [ "10.250.0.0/24" ]

    edge_locations {
      location = var.aws_region1
      asn      = "65500"
      inside_cidr_blocks = [ "10.250.0.0/24" ]
    }

    # edge_locations {
    #   location = var.aws_region2
    #   asn      = "65501"
    # }
  }

  segments {
    name = "test"
    require_attachment_acceptance = false
    isolate_attachments = true
  }

  segments {
    name = "prod"
    require_attachment_acceptance = false
    isolate_attachments = true
  }

  segments {
    name = "rtrtest"
    require_attachment_acceptance = false
    isolate_attachments = false
  }
  segments {
    name = "rtrprod"
    require_attachment_acceptance = false
    isolate_attachments = false
  }

  network_function_groups {
    name = "fwtest"
    require_attachment_acceptance = false
  }
  network_function_groups {
    name = "fwprod"
    require_attachment_acceptance = false
  }

########################################################################################################################
# Tag-based Attachment Policy 
########################################################################################################################

  attachment_policies {
    rule_number = 100
    condition_logic = "and"
    conditions {
      type     = "tag-exists"
      key      = "Environment"
      
    }
    action {
      association_method = "tag"
      tag_value_of_key = "Environment"
      
    }
  }

########################################################################################################################
# Segment Actions  
########################################################################################################################

  segment_actions {
    action = "send-via"
    segment = "test"
    mode = "dual-hop"
    via {
      network_function_groups = [ "fwtest" ]
    }
  }

  segment_actions {
    action = "send-via"
    segment = "prod"
    mode = "dual-hop"
    via {
      network_function_groups = [ "fwprod" ]
    }
  }

  segment_actions {
    action = "send-via"
    segment = "test"
    mode = "dual-hop"
    when_sent_to {
     segments = ["rtrtest"]
    }
    via {
      network_function_groups = [ "fwtest" ]
    }
  }

  segment_actions {
    action = "send-via"
    segment = "prod"
    mode = "dual-hop"
    when_sent_to {
     segments = ["rtrprod"]
    }
    via {
      network_function_groups = [ "fwprod" ]
    }
  }


########################################################################################################################
# Routing Policies for attached VPCs
########################################################################################################################

#   routing_policies {
#     routing_policy_name = "labelTestRp"
#     routing_policy_description = "label traffic from test segment with a tag"
#     routing_policy_number = 10
#     routing_policy_direction = "outbound"

#     routing_policy_rules {
#       rule_number = 10
#       rule_definition {
#         condition_logic = "or"
#         match_conditions {
#           type = "prefix-equals"
#           value = "10.0.0.0/16"
#         }
#         action {
# #           type = "add-community"
# #           value = "100:100" 
#             type = "allow"  
#         }
#       }
#     }
#   }

#   routing_policies {
#     routing_policy_name = "labelProdRp"
#     routing_policy_description = "label traffic from prod segment with a tag"
#     routing_policy_number = 11
#     routing_policy_direction = "outbound"

#     routing_policy_rules {
#       rule_number = 10
#       rule_definition {
#         condition_logic = "or"
#         match_conditions {
#           type = "prefix-equals"
#           value = "10.2.0.0/16"
#         }
#         action {
# #           type = "add-community"
# #           value = "100:200" 
#             type = "allow"
#         }
#       }
#     }
#   }

#   attachment_routing_policy_rules {
#     rule_number = 100
#     description = "label connected routes test"    
#     conditions {
#       type = "routing-policy-label"
#       value = "labelTestRequest"
#     }
#     action {
#       associate_routing_policies = [ "labelTestRp" ]
#     }
#   }

#   attachment_routing_policy_rules {
#     rule_number = 200
#     description = "label connected routes prod"
#     conditions {
#       type = "routing-policy-label"
#       value = "labelProdRequest"
#     }
#     action {
#       associate_routing_policies = [ "labelProdRp" ]
#     }
#   }
  

########################################################################################################################
# Routing Policies inside
########################################################################################################################

  # routing_policies {
  #   routing_policy_name = "ImportProdRp"
  #   routing_policy_description = "filter routes into prod segment"
  #   routing_policy_number = 20
  #   routing_policy_direction = "inbound"

  #   routing_policy_rules {
  #     rule_number = 10
  #     rule_definition {
  #       match_conditions {
  #         type = "prefix-equals"
  #         value = "10.0.0.0/16"
  #       }
  #       action {
  #          type = "allow"
  #       }
  #     }
  #   }
  #   routing_policy_rules {
  #     rule_number = 20
  #     rule_definition {
  #       match_conditions {
  #         type = "prefix-in-cidr"
  #         value = "0.0.0.0/0"
  #       }
  #       action {
  #          type = "drop"
  #       }
  #     }
  #   }
  # }

  # routing_policies {
  #   routing_policy_name = "ImportDevRp"
  #   routing_policy_description = "filter routes into dev segment"
  #   routing_policy_number = 21
  #   routing_policy_direction = "inbound"

  #   routing_policy_rules {
  #     rule_number = 10
  #     rule_definition {
  #       match_conditions {
  #         type = "prefix-equals"
  #         value = "10.2.0.0/16"
  #       }
  #       action {
  #          type = "allow"
  #       }
  #     }
  #   }
  #   routing_policy_rules {
  #     rule_number = 20
  #     rule_definition {
  #       match_conditions {
  #         type = "prefix-in-cidr"
  #         value = "0.0.0.0/0"
  #       }
  #       action {
  #          type = "drop"
  #       }
  #     }
  #   }
  # }



  # segment_actions {
  #   action = "share"
  #   mode  = "attachment-route"
  #   segment = "test"
  #   share_with = [ "prod" ]
  #   routing_policy_names = [ "importProdRp", "importTestRp" ]
  # }
}


resource "aws_networkmanager_core_network_policy_attachment" "cloudwan_better_policy_attachment" {
  depends_on = [ aws_networkmanager_vpc_attachment.vpc_region1_attachment[0],
                  aws_networkmanager_vpc_attachment.vpc_region1_attachment[1],
                  aws_networkmanager_vpc_attachment.vpc_region1_attachment[2],
                  aws_networkmanager_vpc_attachment.vpc_region1_attachment[3],            
     ] 
  core_network_id = aws_networkmanager_core_network.core_network.id
  policy_document = data.aws_networkmanager_core_network_policy_document.cloudwan_better_policy.json     
  
}

