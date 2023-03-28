# AJiaSu Docker

> The [`ajiasu`](https://www.91ajs.com/) is a proxy tool specifically for the China region, with a large selection of cities that you can use to change your IP address.

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

After the following few steps, the `ajiasu` container will be working on your system. Before that, make sure `docker` and `docker-compose` are installed.

### Preparation

Choose a working directory, and create a file named `ajiasu.conf` below. It include username and password, the template is as follows:

```ini
user [YOUR_USERNAME]
pass [YOUR_PASSWORD]

protocol lwip
cache_dir /etc/ajiasu
```

### Login

Create `login.yml` in the working directory and write these contents:

```yaml
version: '3'
services:
  ajiasu:
    image: dnomd343/ajiasu
    command: [login]
    volumes:
      - ./:/etc/ajiasu/
      - ./ajiasu.conf:/etc/ajiasu.conf
```

Execute the login command, if successful, there will be an output similar to the following:

```bash
$ docker-compose -f login.yml up
Creating network "ajiasu_default" with the default driver
Creating ajiasu_ajiasu_1 ... done
Attaching to ajiasu_ajiasu_1
ajiasu_1  | ajiasu 4.1.1.0 (core:20210315-1730)
ajiasu_1  | Load config file: /etc/ajiasu.conf
ajiasu_1  | Command: login
ajiasu_1  | Account: ···
ajiasu_1  | Logging in ...
ajiasu_1  | Login done.
ajiasu_1  | =====================================================
ajiasu_1  | Web Site: https://www.91ajs.com
ajiasu_1  | Login Result: OK
ajiasu_1  | Membership: 爱加速会员
ajiasu_1  | Expiration: ···
ajiasu_1  | =====================================================
ajiasu_ajiasu_1 exited with code 0

# This command is optional
$ docker-compose -f login.yml down
Removing ajiasu_ajiasu_1 ... done
Removing network ajiasu_default
```

### Listing

Create `list.yml` in the working directory and write these contents:

```yaml
version: '3'
services:
  ajiasu:
    image: dnomd343/ajiasu
    command: [list]
    volumes:
      - ./:/etc/ajiasu/
      - ./ajiasu.conf:/etc/ajiasu.conf
```

Execute the list command, if successful, there will be an output similar to the following:

```bash
$ docker-compose -f list.yml up
Creating network "ajiasu_default" with the default driver
Creating ajiasu_ajiasu_1 ... done
Attaching to ajiasu_ajiasu_1
ajiasu_1  | ajiasu 4.1.1.0 (core:20210315-1730)
ajiasu_1  | Load config file: /etc/ajiasu.conf
ajiasu_1  | Command: list
ajiasu_1  | Account: ···
ajiasu_1  |       id Status     Name (Comment)
ajiasu_1  | vvn-2076-264 ok         镇江 #1
ajiasu_1  | vvn-2081-23 ok         绍兴 #1
ajiasu_1  | vvn-2086-308 ok         南通 #1
ajiasu_1  | vvn-2106-527 ok         丽水 #1
ajiasu_1  | vvn-2111-684 ok         温州 #1
ajiasu_1  | vvn-2226-4013 ok         徐州 #2
ajiasu_1  | vvn-2431-4824 ok         厦门 #21
ajiasu_1  | vvn-2441-1877 ok         沈阳 #3
···
···
···
ajiasu_1  | vvn-5318-6878 ok         昭通 #1
ajiasu_1  | vvn-5319-6881 ok         海南藏族自治州 #2
ajiasu_1  | vvn-5320-6880 ok         海南藏族自治州 #1
ajiasu_1  | =====================================================
ajiasu_1  | Web Site: https://www.91ajs.com
ajiasu_1  | Login Result: OK
ajiasu_1  | Membership: 爱加速会员
ajiasu_1  | Expiration: ···
ajiasu_1  | =====================================================
ajiasu_ajiasu_1 exited with code 0

# This command is optional
$ docker-compose -f list.yml down
Removing ajiasu_ajiasu_1 ... done
Removing network ajiasu_default
```

### Connect

Select a node and modify `ajiasu.conf` file, add the bottom line, the modified file is as follows:

```ini
user [YOUR_USERNAME]
pass [YOUR_PASSWORD]

protocol lwip
cache_dir /etc/ajiasu
connect vvn-...
```

Create `compose.yml` in the working directory and write these contents:

```yml
version: '3'
services:
  ajiasu:
    image: dnomd343/ajiasu
    container_name: ajiasu
    network_mode: host
    privileged: true
    restart: always
    command: [connect]
    volumes:
      - ./:/etc/ajiasu/
      - ./ajiasu.conf:/etc/ajiasu.conf
```

Executing the following command will start the `ajiasu` service:

```bash
$ docker-compose up -d
Creating ajiasu ... done
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

If something goes wrong, you can check the logs:

```bash
$ docker-compose logs
Attaching to ajiasu
···
```

While it is running, you can quickly list all nodes:

```bash
$ docker exec ajiasu ajiasu list
ajiasu 4.1.1.0 (core:20210315-1730)
Load config file: /etc/ajiasu.conf
Command: list
Account: ···
      id Status     Name (Comment)
vvn-2076-264 ok         镇江 #1
vvn-2081-23 ok         绍兴 #1
vvn-2086-308 ok         南通 #1
vvn-2106-527 ok         丽水 #1
vvn-2111-684 ok         温州 #1
vvn-2226-4013 ok         徐州 #2
vvn-2431-4824 ok         厦门 #21
vvn-2441-1877 ok         沈阳 #3
···
···
···
vvn-5318-6878 ok         昭通 #1
vvn-5319-6881 ok         海南藏族自治州 #2
vvn-5320-6880 ok         海南藏族自治州 #1
=====================================================
Web Site: https://www.91ajs.com
Login Result: OK
Membership: 爱加速会员
Expiration: ···
=====================================================
```

### Exit

When you do not need the `ajiasu` service, execute the following command to close it:

```bash
$ docker-compose down
Stopping ajiasu ... done
Removing ajiasu ... done
```

You don't need to repeat the login and listing process at the next startup. If you need to switch nodes, just modify the last line of the `ajiasu.conf` file and execute the following command:

```bash
$ docker-compose up -d
Creating ajiasu ... done

# Need to switch nodes -> modify ajiasu.conf

$ docker-compose restart
Restarting ajiasu ... done
```

## Build

You can build the container image yourself if necessary.

```bash
docker build -t ajiasu https://github.com/dnomd343/ajiasu-docker.git
```

At the same time, it is also possible to perform a cross-build.

```bash
docker buildx build -t dnomd343/ajiasu --platform="linux/amd64,linux/arm64,linux/386,linux/arm/v7" https://github.com/dnomd343/ajiasu-docker.git --push
```

## License

MIT ©2023 [@dnomd343](https://github.com/dnomd343)
