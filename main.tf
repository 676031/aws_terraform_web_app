#Тестове завдання :
#Написати на ansible/terraform підняття 2 інстансів web1 і web2 в окремій VPC та ALB для балансування навантаження між цими серверами 
#На серверах web1 і web2 за допомогою ansible/terraform підняти "Hello world" сторінку в Nginx контейнері 
#Відкрити доступ на nginx (http://nginx.org/en/docs/http/ngx_http_access_module.html) до сторінки "Hello world" з IP пулів CloudFront та EC2 (IP можна отримати по API  https://ip-ranges.amazonaws.com/ip-ranges.json ) (таск з зірочкою)

// KMS,S3,Dynamodb
module "s3bucket_dynamodb" {
  source = "./s3bucket_dynamodb/"
}

// VPC,Subnet,Router,NAT,Firewall
module "networking" {
  source = "./networking/"
}

// Forwarding rules, Target HTTP Proxy, URL-map, LB-backend, HealthCheck
module "http_lb" {
  source         = "./http_lb/"
  # id = module.networking
  # instance_group = module.instance_group.igm_instance_group
  security_group_id = module.networking.aws_security_group_id
  subnet_id_1 = module.networking.subnet_id_1
  subnet_id_2 = module.networking.subnet_id_2
  aws_vpc_id = module.networking.aws_vpc_id
  web1_id = module.instance_group.web1_id
  web2_id = module.instance_group.web2_id
}

# module "docker_app" {
#   source = "./docker_app/"

# }

module "instance_group" {
  source = "./instance_group/"
  subnet_id_1 = module.networking.subnet_id_1
  subnet_id_2 = module.networking.subnet_id_2
  security_group_id = module.networking.aws_security_group_id
}