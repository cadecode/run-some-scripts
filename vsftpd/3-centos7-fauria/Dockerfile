FROM centos:7

ARG USER_ID=14
ARG GROUP_ID=50

LABEL org.opencontainers.image.description=" A docker image for vsftpd, based on `fauria/vsftpd` project with some optimization." \
      org.opencontainers.image.source="https://github.com/cadecode/run-some-scripts/tree/main/vsftpd/3-centos7-fauria" \
      # org.opencontainers.image.documentation="" \
      # org.opencontainers.image.url="" \
      org.opencontainers.image.authors="Cade Li <cadecode@foxmail.com>" \
      org.opencontainers.image.title="rabbitmq" \
      org.opencontainers.image.version="3-centos7-fauria" \
      org.opencontainers.image.base.name="centos:7"

# Fixed centos7 mirrorlist being deprecated, with url `vault.centos.org` instead
RUN set -x; sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo \
  && sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo \
  && sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo \
  && yum clean all \
  && yum makecache \
  && yum -y update \
  && yum clean all \
  && yum install -y vsftpd db4-utils db4 iproute \
  && yum clean all

RUN set -x; usermod -u ${USER_ID} ftp \
    && groupmod -g ${GROUP_ID} ftp

ENV FTP_USER=**String** \
    FTP_PASS=**Random** \
    PASV_ADDRESS=**IPv4** \
    PASV_ADDR_RESOLVE=NO \
    PASV_ENABLE=YES \
    PASV_MIN_PORT=21100 \
    PASV_MAX_PORT=21110 \
    XFERLOG_STD_FORMAT=NO \
    LOG_STDOUT=**Boolean** \
    FILE_OPEN_MODE=0666 \
    LOCAL_UMASK=077 \
    REVERSE_LOOKUP_ENABLE=YES \
    PASV_PROMISCUOUS=NO \
    PORT_PROMISCUOUS=NO

COPY vsftpd.conf /etc/vsftpd/
COPY vsftpd_virtual /etc/pam.d/
COPY run-vsftpd.sh /usr/sbin/

RUN set -x; chmod +x /usr/sbin/run-vsftpd.sh \
    && mkdir -p /home/vsftpd/ \
    && chown -R ftp:ftp /home/vsftpd/

VOLUME /home/vsftpd
VOLUME /var/log/vsftpd

EXPOSE 20 21

CMD ["/usr/sbin/run-vsftpd.sh"]
