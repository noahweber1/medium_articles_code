resource "aws_sagemaker_notebook_instance" "basic" {
  name                  = "FraudDetectionNotebookInstance"
  role_arn              = aws_iam_role.sm_notebook_instance_role.arn
  instance_type         = "ml.t2.medium"
  lifecycle_config_name = aws_sagemaker_notebook_instance_lifecycle_configuration.basic_lifecycle.name

  tags = {
    Group     = var.default_resource_group
    CreatedBy = var.default_created_by
  }

  depends_on = [aws_s3_bucket_object.s3_fraud_detection_notebook ]
}

data "template_file" "instance_init" {
  template = file("${path.module}/template/sagemaker_instance_init.sh")

  vars = {
    s3_bucket_name_1     = aws_s3_bucket.s3_bucket_1.id
    aws_region           = var.aws_region
    function_bucket_name = var.function_bucket_name
    function_version     = var.function_version
  }
}

resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "basic_lifecycle" {
  name     = "BasicNotebookInstanceLifecycleConfig"
  on_start = base64encode(data.template_file.instance_init.rendered)

  depends_on = [aws_s3_bucket.s3_bucket_1]
}
