### S3 Bucket placed behind CloudFront
variable "bucket_name" {}
resource "aws_s3_bucket" "b" {
  bucket = var.bucket_name
  acl    = "public"

  #  versioning {
  #    enabled = true
  #  }

  tags = {
    Name = var.bucket_name
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "b" {
  bucket = "${aws_s3_bucket.b.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "b-restrict-access-to-users-or-roles",
      "Effect": "Allow",
      "Principal": [
        {
          "AWS": [
            "arn:aws:iam::##acount_id##:role/##role_name##",
            "arn:aws:iam::##acount_id##:user/##user_name##"
          ]
        }
      ],
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.b.id}/*"
    }
  ]
}
POLICY
}