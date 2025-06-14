resource "aws_s3_bucket" "tf_state" {
  bucket              = "rs-school-terraform-state-1"
  object_lock_enabled = "true"

  tags = {
    Project = "terraform-bootstrap"
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "rs-school-terraform-locks-1"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}
