FROM alpine:3.8
MAINTAINER lafant

ENV NODE_ID=1                     \
      
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

    python /root/shadowsocks/server.py
