# Домашнее задание к занятию 2. «Применение принципов IaaC в работе с виртуальными машинами»

## Задача 1

1. VirtualBox установился, все ок
   Скриншот 05-virt-02-iaac/Screenshots/Virtualbox 2026-09-21 11-36-57.png
2. С Vagrant как обычно не всё хорошо

   ```bash
    ijin@tatuin 🏠 ~
    $ which vagrant
    /home/ijin/.local/bin/vagrant
    ijin@tatuin 🏠 ~
    $ vagrant
    bash: symbol lookup error: /tmp/.private/ijin/.mount_vagranmICACj/usr/lib/libreadline.so.8: undefined symbol: UP
   ```

   Настройка через репы вагранта в альте это больно, поэтому и использовался appImage.  
   Сам бы я не разобрался в чем дело, все библиотеки readline в системе есть, дело именно в appImage.  
   ИИшка подсказала рабочее решение (не дословно, но примерно такое)

   ```bash
   ijin@tatuin 🏠 ~
   $ lsb_release -a
   LSB Version:    n/a
   Distributor ID: ALT
   Description:    ALT Workstation 11.2 (Prometheus)
   Release:        11.2
   Codename:       Prometheus

   # 1. Переходим в каталог с vagrant и распаковываем его
   cd ~/.local/bin
   ./vagrant --appimage-extract

   # 2. Переносим распакованное приложение в постоянное место
   mkdir -p ~/.local/share
   rm -rf ~/.local/share/vagrant
   mv squashfs-root ~/.local/share/vagrant

   # 3. Удаляем конфликтующую библиотеку libreadline из бандла
   rm -f ~/.local/share/vagrant/usr/lib/libreadline*

   # 4. Сохраняем исходный файл и делаем симлинк на рабочий скрипт
   mv ~/.local/bin/vagrant ~/.local/bin/vagrant.appimage
   ln -s ~/.local/share/vagrant/AppRun ~/.local/bin/vagrant
   ```

   После чего vagrant завелся условно.

   ```bash
   ijin@tatuin 🏠 ~
   $ vagrant --version
   Vagrant 2.4.9
   ```

3. Packer

   ```bash
   ijin@tatuin 🏠 ~
   $ which packer
   /home/ijin/.local/bin/packer
   ijin@tatuin 🏠 ~
   $ packer --version
   Packer v1.11.2

   ijin@tatuin ~/Work/net-devops1/05-virt-02-iaac/src
   $ packer init ./config.pkr.hcl
   Installed plugin github.com/hashicorp/yandex v1.1.3 in "/home/ijin/.config/packer/plugins/github.com/hashicorp/yandex/packer-plugin-yandex_v1.1.3_x5.0_linux_amd64"
   ```

   Информация о каталоге в YC
   Скриншот 05-virt-02-iaac/Screenshots/YC Catalog info 2026-09-21 12-48-20.png

4. уandex cloud cli

   ```bash
   ijin@tatuin 🏠 ~
   $ which yc
   /home/ijin/.local/bin/yc
   ijin@tatuin 🏠 ~
   $ yc --version
   Yandex Cloud CLI 1.36.0 linux/amd64
   ijin@tatuin 🏠 ~
   $ yc init
   Welcome! This command will take you through the configuration process.
   
   You are going to be authenticated in Yandex Cloud.
   After your successful authentication, you will be redirected to cloud console.
   
   Press 'enter' to continue...
   You have one cloud available: 'src-user-cloud-captain-buran' (id = b1gv6aetkp611h2im18u). It is going to be used by default.
   Please choose folder to use:
    [1] default (id = b1gl6j5lv636j3ekvebc)
    [2] Create a new folder
   Please enter your numeric choice: 1
   Your current folder has been set to 'default' (id = b1gl6j5lv636j3ekvebc).
   Do you want to configure a default Compute zone? [Y/n] 
   Which zone do you want to use as a profile default?
    [1] ru-central1-a
    [2] ru-central1-b
    [3] ru-central1-d
    [4] ru-central1-e
    [5] ru-central1-k
    [6] Don't set default zone
   Please enter your numeric choice: 1
   Your profile default Compute zone has been set to 'ru-central1-a'.
   ```

   Получение IAM
   https://yandex.cloud/ru/docs/iam/operations/iam-token/create

   ```bash
   ijin@tatuin ~/Work/net-devops1/05-virt-02-iaac/src
   $ yc iam create-token
   t1.9euelZqPi52Vk5TGmZ6Ox5jNmorJm-3r
   ```

## Задача 2

