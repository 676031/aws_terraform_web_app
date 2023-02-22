data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "nginx_server" {
  # ami           = "ami-0c94855ba95c71c99"
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = "terraform-key"
  count         = 2
  associate_public_ip_address = true

  # Add tags to the instances with the same prefix name
  tags = {
    Name = "Nginx Server ${count.index + 1}"
  }

  # Add the security group for HTTP traffic to the instances
  vpc_security_group_ids = [var.security_group_id]

  # Place each instance in a different subnet
  subnet_id = count.index == 0 ? var.subnet_id_1 : var.subnet_id_2

  # Configure the Nginx container with a custom "Hello, World!" page
  user_data = <<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y nginx
              echo "Hello, World!" > /var/www/html/index.html
              apt-get install -y awscli
              EOF
}

#               # aws elbv2 register-targets --target-group-arn ${var.aws_alb_target_group_arn} --targets Id=${self.private_ip}

# Output the public IPs of the instances
output "public_ips" {
  value = [
    for instance in aws_instance.nginx_server :
    instance.public_ip
    if contains(keys(instance.tags), "Name") && instance.tags.Name == "Nginx Server 1" || instance.tags.Name == "Nginx Server 2"
  ]
}

# resource "aws_instance" "web1" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t2.micro"
#   subnet_id     = var.subnet_id_1
#   vpc_security_group_ids = [var.security_group_id]
#   key_name      = "terraform-key"

#   tags = {
#     Name = "web1"
#   }

#   user_data = <<-EOF
#               #!/bin/bash
#               sudo yum update -y
#               sudo amazon-linux-extras install docker -y
#               sudo service docker start
#               sudo usermod -a -G docker ec2-user
#               docker run -d -p 80:80 nginx
#               echo "Hello, World!" > /var/www/html/index.html
#               EOF
# }

# resource "aws_instance" "web2" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t2.micro"
#   subnet_id     = var.subnet_id_2
#   vpc_security_group_ids = [var.security_group_id]
#   key_name      = "terraform-key"

#   tags = {
#     Name = "web2"
#   }

#   user_data = <<-EOF
#               #!/bin/bash
#               sudo yum update -y
#               sudo amazon-linux-extras install docker -y
#               sudo service docker start
#               sudo usermod -a -G docker ec2-user
#               docker run -d -p 80:80 nginx
#               echo "Hello, World!" > /var/www/html/index.html
#               EOF
# }

# output "public_ips" {
#   value = aws_instance.nginx_server.*.public_ip
# }