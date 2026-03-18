output "vpc_id" {
  description = "ID de la VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs de las subredes públicas"
  value       = aws_subnet.public[*].id
}

output "front_subnet_ids" {
  description = "IDs de las subredes frontend"
  value       = aws_subnet.front[*].id
}

output "back_subnet_ids" {
  description = "IDs de las subredes backend"
  value       = aws_subnet.back[*].id
}

output "db_subnet_ids" {
  description = "IDs de las subredes DB"
  value       = aws_subnet.db[*].id
}

output "db_subnet_group_name" {
  description = "Nombre del DB subnet group"
  value       = aws_db_subnet_group.main.name
}