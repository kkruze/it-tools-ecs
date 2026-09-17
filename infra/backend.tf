terraform {
  backend "s3" {
    bucket       = "kruze-it-tools-ecs-tfstate"
    key          = "it-tools-ecs/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}
