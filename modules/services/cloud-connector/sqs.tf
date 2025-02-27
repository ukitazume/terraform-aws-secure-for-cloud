module "cloud_connector_sqs" {
  source        = "../../infrastructure/sqs-sns-subscription"
  name          = "${var.name}-cloud_connector"
  sns_topic_arn = var.sns_topic_arn
  tags          = var.tags
}
