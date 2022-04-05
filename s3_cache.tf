#############################################################
# S3 Buckets
#############################################################

module "s3_cache_bucket" {
  enabled = var.enable_s3_cache

  source  = "cloudposse/s3-bucket/aws"
  version = "0.49.0"

  context    = module.default_label.context
  attributes = compact(concat(var.attributes, ["cache"]))

  user_enabled       = false
  versioning_enabled = false
  force_destroy      = true

  lifecycle_rules    = var.lifecycle_rules
}

#############################################################
# S3 Bucket public access
#############################################################

resource "aws_s3_bucket_public_access_block" "cache" {
  count = var.enable_s3_cache ? 1 : 0

  depends_on = [module.s3_cache_bucket]

  bucket = module.s3_cache_bucket.bucket_id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
