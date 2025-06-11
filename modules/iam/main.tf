# ---------------------------------------------------------------------------------------------------------------------
# IAM ROLE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "app-role" {
  name               = "${var.project_prefix}-${var.environment}-app-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2-assume-policy.json
}

resource "aws_iam_role_policy_attachment" "dynamodb_rw" {
  role       = aws_iam_role.app-role.name
  policy_arn = aws_iam_policy.dynamodb_rw_policy.arn
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.app-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "codedeploy" {
  role       = aws_iam_role.app-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforAWSCodeDeploy"
}

resource "aws_iam_role_policy_attachment" "s3_readonly" {
  role       = aws_iam_role.app-role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Trust policy allowing EC2 to assume the role
data "aws_iam_policy_document" "ec2-assume-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Custom DynamoDB read/write policy
resource "aws_iam_policy" "dynamodb_rw_policy" {
  name = "${var.project_prefix}-${var.environment}-dynamodb_rw_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["dynamodb:*"],
        Effect   = "Allow",
        Resource = ["*"]
        # Consider scoping to table ARN if known: e.g. "arn:aws:dynamodb:region:account-id:table/your-table-name"
      }
    ]
  })
}
