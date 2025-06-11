output "app-role"{
    description = "The IAM role for the application"
    value       = aws_iam_role.app-role.name
}

output "dynamodb_rw_policy" {
    description = "The IAM policy for DynamoDB read/write access"
    value       = aws_iam_policy.dynamodb_rw_policy.arn
}

output "ec2_assume_policy" {
    description = "The assume role policy document for EC2"
    value       = data.aws_iam_policy_document.ec2-assume-policy.json
  
}