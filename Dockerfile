
FROM alpine:3.11

RUN apk add --no-cache openssh; \
    adduser -D user; mkdir /home/user/.ssh; chown user:user /home/user/.ssh; chmod 0700 /home/user/.ssh; \
    touch /home/user/.ssh/authorized_keys; chown user:user /home/user/.ssh/authorized_keys
    
ADD entrypoint.sh /entrypoint.sh

ARG SSHD_PORT=22
ENV SSHD_PORT=$SSHD_PORT

EXPOSE $SSHD_PORT
CMD    ["sh", "/entrypoint.sh"]
