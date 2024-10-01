variable "aws_region" {
  type        = string
}

variable "state_file" {
  type        = string
}

variable "environment" {
  type        = string
}

variable "docker_image_url" {
  type        = string
}

variable "app_name" {
  type        = string
}

variable "app_port" {
  type        = string
}

variable "qty_replica" {
  type        = number
}

variable "ddl_auto" {
  type        = string
}

variable "show_sql" {
  type        = string
}