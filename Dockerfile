FROM alpine:3.8
MAINTAINER lafant

ENV NODE_ID=1                     \
    SPEEDTEST=6                   \
    CLOUDSAFE=1                   \
    AUTOEXEC=0                    \
    ANTISSATTACK=0                \
    MYSQL_HOST=127.0.0.1          \
    MYSQL_PORT=3306               \
    MYSQL_USER=ss                 \
    MYSQL_PASS=ss                 \
    MYSQL_DB=shadowsocks          \

RUN  apk --no-cache add \
                        curl \
                        python3-dev \
                        libsodium-dev \
                        openssl-dev \
                        udns-dev \
                        mbedtls-dev \
                        pcre-dev \
                        libev-dev \
                        libtool \
                        libffi-dev            && \
     apk --no-cache add --virtual .build-deps \
                        git \
                        tar \
                        make \
                        py3-pip \
                        autoconf \
                        automake \
                        build-base \
                        linux-headers         && \
     ln -s /usr/bin/python3 /usr/bin/python   && \
     ln -s /usr/bin/pip3    /usr/bin/pip      && \
     git clone -b manyuser https://github.com/lafant/shadowsocks-mu.git "/root/shadowsocks" --depth 1 && \
     cd  /root/shadowsocks                    && \
     rm -rf ~/.cache && touch /etc/hosts.deny && \
     apk del --purge .build-deps

WORKDIR /root/shadowsocks

CMD sed -i "s|NODE_ID = 1|NODE_ID = ${NODE_ID}|"                               /root/shadowsocks/userapiconfig.py && \
    sed -i "s|SPEEDTEST = 6|SPEEDTEST = ${SPEEDTEST}|"                         /root/shadowsocks/userapiconfig.py && \
    sed -i "s|CLOUDSAFE = 1|CLOUDSAFE = ${CLOUDSAFE}|"                         /root/shadowsocks/userapiconfig.py && \
    sed -i "s|AUTOEXEC = 0|AUTOEXEC = ${AUTOEXEC}|"                            /root/shadowsocks/userapiconfig.py && \
    sed -i "s|ANTISSATTACK = 0|ANTISSATTACK = ${ANTISSATTACK}|"                /root/shadowsocks/userapiconfig.py && \
    sed -i "s|MYSQL_HOST = '127.0.0.1'|MYSQL_HOST = '${MYSQL_HOST}'|"          /root/shadowsocks/userapiconfig.py && \
    sed -i "s|MYSQL_PORT = 3306|MYSQL_PORT = ${MYSQL_PORT}|"               /root/shadowsocks/userapiconfig.py && \
    sed -i "s|MYSQL_USER = 'ss'|MYSQL_USER = '${MYSQL_USER}'|"                 /root/shadowsocks/userapiconfig.py && \
    sed -i "s|MYSQL_PASS = 'ss'|MYSQL_PASS = '${MYSQL_PASS}'|"                 /root/shadowsocks/userapiconfig.py && \
    sed -i "s|MYSQL_DB = 'shadowsocks'|MYSQL_DB = '${MYSQL_DB}'|"              /root/shadowsocks/userapiconfig.py && \

    python /root/shadowsocks/server.py
