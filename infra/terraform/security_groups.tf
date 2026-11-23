# --- Load balancer: HTTPS only from the internet -------------------------------------
resource "aws_security_group" "alb" {
  name        = "${var.project}-alb"
  description = "Public entry point, HTTPS only"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTPS (frontend) from the internet"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "alb_ws" {
  security_group_id = aws_security_group.alb.id
  description       = "Secure WebSocket (ws-gateway) from the internet"
  ip_protocol       = "tcp"
  from_port         = 4000
  to_port           = 4000
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "alb_to_frontend" {
  security_group_id            = aws_security_group.alb.id
  description                  = "To the frontend on the application host"
  ip_protocol                  = "tcp"
  from_port                    = 3000
  to_port                      = 3000
  referenced_security_group_id = aws_security_group.app.id
}

resource "aws_vpc_security_group_egress_rule" "alb_to_ws" {
  security_group_id            = aws_security_group.alb.id
  description                  = "To the ws-gateway on the application host"
  ip_protocol                  = "tcp"
  from_port                    = 4000
  to_port                      = 4000
  referenced_security_group_id = aws_security_group.app.id
}

# --- Application host: only the load balancer can reach it ---------------------------
resource "aws_security_group" "app" {
  name        = "${var.project}-app"
  description = "Application host, reachable only from the load balancer"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "app_from_alb_frontend" {
  security_group_id            = aws_security_group.app.id
  description                  = "Frontend from the load balancer"
  ip_protocol                  = "tcp"
  from_port                    = 3000
  to_port                      = 3000
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_ingress_rule" "app_from_alb_ws" {
  security_group_id            = aws_security_group.app.id
  description                  = "ws-gateway from the load balancer"
  ip_protocol                  = "tcp"
  from_port                    = 4000
  to_port                      = 4000
  referenced_security_group_id = aws_security_group.alb.id
}

# E-03: HTTPS out to registries and APIs whose addresses cannot be listed (see infra/EXCEPTIONS.md).
#trivy:ignore:AVD-AWS-0104
resource "aws_vpc_security_group_egress_rule" "app_https_out" {
  security_group_id = aws_security_group.app.id
  description       = "HTTPS out (image registry, LLM providers, AWS APIs)"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "app_to_db" {
  security_group_id            = aws_security_group.app.id
  description                  = "MySQL to the database"
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
  referenced_security_group_id = aws_security_group.db.id
}

# --- Database: only the application host can reach it --------------------------------
resource "aws_security_group" "db" {
  name        = "${var.project}-db"
  description = "MySQL, reachable only from the application host"
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  security_group_id            = aws_security_group.db.id
  description                  = "MySQL from the application host"
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
  referenced_security_group_id = aws_security_group.app.id
}

resource "aws_security_group" "test_open" {
  name        = "test-open"
  description = "TEST ONLY: everything open"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TEST ONLY: all ports from the internet"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
