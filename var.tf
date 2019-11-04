variable "cluster-name" {
  default = "terraform-eks-test"
  type    = string
}
variable "vpc_id" {
    default=" "
    type   = string
}
variable "subnet_id" {
    default=""
    type = string
}
vriable "worker-subnet" {
    default=""
    type= string
}
variable "owner"{
    default=""
    type= string
}