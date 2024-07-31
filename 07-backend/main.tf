module "backend" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.vpn_sg_id.value]
  #convert stringList to list and get first element
  subnet_id              = local.private_subnet_id_final
  ami = data.aws_ami.ami_info.id
  tags = merge (var.common_tags,  
  {
    Name = "${var.project_name}-${var.environment}-${var.common_tags.Component}"
  }
  )
}

resource "null_resource" "cluster" {
    triggers = {
      instance_id = module.backend.id #this will be triggered everytime instanvce is created
    }

    connection {
        type  = "ssh"
        user  = "ec2-user"
        password = "DevOps321"
        host = module.backend.private_ip

    }
    provisioner "remote-exec" {
        inline = [
            
            "sudo dnf install nginx -y",
            "sudo systemctl start nginx"
        ]

    }
}