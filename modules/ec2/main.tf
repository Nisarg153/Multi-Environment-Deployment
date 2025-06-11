resource "aws_security_group" "alb_sg" {
  name        = "${var.project_prefix}-${var.environment}-alb-sg"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_prefix}-${var.environment}-alb-sg"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_prefix}-${var.environment}-ec2-sg"
  description = "Allow traffic from ALB only"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_prefix}-${var.environment}-ec2-sg"
  }
}

resource "aws_launch_template" "app_lt" {
  name_prefix   = "${var.project_prefix}-${var.environment}-lt"
  image_id      = var.ami_id
  instance_type = var.instance_type
  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  user_data = base64encode(file("${path.module}/scripts/web-userdata.sh"))

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_prefix}-${var.environment}-instance"
    }
  }
}

resource "aws_lb" "app_alb" {
  name               = "${var.project_prefix}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.alb_sg.id]

  tags = {
    Name = "${var.project_prefix}-${var.environment}-alb"
  }
}

resource "aws_lb_target_group" "app_tg" {
  name     = "${var.project_prefix}-${var.environment}-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.project_prefix}-${var.environment}-tg"
  }
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 3000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "${var.project_prefix}-${var.environment}-asg"
  desired_capacity          = 2
  max_size                  = 2
  min_size                  = 1
  vpc_zone_identifier       = var.private_subnets
  target_group_arns         = [aws_lb_target_group.app_tg.arn]
  health_check_type         = "EC2"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project_prefix}-${var.environment}-instance"
    propagate_at_launch = true
  }
}
