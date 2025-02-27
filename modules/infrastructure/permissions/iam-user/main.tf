
resource "aws_iam_user" "this" {
  name          = var.name
  force_destroy = true
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}



module "credentials_general" {
  source = "../general"
  name   = var.name

  sfc_user_name               = aws_iam_user.this.name
  secure_api_token_secret_arn = var.ssm_secure_api_token_arn

  depends_on = [aws_iam_user.this]
}


module "credentials_cloud_connector" {
  count  = var.deploy_threat_detection ? 1 : 0
  source = "../cloud-connector"
  name   = var.name

  sfc_user_name                 = aws_iam_user.this.name
  cloudtrail_s3_bucket_arn      = var.cloudtrail_s3_bucket_arn
  cloudtrail_subscribed_sqs_arn = var.cloudtrail_subscribed_sqs_arn

  depends_on = [aws_iam_user.this]
}

module "credentials_cloud_scanning" {
  count  = var.deploy_image_scanning ? 1 : 0
  source = "../cloud-scanning"
  name   = var.name

  sfc_user_name                  = aws_iam_user.this.name
  scanning_codebuild_project_arn = var.scanning_codebuild_project_arn
  cloudtrail_subscribed_sqs_arn  = var.cloudtrail_subscribed_sqs_arn

  depends_on = [aws_iam_user.this]
}
