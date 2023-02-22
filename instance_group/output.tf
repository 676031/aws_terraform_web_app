output "web1_id" {
  value = "${aws_instance.nginx_server[0].id}"
}

output "web2_id" {
  value = "${aws_instance.nginx_server[1].id}"
}