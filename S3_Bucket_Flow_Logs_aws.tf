# #Delete the items in the bucket before destorying
# resource "null_resource" "delete_bucket_objects" {
#   provisioner "local-exec" {
#     command = "aws s3 rm s3://${aws_s3_bucket.s3bucket.bucket} --recursive"
#   }

#   triggers = {
#     bucket_name = aws_s3_bucket.s3bucket.bucket
#   }
# }


resource "aws_s3_bucket" "s3bucket" {
  bucket = "us-east-2-${data.aws_caller_identity.current.account_id}"
  force_destroy = true

  //depends_on = [null_resource.delete_bucket_objects]
}

data "aws_caller_identity" "current" {}

resource "aws_flow_log" "flowlogs1" {
  vpc_id            = aws_vpc.vpc1.id
  log_destination   = aws_s3_bucket.s3bucket.arn
  log_destination_type = "s3"
  traffic_type      = "ALL"

  tags = {
    Name = "New-Flow-logs1"
  }
}

resource "aws_flow_log" "flowlogs2" {
  vpc_id            = aws_vpc.vpc2.id
  log_destination   = aws_s3_bucket.s3bucket.arn
  log_destination_type = "s3"
  traffic_type      = "ALL"

  tags = {
    Name = "New-Flow-logs2"
  }
}

