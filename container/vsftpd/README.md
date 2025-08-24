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

Edit docker-compose.yml
```yaml
version: '3.8'

services:
  vsftpd:
    image: cadecode/vsftpd:3-centos7-fauria
    restart: unless-stopped
    ports:
      - "20:20"
      - "21:21"
      - "21100-21110:21100-21110"
    volumes:
      - vsftpd-config:/etc/vsftpd
      - ./home:/home/vsftpd
      - ./log:/var/log/vsftpd
    environment:
      # Default user
      FTP_USER: ftp
      FTP_PASS: ftp123
      # Passive mode
      PASV_ADDRESS: 192.168.100.1
      PASV_MIN_PORT: 21100
      PASV_MAX_PORT: 21110
      PASV_PROMISCUOUS: "YES"
      REVERSE_LOOKUP_ENABLE: "NO"

volumes:
  vsftpd-config:
    driver: local
    driver_opts:
      type: none
      device: ./config
      o: bind
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
- The vsftpd logs can be rotated auto by logrotate
- Virtual user account is not reset on restart
- Redundant content is not appended to config file
