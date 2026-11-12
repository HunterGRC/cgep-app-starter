terraform {
  backend "s3" {
    bucket = "acme-health-intake-evidence-6b08c38c"
    key    = "tfstate/terraform.tfstate"
    region = "us-east-1"
  }
}
