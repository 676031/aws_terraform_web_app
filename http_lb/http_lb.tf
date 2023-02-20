resource "aws_alb" "alb" {
  name            = "terraform-alb"
  internal        = false
  security_groups = [var.security_group_id]
  subnets         = [var.subnet_id_1,var.subnet_id_2]
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_target_group.arn
    type             = "forward"
  }
}

resource "aws_alb_target_group" "alb_target_group" {
  name     = "terraform-alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.aws_vpc_id

  health_check {
    path                = "/"
    interval            = 30
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_alb_target_group_attachment" "web1" {
  target_group_arn = aws_alb_target_group.alb_target_group.arn
  target_id        = var.web1_id
  port             = 80
}

resource "aws_alb_target_group_attachment" "web2" {
  target_group_arn = aws_alb_target_group.alb_target_group.arn
  target_id        = var.web2_id
  port             = 80
}
