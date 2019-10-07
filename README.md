[![Build Status](https://travis-ci.com/Otus-DevOps-2019-08/whoami-io_infra.svg?branch=master)](https://travis-ci.com/Otus-DevOps-2019-08/whoami-io_infra)

# whoami-io_infra
whoami-io Infra repository

## Working on Otus-DevOps-2019-08 homeworks

### Task 1
- First PR

Result: `merged`

### Task 2 ChatOps. 
- Working on Slack, Travis integration

Result: `play-travis`
[![Build Status](https://travis-ci.com/Otus-DevOps-2019-08/whoami-io_infra.svg?branch=play-travis)](https://travis-ci.com/Otus-DevOps-2019-08/whoami-io_infra)

### Task 3 GCP
- Create account in GCP
- ssh
- Create VM instances in GCP.
- Setup network and firewall rules
- Install and run Pritunl server
- OpenVpn

1) Обязательный блок для проверки домашней работы
```
bastion_IP = 35.208.161.9
someinternalhost_IP = 10.128.0.3
```


2) Способ подключения к someinternalhost в одну
команду:
```
ssh appuser@10.128.0.3 -o "proxycommand ssh -W %h:%p -i ~/.ssh/appuser appuser@35.208.161.9"
```

3) Подключения из консоли при помощи команды вида `ssh someinternalhost`:

```
vi ~/.ssh/config
```

```
Host someinternalhost
   User appuser
   HostName 10.128.0.3
   IdentityFile ~/.ssh/appuser
   ProxyCommand ssh appuser@35.208.161.9 -W %h:%p
```

4) Реализуйте использование валидного сертификата для панели управления
VPN-сервера:
sslip.io/xip.io  и Let’s Encrypt
Добавить доменное имя в  Pritunl -> Settings -> Lets Encrypt Domain


### Task 4 GCP

Для проверки домашнего задания:
```
testapp_IP = 35.208.161.9
testapp_port = 9292
```

Одна команда для настройки VM и деплоя приложения при помощи `--metadata-from-file startup-script=s` :

```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --network-tier STANDARD \
  --metadata-from-file startup-script=startup_script.sh
```

...и дождаться окончания установки :) Можно проверить, зайдя на VM, `bundler -v` и `sudo systemctl status mongod`.


То же самое с `--metadata startup-script-url` :

```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --network-tier STANDARD \
  --metadata-from-file startup-script-url=gs://path-to-script
  ```

Использовать статический external-ip `35.208.161.9` :
```
  gcloud compute instances delete-access-config reddit-app --access-config-name "external-nat"
```

```
  gcloud compute instances add-access-config reddit-app --access-config-name="External NAT" --address=35.208.161.9 --network-tier STANDARD
```
 
Добавить firewall rule:

```
gcloud compute firewall-rules create default-puma-server \
	--action allow \
	--direction ingress \
	--rules tcp:9292 \
	--source-ranges 0.0.0.0/0 \
	--target-tags puma-server
```

### Task 5 Packer

Summary:
- use Packer
- prepare 'fry' image for course app.
- prepare 'bake' image for course app.
- use 'Systemd unit' to start puma server to get instance with already running app.
- add sh script to run instance in GCP.

#### Домашнее задание: Сборка образа при помощи Packer

1. Создан образ VM  `reddit-base`(без параметров)
./packer
```
packer build ubuntu16.json
```
2. Создан образ VM `reddit-base` (с параметрами)

./packer 
```
packer build -var-file=variables.json.example  ubuntu16.json
```

3. Запускаем инстанс из созданного образа и на нем сразу
же имеем запущенное приложение:

Cобираем образ:

./packer 
```
packer build -var-file=variables.json.example  immutable.json
```
Чтобы собрать образ на основе 'reddit-base', указываем: 

./immutable.json
```
"source_image_family": "reddit-base",
```

Чтобы приложение сразу запустилось, добавим автозапуск команды `puma -d` при помощи Systemd: 

./files/reddit-start.service

```
[Unit]
Description=StartRedditApp // что делает сервис, просто полезное описание

[Service]
ExecStart=/usr/local/bin/puma --dir /home/appuser/reddit // эквивалент puma -d, требует абсолютные пути

[Install]
WantedBy=multi-user.target // разрешить запуск из консоли
```

Добавим этот шаг в immutable.json:

./packer/immutable.json
```  ...
    "provisioners": [
       {
            "type": "file",
            "source": "files/reddit-start.service",
            "destination": "/tmp/reddit-start.service" // куда положить файл
       },
              {
            "type": "shell",
            "script": "scripts/deploy.sh", 
	    /*
	    // sudo mv /tmp/reddit-start.service /etc/systemd/system/ // перекопировать файл в дефолтную директорию
	    // и помечаем файл как только на чтение/запись, но не выполнение
            // sudo chmod 664 /etc/systemd/system/reddit-start.service
	    // systemctl daemon-reload // чтобы systemd подгружало изменения в конфиг-файлах
            // sudo systemctl start reddit-start // запустить сервис
	    // sudo systemctl enable reddit-start // запускать сервис при загрузке 
	    //
	    */
            "execute_command": "sudo {{.Path}}"
       }
       ...
```

Cобираем образ:

./packer 
```
packer build -var-file=variables.json.example  immutable.json
```

4. Запустить одной командой инстанс в GCP с запущенным приложением:
```
./config-scripts/create-redditvm.sh
```

### Task 6 Terraform (1)

#### В процессе сделано:

 - добавлен main.tf
 - - описание ресурса google-cloud для создания VM инстанса и правила файервола + добавление ключей ssh для appuser
 - - используется reddit-base image и скрипты для деплоя из предыдущего дз
 - получаем внешний адрес запущенного инстанса outputs.tf
 - прокидывем переменные из variables.tf. Значения берутся из terraform.tfvars (см для примера terraform.tfvars.example) или дефолтные значения (см region и zone из variables.tf)
 
#### Как запустить:

```
cd ./terraform
```

Убедиться, что установлена версия terraform 0.12.8:
```
terraform -v
```

Проверить, какие изменения применятся:
```
terraform plan
```

Применить изменения:
```
terraform apply
```

Результатом будет запущенное приложение на `<public-external-ip>:9292`

##### Отформатировать конфигурационные файлы
```
terraform fmt
```

#### Удалить созданные terraform-ом ресурсы:
```
terraform destroy
```

