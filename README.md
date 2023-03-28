# 爱加速容器镜像

> `Ajiasu` is a proxy tool specifically for the China region, with a large selection of cities that you can use to change your IP address.

[Official Site](https://www.91ajs.com/)

## Basic Option

CLI usage:

```ini
ajiasu -h
ajiasu {login|list|logout}
ajiasu connect "Shanghai 1*"
```

Config file options:

```ini
user your-account-name
pass your-password

cache_dir [CACHE_DIR]
connect [SERVER_NAME]
protocol {udp|tcp|lwip|socks5|http|proxy}
use_vpn_dns {yes|no}
use_vpn_route {yes|no}
up_down [SCRIPT_FILE]
```

## Quick Start

First choose a working directory, and create a file `ajiasu.conf` below. It include username and password, the template is as follows:

```ini
user [YOUR_USERNAME]
pass [YOUR_PASSWORD]

protocol lwip
cache_dir /etc/ajiasu
```

Second, login your account:

```bash
$ docker run --rm -it \
  --volume ${YOUR_WORK_DIR}:/etc/ajiasu/ \
  --volume ${YOUR_WORK_DIR}/ajiasu.conf:/etc/ajiasu.conf \
  dnomd343/ajiasu login
···
Account: ···
Logging in ...
Login done.
=====================================================
Web Site: https://www.91ajs.com
Login Result: OK
Membership: 爱加速会员
Expiration: ...
=====================================================
```

Then, list all nodes:

```bash
$ docker run --rm -it \
  --volume ${YOUR_WORK_DIR}:/etc/ajiasu/ \
  --volume ${YOUR_WORK_DIR}/ajiasu.conf:/etc/ajiasu.conf \
  dnomd343/ajiasu list
···
    id     Status     Name (Comment)
vvn-2076-264 ok         镇江 #1
vvn-2081-23  ok         绍兴 #1
vvn-2086-308 ok         南通 #1
vvn-2106-527 ok         丽水 #1
···
···
···
vvn-5317-6877 ok        昭通 #2
vvn-5318-6878 ok        昭通 #1
vvn-5319-6881 ok        海南藏族自治州 #2
vvn-5320-6880 ok        海南藏族自治州 #1
=====================================================
···
```

Last, select a node, and then connect it:

```bash
$ docker run -d --privileged --name ajiasu \
  --restart always --network host \
  --volume ${YOUR_WORK_DIR}:/etc/ajiasu/ \
  --volume ${YOUR_WORK_DIR}/ajiasu.conf:/etc/ajiasu.conf \
  dnomd343/ajiasu connect vvn-...
```

If nothing unexcepted, `ajiasu` is already working normally, you can check the IP to confirm:

```bash
# whether the IP location is the city you choose
$ curl ip.343.re/info
IP: ···
AS: ···
City: 重庆
Region: 重庆
Country: CN - China（中国）
Timezone: Asia/Shanghai
Location: 29.59,106.54
ISP: China Unicom Limited
Scope: ···
Detail: 重庆市联通
```

If something gose wrong, you can check the logs:

```bash
$ docker logs -f ajiasu
···
```

It is more recommended that you use `docker-compose` to start the service, create `docker-compose.yml` file under the working directory with following content:

```yaml
version: '3'
services:
  ajiasu:
    image: dnomd343/ajiasu
    container_name: ajiasu
    network_mode: host
    privileged: true
    restart: always
    tty: true
    command:
      - connect
      - vvn-...
    volumes:
      - ${YOUR_WORK_DIR}:/etc/ajiasu/
      - ${YOUR_WORK_DIR}/ajiasu.conf:/etc/ajiasu.conf
```

Start the container:

```bash
$ docker-compose up -d
Creating ajiasu ... done
```

Quickly list all nodes:

```bash
$ docker exec ajiasu ajiasu list
···
    id     Status     Name (Comment)
vvn-2076-264 ok         镇江 #1
vvn-2081-23  ok         绍兴 #1
vvn-2086-308 ok         南通 #1
vvn-2106-527 ok         丽水 #1
···
···
···
vvn-5317-6877 ok        昭通 #2
vvn-5318-6878 ok        昭通 #1
vvn-5319-6881 ok        海南藏族自治州 #2
vvn-5320-6880 ok        海南藏族自治州 #1
=====================================================
···
```

## Build

```bash
docker buildx build -t dnomd343/ajiasu --platform="linux/amd64,linux/arm64,linux/386,linux/arm/v7" https://github.com/dnomd343/ajiasu-docker.git --push
```

## License

MIT ©2023 [@dnomd343](https://github.com/dnomd343)
