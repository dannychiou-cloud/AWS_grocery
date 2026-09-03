resource "aws_s3_bucket" "avatars" {
  bucket = "grocerymate-avatars-danny-2026"

  tags = {
    Name        = "terraform-grocerymate-avatars"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "avatars" {
  bucket = aws_s3_bucket.avatars.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "avatars" {
  bucket = aws_s3_bucket.avatars.id

  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_iam_role" "ec2_s3_role" {
  name = "terraform-grocerymate-ec2-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "terraform-grocerymate-ec2-s3-role"
  }
}

resource "aws_iam_role_policy" "ec2_s3_policy" {
  name = "terraform-grocerymate-s3-policy"
  role = aws_iam_role.ec2_s3_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]

        Resource = "${aws_s3_bucket.avatars.arn}/*"
      },
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = aws_s3_bucket.avatars.arn
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = "terraform-grocerymate-ec2-s3-profile"
  role = aws_iam_role.ec2_s3_role.name
}