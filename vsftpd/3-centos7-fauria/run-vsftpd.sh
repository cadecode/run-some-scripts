#!/bin/bash

# If no env var for FTP_USER has been specified, use 'admin':
if [ "$FTP_USER" = "**String**" ]; then
    export FTP_USER='admin'
fi

# If no env var has been specified, generate a random password for FTP_USER:
if [ "$FTP_PASS" = "**Random**" ]; then
    export FTP_PASS=`cat /dev/urandom | tr -dc A-Z-a-z-0-9 | head -c${1:-16}`
fi

# Do not log to STDOUT by default:
if [ "$LOG_STDOUT" = "**Boolean**" ]; then
    export LOG_STDOUT=''
else
    export LOG_STDOUT='Yes.'
fi

# Create home dir and update vsftpd user db:
mkdir -p "/home/vsftpd/${FTP_USER}"
chown -R ftp:ftp /home/vsftpd/

if ! grep -Fxq "${FTP_USER}" /etc/vsftpd/virtual_users.txt
then
    echo -e "${FTP_USER}\n${FTP_PASS}" >> /etc/vsftpd/virtual_users.txt
fi

/usr/bin/db_load -T -t hash -f /etc/vsftpd/virtual_users.txt /etc/vsftpd/virtual_users.db

# Set passive mode parameters:
if [ "$PASV_ADDRESS" = "**IPv4**" ]; then
    export PASV_ADDRESS=$(/sbin/ip route|awk '/default/ { print $3 }')
fi

# Replace or append a configuration item
grep -q "^pasv_address=" /etc/vsftpd/vsftpd.conf && sed -i "s/^pasv_address=.*/pasv_address=${PASV_ADDRESS}/" /etc/vsftpd/vsftpd.conf || echo "pasv_address=${PASV_ADDRESS}" >> /etc/vsftpd/vsftpd.conf
grep -q "^pasv_max_port=" /etc/vsftpd/vsftpd.conf && sed -i "s/^pasv_max_port=.*/pasv_max_port=${PASV_MAX_PORT}/" /etc/vsftpd/vsftpd.conf || echo "pasv_max_port=${PASV_MAX_PORT}" >> /etc/vsftpd/vsftpd.conf
grep -q "^pasv_min_port=" /etc/vsftpd/vsftpd.conf && sed -i "s/^pasv_min_port=.*/pasv_min_port=${PASV_MIN_PORT}/" /etc/vsftpd/vsftpd.conf || echo "pasv_min_port=${PASV_MIN_PORT}" >> /etc/vsftpd/vsftpd.conf
grep -q "^pasv_addr_resolve=" /etc/vsftpd/vsftpd.conf && sed -i "s/^pasv_addr_resolve=.*/pasv_addr_resolve=${PASV_ADDR_RESOLVE}/" /etc/vsftpd/vsftpd.conf || echo "pasv_addr_resolve=${PASV_ADDR_RESOLVE}" >> /etc/vsftpd/vsftpd.conf
grep -q "^pasv_enable=" /etc/vsftpd/vsftpd.conf && sed -i "s/^pasv_enable=.*/pasv_enable=${PASV_ENABLE}/" /etc/vsftpd/vsftpd.conf || echo "pasv_enable=${PASV_ENABLE}" >> /etc/vsftpd/vsftpd.conf
grep -q "^file_open_mode=" /etc/vsftpd/vsftpd.conf && sed -i "s/^file_open_mode=.*/file_open_mode=${FILE_OPEN_MODE}/" /etc/vsftpd/vsftpd.conf || echo "file_open_mode=${FILE_OPEN_MODE}" >> /etc/vsftpd/vsftpd.conf
grep -q "^local_umask=" /etc/vsftpd/vsftpd.conf && sed -i "s/^local_umask=.*/local_umask=${LOCAL_UMASK}/" /etc/vsftpd/vsftpd.conf || echo "local_umask=${LOCAL_UMASK}" >> /etc/vsftpd/vsftpd.conf
grep -q "^xferlog_std_format=" /etc/vsftpd/vsftpd.conf && sed -i "s/^xferlog_std_format=.*/xferlog_std_format=${XFERLOG_STD_FORMAT}/" /etc/vsftpd/vsftpd.conf || echo "xferlog_std_format=${XFERLOG_STD_FORMAT}" >> /etc/vsftpd/vsftpd.conf
grep -q "^reverse_lookup_enable=" /etc/vsftpd/vsftpd.conf && sed -i "s/^reverse_lookup_enable=.*/reverse_lookup_enable=${REVERSE_LOOKUP_ENABLE}/" /etc/vsftpd/vsftpd.conf || echo "reverse_lookup_enable=${REVERSE_LOOKUP_ENABLE}" >> /etc/vsftpd/vsftpd.conf
grep -q "^pasv_promiscuous=" /etc/vsftpd/vsftpd.conf && sed -i "s/^pasv_promiscuous=.*/pasv_promiscuous=${PASV_PROMISCUOUS}/" /etc/vsftpd/vsftpd.conf || echo "pasv_promiscuous=${PASV_PROMISCUOUS}" >> /etc/vsftpd/vsftpd.conf
grep -q "^port_promiscuous=" /etc/vsftpd/vsftpd.conf && sed -i "s/^port_promiscuous=.*/port_promiscuous=${PORT_PROMISCUOUS}/" /etc/vsftpd/vsftpd.conf || echo "port_promiscuous=${PORT_PROMISCUOUS}" >> /etc/vsftpd/vsftpd.conf

# Get log file path
export XFERLOG_FILE=`grep xferlog_file /etc/vsftpd/vsftpd.conf|cut -d= -f2`
export VSFTPD_LOG_FILE=`grep vsftpd_log_file /etc/vsftpd/vsftpd.conf|cut -d= -f2`

# Print server info:
cat << EOB
  *******************************************************
  *                                                     *
  *   Docker image: cadecode/vsftpd:3-centos7-fauria    *
  *                                                     *
  *******************************************************

  SERVER SETTINGS
  ---------------
  · FTP User: $FTP_USER
  · FTP Password: $FTP_PASS
  · xferlog file: $XFERLOG_FILE
  · vsftpd Log file: $VSFTPD_LOG_FILE
  · Redirect vsftpd log to STDOUT: $LOG_STDOUT
EOB

if [ $LOG_STDOUT ]; then
    # Use `tail` to redirect vsftpd log to STDOUT
    # but the disadvantage is that the log will have redundancy
    # It is better to work with a log auto rotation
    tail -F -n 0 $VSFTPD_LOG_FILE > /dev/stdout &
fi

# Run vsftpd:
&>/dev/null /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
