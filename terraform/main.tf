provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "apollorion-us-east-1-tfstates"
    key    = "i-dont-need-more-domains.tfstate"
    region = "us-east-1"
  }
}

locals {
  tld           = terraform.workspace == "production" ? "i-dont-need-more-domains.io" : "stage.i-dont-need-more-domains.io"
  acm_cert      = terraform.workspace == "production" ? "arn:aws:acm:us-east-1:874575230586:certificate/52276146-910e-4e5c-947c-3c02a36b5444" : "arn:aws:acm:us-east-1:874575230586:certificate/e414cda4-1c68-4c6c-8f10-06ab396e8546"
  images        = fileset("../idnmd/src/memes/", "*")
  website_files = tolist(fileset("../idnmd/build/", "**"))

  acm_aliases = [for i in local.images : "${lower(split(".", i)[0])}.${local.tld}"]
}
