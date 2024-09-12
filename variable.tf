variable "vpc_cidir_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "project_name" {
  type    = string
  default = "eks"
}

variable "public_cidir_blocks" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "azs" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b"]
}

variable "private_cidir_blocks" {
  type    = list(string)
  default = ["10.0.3.0/24", "10.0.4.0/24"]

}