
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

    edge_locations {
      location = var.aws_region2
      asn      = "65501"
    }
  }

  segments {
    name = "dev"
  }

 }


resource "aws_networkmanager_core_network" "core_network" {
  provider = aws.primary
  
  global_network_id = aws_networkmanager_global_network.global_network.id
  description       = "Core Network for CloudWAN demo"

  base_policy_document = data.aws_networkmanager_core_network_policy_document.cloudwan_base_policy.json
  create_base_policy   = true
}


data "aws_networkmanager_core_network_policy_document" "cloudwan_better_policy" {
  version = "2025.11"

  core_network_configuration {
    asn_ranges = ["65022-65534"]

    edge_locations {
      location = var.aws_region1
      asn      = "65500"
    }

    edge_locations {
      location = var.aws_region2
      asn      = "65501"
    }
  }

  segments {
    name = "dev"
  }

  segments {
    name = "prod"
  }

  segment_actions {
    action  = "create-route"
    segment = "dev"
    destination_cidr_blocks = [
      aws_vpc.region1_vpc[0].cidr_block
    ]
    destinations = [
      aws_networkmanager_vpc_attachment.vpc0_region1_attachment.id,
    ]
  }

  segment_actions {
    action  = "create-route"
    segment = "dev"
    destination_cidr_blocks = [
      aws_vpc.region2_vpc[0].cidr_block
    ]
    destinations = [
      aws_networkmanager_vpc_attachment.vpc0_region2_attachment.id,
    ]
  }

  segment_actions {
    action  = "create-route"
    segment = "prod"
    destination_cidr_blocks = [
      aws_vpc.region1_vpc[1].cidr_block
    ]
    destinations = [
      aws_networkmanager_vpc_attachment.vpc1_region1_attachment.id,
    ]
  }

  segment_actions {
    action  = "create-route"
    segment = "prod"
    destination_cidr_blocks = [
      aws_vpc.region2_vpc[1].cidr_block
    ]
    destinations = [
      aws_networkmanager_vpc_attachment.vpc1_region2_attachment.id,
    ]
  }

}

resource "aws_networkmanager_core_network_policy_attachment" "cloudwan_better_policy_attachment" {
  core_network_id = aws_networkmanager_core_network.core_network.id
  policy_document = data.aws_networkmanager_core_network_policy_document.cloudwan_better_policy.json     
}

resource "aws_networkmanager_vpc_attachment" "vpc0_region1_attachment" {
  provider = aws.primary

  core_network_id = aws_networkmanager_core_network.core_network.id
  subnet_arns     = [aws_subnet.tgw_a_region1_subnet[0].arn]
  vpc_arn         = aws_vpc.region1_vpc[0].arn
}

resource "aws_networkmanager_vpc_attachment" "vpc1_region1_attachment" {
  provider = aws.primary

  core_network_id = aws_networkmanager_core_network.core_network.id
  subnet_arns     = [aws_subnet.tgw_a_region1_subnet[1].arn]
  vpc_arn         = aws_vpc.region1_vpc[1].arn
}


resource "aws_networkmanager_vpc_attachment" "vpc0_region2_attachment" {
  provider = aws.secondary

  core_network_id = aws_networkmanager_core_network.core_network.id
  subnet_arns     = [aws_subnet.tgw_a_region2_subnet[0].arn]
  vpc_arn         = aws_vpc.region2_vpc[0].arn
}

resource "aws_networkmanager_vpc_attachment" "vpc1_region2_attachment" {
  provider = aws.secondary    

  core_network_id = aws_networkmanager_core_network.core_network.id
  subnet_arns     = [aws_subnet.tgw_a_region2_subnet[1].arn]
  vpc_arn         = aws_vpc.region2_vpc[1].arn
}
