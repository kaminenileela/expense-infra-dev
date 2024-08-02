variable "common_tags" {
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = "true"
        Component = "backend"
    }

}

variable "project_name" {
    default = "expense"
   
}

variable "environment" {
   default = "dev"
    
}

variable "zone_name" {
  default = "learningdevopsaws.online"
}

variable "zone_id" {
  default = "Z050427234MTZELQ6G26Y"
}

