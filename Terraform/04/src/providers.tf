terraform {
  required_version = "~>1.16.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.72"
    }
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.245"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2"
    }
  }

  backend "s3" {
    
    shared_credentials_files = ["~/.aws/credentials"]
    profile                  = "default"

    bucket  = "ijin82-storage-1gb" # FIO-netology-tfstate
    key     = "terraform.tfstate"
    encrypt = false
    region  = "ru-central1"

    # НОВОЕ: Встроенный механизм блокировок (Terraform >= 1.6)
    # Не требует отдельной базы данных (DynamoDB/YDB)!
    use_lockfile = true

    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
  }
}

provider "yandex" {
  token     = var.token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.default_zone
}

## Задание 6*
provider "aws" {
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}