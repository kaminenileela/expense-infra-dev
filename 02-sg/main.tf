module "sg_db" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/kaminenileela/terraform-aws-securitygroup.git"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    project_name = var.project_name
    environment = var.environment
    sg_description = "database security group"
    sg_name = "db"
    common_tags = var.common_tags

}

module "sg_backend" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/kaminenileela/terraform-aws-securitygroup.git"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    project_name = var.project_name
    environment = var.environment
    sg_description = "backend security group"
    sg_name = "backend"
    common_tags = var.common_tags

}

module "sg_frontend" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/kaminenileela/terraform-aws-securitygroup.git"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    project_name = var.project_name
    environment = var.environment
    sg_description = "frontend security group"
    sg_name = "frontend"
    common_tags = var.common_tags

}

module "sg_bastion" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/kaminenileela/terraform-aws-securitygroup.git"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    project_name = var.project_name
    environment = var.environment
    sg_description = "security group for bastion instances"
    sg_name = "bastion"
    common_tags = var.common_tags

}

module "app_alb" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/kaminenileela/terraform-aws-securitygroup.git"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for APP ALB Instances"
    sg_name = "app_alb"
    common_tags = var.common_tags
}

module "web_alb" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/kaminenileela/terraform-aws-securitygroup.git"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for Web ALB Instances"
    sg_name = "web_alb"
    common_tags = var.common_tags
}



module "vpn" {
    #source = "../../terraform-aws-securitygroup"
    source = "git::https://github.com/kaminenileela/terraform-aws-securitygroup.git"
    vpc_id = data.aws_ssm_parameter.vpc_id.value
    project_name = var.project_name
    environment = var.environment
    sg_description = "SG for VPN Instances"
    sg_name = "vpn"
    common_tags = var.common_tags
    ingress_rules = var.vpn_sg_rules
        
}

#DB is accepting connections from backend
resource "aws_security_group_rule" "db_backend" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.sg_backend.sg_id  #source is where you are getting traffic from
  security_group_id = module.sg_db.sg_id
}

resource "aws_security_group_rule" "db_bastion" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.sg_bastion.sg_id  #source is where you are getting traffic from
  security_group_id = module.sg_db.sg_id
}

resource "aws_security_group_rule" "db_vpn" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  #source is where you are getting traffic from
  security_group_id = module.sg_db.sg_id
}


resource "aws_security_group_rule" "backend_app_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.app_alb.sg_id  #source is where you are getting traffic from
  security_group_id = module.sg_backend.sg_id
}

resource "aws_security_group_rule" "backend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.sg_bastion.sg_id  #source is where you are getting traffic from
  security_group_id = module.sg_backend.sg_id
}

resource "aws_security_group_rule" "backend_vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  #source is where you are getting traffic from
  security_group_id = module.sg_backend.sg_id
}

resource "aws_security_group_rule" "backend_vpn_http" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id  #source is where you are getting traffic from
  security_group_id = module.sg_backend.sg_id
}

# resource "aws_security_group_rule" "frontend_public" {
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
#   security_group_id = module.sg_frontend.sg_id
# }

resource "aws_security_group_rule" "frontend_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.sg_bastion.sg_id  #source is where you are getting traffic from
  security_group_id = module.sg_frontend.sg_id
}

resource "aws_security_group_rule" "bastion_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.sg_bastion.sg_id
}


resource "aws_security_group_rule" "app_alb_vpn" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.vpn.sg_id
  security_group_id = module.app_alb.sg_id
}

resource "aws_security_group_rule" "app_alb_frontend" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.sg_frontend.sg_id
  security_group_id = module.app_alb.sg_id
}

resource "aws_security_group_rule" "web_alb_public" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web_alb.sg_id
}

resource "aws_security_group_rule" "web_alb_public_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.web_alb.sg_id
}

resource "aws_security_group_rule" "frontend_web_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.web_alb.sg_id 
  security_group_id = module.sg_frontend.sg_id
}

# resource "aws_security_group_rule" "frontend_vpn" {
#   type              = "ingress"
#   from_port         = 22
#   to_port           = 22
#   protocol          = "tcp"
#   source_security_group_id = module.vpn.sg_id # source is where you are getting traffic from
#   security_group_id = module.frontend.sg_id
# }

resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.sg_frontend.sg_id
}