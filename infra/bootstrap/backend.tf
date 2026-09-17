terraform {
  backend "s3" {
    bucket       = "kruze-it-tools-ecs-tfstate"
    key          = "bootstrap/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
