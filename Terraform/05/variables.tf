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

variable "my_ips" {
  type        = list(string)
  description = "список ip-адресов"

  # good
  # default     = ["192.168.0.1", "1.1.1.1", "127.0.0.1"]
  # bad
   default     = ["192.168.0.1", "1.1.1.1", "127.0.0.1"]

  # https://developer.hashicorp.com/terraform/language/functions/alltrue
  # то же самое что can только для листа, alltrue(list)
  validation {
    condition     = alltrue([for ip in var.my_ips : can(cidrhost("${ip}/32", 0))])
    error_message = "Bad IP address."
  }
}

# Задание 5*

# нижний регистр
variable "my_low_case_str" {
    description="String with only low case letters"

    type = string

    # ok
    default = "1233qwe457y3"

    # bad1
    #default = "12334A57y3"

    # bad2
    #default = "0Qe1233457y3"

    validation {
        error_message = "Only low case allowed"
        # регулярка обычная, простая
        # говорим что от начала до конца строки не должно быть символов A-Z
        # если буквально - ждем там любые символы вообще кроме букв в верхнем регистре,
        # по идее надо описать комплект разрешенных символов примерно так [a-z0-9_-]
        # но такой задачи не стоит
        condition     = can(regex("^[^A-Z]+$", var.my_low_case_str))
    }
}

# Часть про горца

variable "in_the_end_there_can_be_only_one" {
    description="Who is better Connor or Duncan?"

    type = object({
        Dunkan = optional(bool)
        Connor = optional(bool)
    })

    default = {
        # ok
        Dunkan = false
        Connor = true

        # bad1
        #Dunkan = true
        #Connor = true

        # bad2
        #Dunkan = false
        #Connor = false
    }

    validation {
        error_message = "There can be only one MacLeod"
        # Прибиваем гвоздями возможные варианты, красивее через сумму тех элементов что true но я до этого не додумался
        condition = (var.in_the_end_there_can_be_only_one.Dunkan && !var.in_the_end_there_can_be_only_one.Connor) || (var.in_the_end_there_can_be_only_one.Connor && !var.in_the_end_there_can_be_only_one.Dunkan)
    }
}