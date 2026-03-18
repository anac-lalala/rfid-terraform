variable "project_name" {
  description = "Nombre del proyecto."
  type        = string
}

variable "environment" {
  description = "Ambiente de despliegue."
  type        = string
}

variable "project_name" {
  description = "Nombre del proyecto."
  type        = string
}

variable "aws_region" {
  description = "Región AWS."
  type        = string
}

variable "availability_zones" {
  description = "Lista de AZs."
  type        = list(string)
}

variable "vpc_cidr" {
  description = "CIDR principal de la VPC."
  type        = string
}

variable "front_subnet_cidrs" {
  description = "CIDRs de subredes frontend."
  type        = list(string)
}

variable "back_subnet_cidrs" {
  description = "CIDRs de subredes backend."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDRs de subredes públicas."
  type        = list(string)
}

variable "db_subnet_cidrs" {
  description = "CIDRs de subredes de base de datos."
  type        = list(string)
}

variable "common_tags" {
  description = "Tags comunes."
  type        = map(string)
  default     = {}
}