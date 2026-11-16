## Важно! Нужно настроить зеркало!

```bash
ijin@alt 🛠️ git:terraform-05 ~/Work/net-devops1/Terraform/04/src
$ cat ~/.terraformrc 
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```
