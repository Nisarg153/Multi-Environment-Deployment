output "dynamodb_stream_arn" {
  value = aws_dynamodb_table.users.stream_arn
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.users.name
}