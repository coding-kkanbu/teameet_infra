output "public_ip" {
  value = aws_instance.single_instance.public_ip
}

output "redis_security_group_id" {
  value = aws_security_group.ingress_redis.id
}

output "postgres_security_group_id" {
  value = aws_security_group.ingress_postgres.id
}