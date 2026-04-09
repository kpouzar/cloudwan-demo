
resource aws_networkmanager_global_network "global_network" {
    provider = aws.primary
    
    description = "Global Network for CloudWAN demo"
}


data "aws_networkmanager_core_network_policy_document" "cloudwan_base_policy" {
  version = "2025.11"

  core_network_configuration {
    asn_ranges = ["65022-65534"]

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
  description       = "Core Network for CloudWAN demo"

  base_policy_document = data.aws_networkmanager_core_network_policy_document.cloudwan_base_policy.json
  create_base_policy   = true
}

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


# resource "aws_networkmanager_vpc_attachment" "vpc_region2_attachment" {
#   provider = aws.secondary
#   count = var.vpc_amount

#   core_network_id = aws_networkmanager_core_network.core_network.id
#   subnet_arns     = [aws_subnet.tgw_a_region2_subnet[count.index].arn]
#   vpc_arn         = aws_vpc.region2_vpc[count.index].arn
  
#   tags = {
#     Name = "vpc${count.index}-${var.aws_region2}-attachment"
#     Environment = var.vpc_environment[count.index]
#   }
# }


data "aws_networkmanager_core_network_policy_document" "cloudwan_better_policy" {
  version = "2025.11"

  core_network_configuration {
    asn_ranges = ["65500-65534"]
    inside_cidr_blocks = [ "10.254.0.0/24" ]

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
    require_attachment_acceptance = false
    isolate_attachments = true
  }

  segments {
    name = "prod"
    require_attachment_acceptance = false
    isolate_attachments = true
  }

  segments {
    name = "dc"
    require_attachment_acceptance = false
    isolate_attachments = false
  }
  segments {
    name = "eg"
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

  segment_actions {
    action = "send-to"
    segment = "test"
    via {
    network_function_groups = [ "fwtest" ]
    }
  }
  segment_actions {
    action = "send-to"
    segment = "prod"
    via {
    network_function_groups = [ "fwprod" ]
    }
  }
}

resource "aws_networkmanager_core_network_policy_attachment" "cloudwan_better_policy_attachment" {
  depends_on = [ aws_networkmanager_vpc_attachment.vpc_region1_attachment[0],
                  aws_networkmanager_vpc_attachment.vpc_region1_attachment[1],
                  aws_networkmanager_vpc_attachment.vpc_region1_attachment[2],
                  aws_networkmanager_vpc_attachment.vpc_region1_attachment[3],
                  aws_networkmanager_vpc_attachment.vpc_region1_attachment[4],
                  aws_networkmanager_vpc_attachment.vpc_region1_attachment[5]                  
     ] 
  core_network_id = aws_networkmanager_core_network.core_network.id
  policy_document = data.aws_networkmanager_core_network_policy_document.cloudwan_better_policy.json     
}

