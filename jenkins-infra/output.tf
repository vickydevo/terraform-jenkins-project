output "instance_id" {
    value = aws_instance.jenkins.id
  
}

output "instance_public_ip" {
    value = aws_instance.jenkins.public_ip
}

output "key_name" {
    value = aws_key_pair.window_local_key.key_name
  
}

