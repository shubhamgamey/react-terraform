locals {
  mime_types = jsondecode(file("${path.module}/mime.json"))
}
resource "aws_s3_object" "website-public" {
   for_each = fileset("../dist", "**/*.*")
   bucket = aws_s3_bucket.react-tf-bucket.id
   key = each.key
   source = "../dist/${each.value}"
   etag = filemd5("../dist/${each.value}")
   content_type = lookup(local.mime_types, regex("\\.[^.]+$", each.value), null)
}