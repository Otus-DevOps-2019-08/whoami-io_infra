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

