resource "aws_s3_bucket" "tf_store" {
  bucket = "rs-school-store-1"

  tags = {
    Project = "Store"
  }
}
