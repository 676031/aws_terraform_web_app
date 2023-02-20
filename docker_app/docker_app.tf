# resource "docker_container" "web1" {
#   name  = "web1"
#   image = "nginx:latest"
#   ports {
#     internal = 80
#     external = 80
#   }
#   volumes {
#     container_path = "/usr/share/nginx/html"
#     host_path      = "/tmp/web1"
#     read_only      = true
#   }
#   depends_on = [aws_instance.web1]
#   connection {
#     type     = "ssh"
#     user     = "ec2-user"
#     host     = aws_instance.web1.public_ip
#     private_key = file("~/.ssh/terraform-key.pem")
#   }
# }

# resource "docker_container" "web2" {
#   name  = "web2"
#   image = "nginx:latest"
#   ports {
#     internal = 80
#     external = 80
#   }
#   volumes {
#     container_path = "/usr/share/nginx/html"
#     host_path      = "/tmp/web2"
#     read_only      = true
#   }
#   # depends_on = [aws_instance.web2]
#   connection {
#     type     = "ssh"
#     user     = "ec2-user"
#     host     = aws_instance.web2.public_ip
#     private_key = file("~/.ssh/terraform-key.pem")
#   }
# }

# resource "local_file" "web1" {
#   content  = "Hello world from web1"
#   filename = "/tmp/web1/index.html"
# }

# resource "local_file" "web2" {
#   content  = "Hello world from web2"
#   filename = "/tmp/web2/index.html"
# }