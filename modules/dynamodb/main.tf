resource "aws_dynamodb_table" "users" {
  name         = "${var.project_prefix}-${var.aws_region}-${var.environment}-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"

  attribute {
    name = "userId"
    type = "S"
  }

  # ✅ Enable DynamoDB stream
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"  # Options: KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES

  tags = {
    Name        = "${var.project_prefix}-${var.aws_region}-${var.environment}-table"
    Environment = var.environment
  }
}
