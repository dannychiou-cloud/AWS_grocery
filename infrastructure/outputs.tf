output "ec2_instance_id" {
  value = aws_instance.grocerymate_ec2.id
}

output "ec2_public_ip" {
  value = aws_instance.grocerymate_ec2.public_ip
}

output "ec2_public_dns" {
  value = aws_instance.grocerymate_ec2.public_dns
}

output "selected_ami_id" {
  value = data.aws_ami.amazon_linux.id
}