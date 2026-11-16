variable "my_ip" {
  type        = string
  description="ip-адрес"
  default     = "192.168.0.1"

  validation {
    # https://developer.hashicorp.com/terraform/language/functions/can
    # выполняет выражение и возвращает bool

    # https://developer.hashicorp.com/terraform/language/functions/cidrhost
    
    condition     = can(cidrhost("${var.my_ip}/32", 0))
    error_message = "Bad IP address."

    # https://developer.hashicorp.com/terraform/language/functions/regex
    # не понимает числа, то есть можно маскировать строку чтобы были числа, 
    # например [0-9]{1,3} (от 1 до 3х цифр, таких сделать 4 блока через
    # экранированные точки) но число 0-255 он не может отличить от 999 например,
    # то есть лучше пользоваться cidrhost 
  }
}