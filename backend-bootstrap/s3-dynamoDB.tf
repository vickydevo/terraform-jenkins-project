resource "aws_s3_bucket" "example" {
  bucket = "jenkins-state-demo-1234"
  region = "us-east-1"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}



# create dynamodb table for locking
resource "aws_dynamodb_table" "table_lock" {
  name         = "jenkins-state-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "DynamoDB Lock Table"
    Environment = "Dev"
  }
}