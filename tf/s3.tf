resource "aws_s3_bucket" "react-tf-bucket" {
  bucket = "react-tf-bucket"
  tags = {
    Name = "react-tf-bucket"
    Environment = "Dev"
   }
}

data "aws_iam_policy_document" "cf_s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.react-tf-bucket.arn}/*"]
principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}
resource "aws_s3_bucket_policy" "react-tf-bucket_policy" {
  bucket = aws_s3_bucket.react-tf-bucket.id
  policy = data.aws_iam_policy_document.cf_s3_policy.json
}
resource "aws_s3_bucket_public_access_block" "react-tf-bucket_acl" {
  bucket = aws_s3_bucket.react-tf-bucket.id
  block_public_acls       = true
  block_public_policy     = true
}