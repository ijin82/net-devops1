# Домашнее задание к занятию 5. «Практическое применение Docker»

## Задача 0

- Убедитесь что у вас НЕ(!) установлен docker-compose, для этого получите следующую ошибку от команды docker-compose --version  

  Ок, все в порядке, docker-compose в системе давно нет.  

  ```bash
  ijin@tatuin 🛠️  git:main ~/Work/net-devops1-docker2
  $ docker compose version
  Docker Compose version 5.0.2
  ```

- Убедитесь что у вас УСТАНОВЛЕН docker compose(без тире) версии не менее v2.24.X, для это выполните команду docker compose version  

  Да, все ок.

## Задача 1

- Сделайте в своем GitHub пространстве fork репозитория.  
  
  Есть форк, [https://github.com/ijin82/shvirtd-example-python](https://github.com/ijin82/shvirtd-example-python)

- Создайте файл `Dockerfile.python` на основе существующего `Dockerfile`:
  - Используйте базовый образ python:3.12-slim
  - Обязательно используйте конструкцию COPY . . в Dockerfile
  - Создайте .dockerignore файл для исключения ненужных файлов
  - Используйте CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"] для запуска
  - Протестируйте корректность сборки 2.1 Используйте multistage сборку вместо single stage.
- (Необязательная часть, *) Изучите инструкцию в проекте и запустите web-приложение без использования docker, с помощью venv. (Mysql БД можно запустить в docker run).
- (Необязательная часть, *) Изучите код приложения и добавьте управление названием таблицы через ENV переменную.

> 💡
> ВНИМАНИЕ!  
> !!! В процессе последующего выполнения ДЗ НЕ изменяйте содержимое файлов в fork-репозитории! Ваша задача ДОБАВИТЬ 5 файлов: Dockerfile.python, compose.yaml, .gitignore, .dockerignore,bash-скрипт. Если вам понадобилось внести иные изменения в проект - вы что-то делаете неверно!

  Хорошо, понятно.

## Задача 2 (*)

  1. Создайте в yandex cloud container registry с именем "test" с помощью "yc tool" . [Инструкция](https://cloud.yandex.ru/ru/docs/container-registry/quickstart/?from=int-console-help)
  1. Настройте аутентификацию вашего локального docker в yandex container registry.
  1. Соберите и залейте в него образ с python приложением из задания №1.
  1. Просканируйте образ на уязвимости.
  1. В качестве ответа приложите отчет сканирования.