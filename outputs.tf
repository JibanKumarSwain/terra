## we can use it foe the count and normal use also

# output "ec2_public_ip" {
#     value = aws_instance.terra[*].public_ip
# }

# output "ec2_public_dns" {
#     value = aws_instance.terra[*].public_dns
  
# }

# output "ec2_private_ip" {
#     value = aws_instance.terra[*].private_ip

# }
  

## for_each outputs

output "ec2_public_ip" {
  value = [
    for instance in aws_instance.terra : instance.public_ip
  ]
}

output "ec2_public_dns" {
  value = [
    for instance in aws_instance.terra : instance.public_dns
  ]
}
  
output "ec2_private_ip" {
  value = [
    for instance in aws_instance.terra : instance.private_ip
  ]
}