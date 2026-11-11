variable "env_name" {
  type        = string
  default     = "hello"
  description = "Environment name"
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
  description = "zone ID (string slug)"
}

variable "cidr" {
  type    = list(string)
  default = ["10.0.1.0/24"]
  description = "cidr"
}

