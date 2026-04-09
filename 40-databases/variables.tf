variable "project" {
  type = string
  default = "roboshop"
}

variable "environment" {
  type = string
  default = "dev"
}

variable "zone_id" {
  default = "Z03584735O3LYRT2Q9HU"
  
}

variable "zone_name" {
  default = "manchem.site"
}

variable "DB_Components" {
  type = list(string)
  default = ["mongodb", "mysql", "redis", "rabbitmq"]
}