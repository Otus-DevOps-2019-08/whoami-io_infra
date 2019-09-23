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

```
testapp_IP = 35.208.161.9
testapp_port = 9292
```
