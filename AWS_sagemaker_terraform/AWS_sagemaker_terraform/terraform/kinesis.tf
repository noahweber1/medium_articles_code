resource "aws_kinesis_firehose_delivery_stream" "fraud_detection_firehose_stream" {
  name        = "fraud-detection-firehose-stream"
  destination = "s3"

  s3_configuration {
    bucket_arn         = aws_s3_bucket.s3_bucket_2.arn
    prefix             = var.kinesis_firehose_prefix
    buffer_interval    = 60
    buffer_size        = 100
    compression_format = "GZIP"
    role_arn           = aws_iam_role.fraud_detection_firehose_role.arn
  }

  tags = {
    Group     = var.default_resource_group
    CreatedBy = var.default_created_by
  }
}