1. SSH ключ есть
2. Докер есть

   ```bash
   jin@tatuin ~/.local/bin
   $ docker version && docker compose version
   Client:
    Version:           29.2.1
    API version:       1.53
    Go version:        go1.25.7 X:nodwarf5
    Git commit:        a5c7197
    Built:             Tue Feb  3 11:52:43 2026
    OS/Arch:           linux/amd64
    Context:           default
   
   Server:
    Engine:
     Version:          29.2.1
     API version:      1.53 (minimum version 1.44)
     Go version:       go1.25.7 X:nodwarf5
     Git commit:       6bc6209
     Built:            Tue Feb  3 10:33:46 2026
     OS/Arch:          linux/amd64
     Experimental:     false
    containerd:
     Version:          v2.2.1
     GitCommit:        dea7da5
    docker-runc:
     Version:          1.4.0
     GitCommit:        8bd78a9
    tini:
     Version:          0.19.0
     GitCommit:        
   Docker Compose version 5.0.2
   ```

## Задача 3

1. Отредактируйте файл    [mydebian.json.pkr.hcl](https://github.com/netology-code/virtd-homeworks/blob/shvirtd-1/05-virt-02-iaac/src/mydebian.json.pkr.hcl)  или [mydebian.jsonl](https://github.com/netology-code/virtd-homeworks/blob/shvirtd-1/05-virt-02-iaac/src/mydebian.json) в директории src (packer умеет и в json, и в hcl форматы):
   - добавьте в скрипт установку docker. Возьмите скрипт установки для debian из  [документации](https://docs.docker.com/engine/install/debian/)  к docker, 
   - дополнительно установите в данном образе htop и tmux.(не забудьте про ключ автоматического подтверждения установки для apt)

   **Создал образ через packer**

   ```text
   Packer — это инструмент с открытым исходным кодом от компании HashiCorp. Его главная задача — автоматизировать создание идентичных машинных образов (например, виртуальных машин или контейнерных образов) для разных платформ из единого исходного шаблона. Проще говоря: с его помощью можно один раз описать, как должен выглядеть «золотой» образ (настроенная ОС плюс нужное ПО), а Packer сам запустит сборку на нужной платформе.
   ```

   **Консоль**

   ```bash
   ijin@tatuin ~/Work/net-devops1/05-virt-02-iaac/src
   $ packer build mydebian.json
   yandex: output will be in this color.
   
   ==> yandex: Creating temporary RSA SSH key for instance...
   ==> yandex: Using as source image: fd83jvp8d1v2j0hnvvlo (name: "debian-11-v20260914", family: "debian-11")
   ==> yandex: Use provided subnet id e9bucnd2o6qtgltlsjhv
   ==> yandex: Creating disk...
   ==> yandex: Creating instance...
   ==> yandex: Waiting for instance with id fhmfbrupthmgq3s7htpn to become active...
       yandex: Detected instance IP: 89.169.158.161
   ==> yandex: Using SSH communicator to connect: 89.169.158.161
   ==> yandex: Waiting for SSH to become available...
   ==> yandex: Connected to SSH!
   ==> yandex: Provisioning with shell script: /tmp/.private/ijin/packer-shell1910472496
       yandex: hello from packer
   ==> yandex: Stopping instance...
   ==> yandex: Deleting instance...
       yandex: Instance has been deleted!
   ==> yandex: Creating image: debian-11-docker
   ==> yandex: Waiting for image to complete...
   ==> yandex: Success image create...
   ==> yandex: Destroying boot disk...
       yandex: Disk has been deleted!
   Build 'yandex' finished after 1 minute 56 seconds.
   
   ==> Wait completed after 1 minute 56 seconds
   
   ==> Builds finished. The artifacts of successful builds are:
   --> yandex: A disk image was created: debian-11-docker (id: fd8egp5c25mj4b6qh7og) with family name debian-web-server
   ```

2. Найдите свой образ в web консоли yandex_cloud

   Нашел  
   Скриншот 05-virt-02-iaac/Screenshots/Debian image in YC 2026-09-21 15-03-20.png

3. Необязательное задание(*): найдите в документации yandex cloud как найти свой образ с помощью утилиты командной строки "yc cli".

   Разобрался, вот так:  
   Folder ID взят из веб-консоли YC  
   Скриншот: 05-virt-02-iaac/Screenshots/Folder ID For YC images 2026-09-21 15-09-32.png  

   ```bash
   ijin@tatuin ~/Work/net-devops1/05-virt-02-iaac/src
   $ yc compute image list  --folder-id b1gl6j5lv636j3ekvebc
   +----------------------+------------------+-------------------+----------------------+--------+
   |          ID          |       NAME       |      FAMILY       |     PRODUCT IDS      | STATUS |
   +----------------------+------------------+-------------------+----------------------+--------+
   | fd8gmnn38adduf1q40nc | debian-11-docker | debian-web-server | f2ebt3ehgu5haoffm3m7 | READY  |
   +----------------------+------------------+-------------------+----------------------+--------+

   # Или без (!!) ключа (дефолтный folder ID)
   ijin@tatuin ~/Work/net-devops1/05-virt-02-iaac/src
   $ yc compute image list
   +----------------------+------------------+-------------------+----------------------+--------+
   |          ID          |       NAME       |      FAMILY       |     PRODUCT IDS      | STATUS |
   +----------------------+------------------+-------------------+----------------------+--------+
   | fd8gmnn38adduf1q40nc | debian-11-docker | debian-web-server | f2ebt3ehgu5haoffm3m7 | READY  |
   +----------------------+------------------+-------------------+----------------------+--------+
   ```

4. Создайте новую ВМ (минимальные параметры) в облаке, используя данный образ.

   ```bash
   ijin@tatuin ~/Work/net-devops1/05-virt-02-iaac/src
   $ packer validate mydebian.json
   The configuration is valid.

   # дальше нужноделать билд, но я его уже сделал
   # packer build yc-toolbox.pkr.hcl

   # https://yandex.cloud/ru/docs/tutorials/infrastructure-management/packer-custom-image
   # Запишите идентификатор собранного образа — параметр id. 
   # Используйте этот идентификатор в дальнейшем, чтобы создать ВМ.
   ```

   Создание виртуальной машины из нашего образа выглядит примерно так

   ```bash
   export VM_NAME="<имя_ВМ>"
   export YC_IMAGE_ID="<идентификатор_образа>"
   export YC_SUBNET_ID="<идентификатор_подсети>"
   export YC_ZONE="<зона_доступности>"

   yc compute instance create \
   --name $VM_NAME \
   --hostname $VM_NAME \
   --zone=$YC_ZONE \
   --create-boot-disk size=20GB,image-id=$YC_IMAGE_ID \
   --cores=2 \
   --memory=8G \
   --core-fraction=100 \
   --network-interface subnet-id=$YC_SUBNET_ID,ipv4-address=auto,nat-ip-version=ipv4 \
   --ssh-key <путь_к_публичной_части_SSH-ключа>

   ## из чего получаем строку для создания примерно такую
   ## yc --help compute instance create
   ##       --core-fraction int 
   ##           If provided, specifies baseline performance for a core in percent.
   ## SUBNET ID из web-консоли YC
   ## Скриншот: 05-virt-02-iaac/Screenshots/YC Subnet ID 2026-09-21 15-39-22.png
  
   yc compute instance create \
   --name "ijin82-packer-1" \
   --hostname "ijin82-vm1" \
   --zone=ru-central1-a \
   --create-boot-disk size=10GB,image-id=f2ebt3ehgu5haoffm3m7 \
   --cores=2 \
   --memory=2G \
   --core-fraction=100 \
   --network-interface subnet-id=fl8vc7230aibhuvqincn,ipv4-address=auto,nat-ip-version=ipv4 \
   --ssh-key ~/.ssh/vagrant.pub

   # И получаем ошибку:
   # >    --ssh-key cat ~/.ssh/vagrant.pub
   # ERROR: positional argument can not be used with flag '--name'

   yc compute instance create ijin82-packer-1 \
   --hostname "ijin82-vm1" \
   --zone=ru-central1-a \
   --create-boot-disk size=10GB,image-id=fd8gmnn38adduf1q40nc \
   --cores=2 \
   --memory=2G \
   --core-fraction=100 \
   --network-interface subnet-id=e9bucnd2o6qtgltlsjhv,ipv4-address=auto,nat-ip-version=ipv4 \
   --ssh-key ~/.ssh/vagrant.pub

   # Создано, скриншоты:
   # 05-virt-02-iaac/Screenshots/Create VM 1 2026-09-21 20-04-59.png
   # 05-virt-02-iaac/Screenshots/Create VM 2 2026-09-21 20-05-12.png
   # 05-virt-02-iaac/Screenshots/Create VM 3 2026-09-21 20-05-23.png
   # 05-virt-02-iaac/Screenshots/Create VM 4 - image 2026-09-21 20-05-30.png

   ## но 22 порт не доступен (не подключиться) потому что надо добавить группу безопасности в 
   ## которой надо открыть порт 22 иначе по умолчанию YC этот порт блокирует
   ## Скриншот
   ## 05-virt-02-iaac/Screenshots/Security GROUP 2026-09-21 16-25-18.png
   ## Смотрим группы
   ijin@tatuin ~/Work/net-devops1/05-virt-02-iaac/src
   $ yc compute image list
   +----------------------+------------------+-------------------+----------------------+--------+
   |          ID          |       NAME       |      FAMILY       |     PRODUCT IDS      | STATUS |
   +----------------------+------------------+-------------------+----------------------+--------+
   | fd8gmnn38adduf1q40nc | debian-11-docker | debian-web-server | f2ebt3ehgu5haoffm3m7 | READY  |
   +----------------------+------------------+-------------------+----------------------+--------++
   
   ## Смотрим инстансы ВМ
   ijin@tatuin ~/Work/net-devops1/05-virt-02-iaac/src
   $ yc compute instance list 
   +----------------------+-----------------+---------------+---------+---------------+-------------+
   |          ID          |      NAME       |    ZONE ID    | STATUS  |  EXTERNAL IP  | INTERNAL IP |
   +----------------------+-----------------+---------------+---------+---------------+-------------+
   | fhmpj83f29s6r9d11ig7 | ijin82-packer-1 | ru-central1-a | RUNNING | 89.169.134.38 | 10.128.0.26 |
   +----------------------+-----------------+---------------+---------+---------------+-------------+

   ## Удаляем ВМ
   yc compute instance delete fhmpj83f29s6r9d11ig7
   ```

   У меня есть регулярные проблемы с подключением по 22 порту. Очень много времени потратил  
   на эту проблему, проблема не в образе и не в облаке. Что-то с защитой облака либо ограничениями  
   подключений из Калининграда. 10 раз может не подключиться, на 11й подключится без изменений  
   конфигов или подключения.  
   В итоге я понимаю как делать провизию из конфигов для packer, как создавать образы, как  
   на основании образов собирать виртуалки, но докер мне установить таким образом не удалось,  
   в некоторых попытках я ловил ошибки при билде образа, но из-за постоянных проблем с подключением  
   отладиться у меня не получилось.

5. Подключитесь по ssh и убедитесь в наличии установленного docker.
   Подключение удалось установить, но на образе без провизии докера, понятно как эту установку сделать  
   но из-за проблем с подключением (в некоторых случаях с зеркалами дебиана) - не доделано  

6. Удалите ВМ и образ.
   Да, очищено.

7. **ВНИМАНИЕ!** Никогда не выкладываете oauth token от облака в git-репозиторий! Утечка секретного токена может привести к финансовым потерям. После выполнения задания обязательно удалите секретные данные из файла mydebian.json и mydebian.json.pkr.hcl. (замените содержимое токена на  "ххххх")
   Да, сделано, IAM токен живет 12 часов как я понял.

8. В качестве ответа на задание  загрузите результирующий файл в ваш ЛК.  
   Не понятно какой именно файл. Загружу этот и исправленные конфиги.  

## Итого

- Получил и подключил купон для YC
- Немного освоился с панелью YC: ВМ, диски, образы, сеть + подсети, группы безопасности
- Немного освоился с packer и yc-cli
- Смог создать кастомный образ с провизией внутри YC для последующего создания ВМ (mydebian.json)
- Смог создать ВМ на основе созданного кастомного образа и подключиться к ней (переключил 3 зоны: a, b, d)
- Исправил Vagrantfile и провизию в нем раньше работал с ним, провизия делалась так

  ```text
  config.vm.provision "shell",
    inline: "/bin/bash /home/vagrant/vagrant-vms/tatuin/provision-su.sh", privileged: true
  config.vm.provision "shell",
    inline: "/bin/bash /home/vagrant/vagrant-vms/tatuin/provision-non-su.sh", privileged: false
  config.vm.provision "shell",
    inline: "/bin/bash /home/vagrant/vagrant-vms/tatuin/each-reboot.sh", run: "always", privileged: false
  ```

  То есть под флаг `vagrant provision` (привилегированные и обычные) и простой `vagrant up` (`always`)

- В Vagrantfile пришлось сменить образ на `generic/ubuntu2004` потому что оригинальный - отвечает 404
- Запустил, зашел
  Скриншот 05-virt-02-iaac/Screenshots/Docker in Vagrant VBox  2026-09-21 22-38-12.png

  ```bash
  ijin@tatuin ~/Work/net-devops1/05-virt-02-iaac/src
  $ vagrant ssh
  Last login: Mon Sep 21 20:25:35 2026 from 10.0.2.2
  vagrant@server1:~$ htop --version
  htop 2.2.0 - (C) 2004-2019 Hisham Muhammad
  Released under the GNU GPL.
  
  vagrant@server1:~$ tmux -V
  tmux 3.0a
  vagrant@server1:~$ docker compose version
  Docker Compose version v2.35.1
  vagrant@server1:~$ docker --version
  Docker version 28.1.1, build 4eba377
  vagrant@server1:~$ hostname
  server1
  ```
