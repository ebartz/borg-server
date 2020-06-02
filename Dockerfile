FROM alpine:latest
MAINTAINER ebartzsva
#Install Borg & SSH
RUN apk add openssh sshfs borgbackup supervisor --no-cache
RUN adduser -D -u 1000 borgbackup && \
    mkdir -p /backups && \
    chown borgbackup.borgbackup /backups && \
    sed -i \
        -e 's/^#PasswordAuthentication yes$/PasswordAuthentication no/g' \
        -e 's/^PermitRootLogin without-password$/PermitRootLogin no/g' \
        /etc/ssh/sshd_config
COPY supervisord.conf /etc/supervisord.conf
COPY service.sh /usr/local/bin/service.sh
RUN passwd -u borgbackup
EXPOSE 22
CMD ["/usr/bin/supervisord"]
