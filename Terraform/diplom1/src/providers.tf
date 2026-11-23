
# cat ~/.aws/config 
# [default]
# region=ru-central1

# cat ~/.aws/credentials 
# [default]
# aws_access_key_id = YCAJEK...
# aws_secret_access_key = YCMBzZ3...


# For terraform >=1.6.0
# Новый подход: использование встроенных блокировок через use_lockfile
terraform {
  required_version = "~>1.16.0"

  backend "s3" {
    
    shared_credentials_files = ["~/.aws/credentials"]
    profile                  = "default"
    region                   = "ru-central1"

    # state storage name & key
    bucket  = "ijin82-storage-1gb"
    key     = "wm/terraform.tfstate"
    encrypt = false

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

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.158.0"
    }
  }
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = file("~/.authorized_key.json")
  zone                     = var.default_zone
}

