variable "project_name" {
    default = "expense"
   
}

variable "environment" {
   default = "dev"
    
}

variable "common_tags" {
    default = {
        Project = "expense"
        Environment = "dev"
        Terraform = "true"
        Component = "backend"
    }

}
variable "vpn_tags" {
    default = {}
   
}