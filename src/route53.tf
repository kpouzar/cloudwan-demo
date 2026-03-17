resource "aws_route53_record" "server_region1_record" {
  count = var.vpc_amount

  zone_id = "Z081605934KVE1T6VIU41"
  name    = "server${count.index}-${var.aws_region1}-cloudwandemo.aleftest.eu"
  type    = "A"
  ttl     = 300
  records = [aws_instance.linux_region1_instance[count.index].public_ip]
}

# resource "aws_route53_record" "server_region2_record" {
#   count = var.vpc_amount

#   zone_id = "Z081605934KVE1T6VIU41"
#   name    = "server${count.index}-${var.aws_region2}-cloudwandemo.aleftest.eu"
#   type    = "A"
#   ttl     = 300
#   records = [aws_instance.linux_region2_instance[count.index].public_ip]
# }

