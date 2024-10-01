variable "aws_region" {
  description = "AWS região"
  type = string
}

variable "state_file" {
  description = "S3 Bucket state file"
  type = string
}

variable "environment" {
  description = "Ambiente (dev ou prod)"
  type        = string
}

variable "image_version" {
  description = "Versão da imagem Docker"
  type        = string
}

variable "image_repo" {
  description = "Repositório da imagem Docker"
  type        = string
}

variable "app_name" {
  description = "Nome da aplicação"
  type        = string
}

variable "qty_replica" {
  description = "Quantidade de réplicas"
  type        = number
}