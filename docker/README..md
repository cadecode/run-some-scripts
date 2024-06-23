# docker

## Install docker

### Install with the official shell script

```shell
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

Use `--version` to install a specific version, e.g., version 23.0

Use `--mirror` to install from a mirror, e.g., Aliyun, AzureChinaCloud

```shell
sudo sh get-docker.sh --version 23.0 --mirror Aliyun
```

### Install with package manager

Use apt or yum

```shell
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

## Install docker-compose

When use `get-docker.sh` to install docker, in newer versions (21.10 up), command `docker compose` is provided by default

We can also Install witch a binary file, e.g., version 1.28.2

```shell
curl -L https://github.com/docker/compose/releases/download/1.28.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### Config registry mirror

Modify `/etc/docker/daemon.json`

```shell
sudo vi /etc/docker/daemon.json
```

Set mirror site url to `registry-mirrors`

```
{
  "registry-mirrors": [
    "https://registry.docker-cn.com"
  ]
}
```

Restart docker

```shell
sudo systemctl daemon-reload
sudo systemctl restart docker
```
