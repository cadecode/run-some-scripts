# vsftpd

> A docker image for vsftpd, based on `fauria/vsftpd` project with some optimization
> 
> More about: 
> - https://github.com/cadecode/run-some-scripts/tree/main/vsftpd
> - fauria/vsftpd: https://hub.docker.com/r/fauria/vsftpd

## Usage

Pull image

```shell
docker pull cadecode/vsftpd:3-centos7-fauria
```

Run compose

```shell
docker compose up -d
```

## Tag

### centos7-fauria

This image optimizes `fauria/vsftpd` project in several ways

- Record both standard xferlog format and vsftpd logs
- The vsftpd logs can be synchronized to stdout
- Virtual user account is not reset on restart
- Redundant content is not appended to config file
