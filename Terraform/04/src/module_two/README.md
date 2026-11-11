# module_one 

Этот модуль создаёт сеть и подсеть в указанной зоне YC

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.16 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [yandex_vpc_network.network_one](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network) | resource |
| [yandex_vpc_subnet.subnetwork_one](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Environment name | `string` | `"hello"` | no |
| <a name="input_params"></a> [params](#input\_params) | List with zone ID (string slug) and cidr list(string) objects | <pre>list(object({<br/>    zone = string<br/>    cidr = list(string)<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cidr": [<br/>      "10.0.1.0/24"<br/>    ],<br/>    "zone": "ru-central1-a"<br/>  }<br/>]</pre> | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_network_id"></a> [network\_id](#output\_network\_id) | n/a |
| <a name="output_subnetwork_ids"></a> [subnetwork\_ids](#output\_subnetwork\_ids) | n/a |
<!-- END_TF_DOCS -->

