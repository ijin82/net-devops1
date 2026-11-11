variable "env_name" {
  type        = string
  default     = "hello"
  description = "Environment name"
}

variable "params" {
  type    = list(object({
    zone = string
    cidr = list(string)
  }))
  default = [{
    zone = "ru-central1-a"
    cidr = ["10.0.1.0/24"]
  }]
  description = "List with zone ID (string slug) and cidr list(string) objects"
}


