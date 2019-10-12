FROM alpine:edge

LABEL "maintainer"="Bryan Velastegui <bryanslvr@gmail.com>"
LABEL "repository"="http://github.com/bvelastegui/rsync"
LABEL "homepage"="https://github.com/bvelastegui/rsync"

LABEL "com.github.actions.name"="Rsync Deploy"
LABEL "com.github.actions.description"="Deploy to a remote server with rsync via ssh."
LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="orange"

RUN apk upgrade --update-cache --available && \
    apk add openssl rsync && \
    rm -rf /var/cache/apk/*

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]