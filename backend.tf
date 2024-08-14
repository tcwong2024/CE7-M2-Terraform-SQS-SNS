#################################################################################
# Terraform backend - store the tf state
#################################################################################

terraform {
  backend "s3" {
    bucket = "sctp-ce7-tfstate"
    key    = "terraform-ex-ec2-sns-wtc.tfstate"
    region = "us-east-1"

  }
}
