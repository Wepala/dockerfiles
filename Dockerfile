FROM ubuntu

LABEL maintainer="marcus.sanatan@wepala.com"

ENV GOVERSION 1.11
ENV GOPATH /go

# Update repos so we can install later
RUN apt-get update

# Handle Timezone bug
RUN apt-get install -y tzdata
ENV TZ=America/Port_of_Spain
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install generic depedencies, python, node.js and php 
RUN apt-get install -y wget gcc g++ libssl-dev libc6-dev make pkg-config git openssl \
    curl unzip zip \
    python3 python3-pip python3-setuptools \
    php php7.2-dev php-common php-dev php-pear php-cli php-mbstring

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install AWS CLI
RUN pip3 install awscli

# Install go
RUN wget https://dl.google.com/go/go${GOVERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xvf go${GOVERSION}.linux-amd64.tar.gz && \
    rm go${GOVERSION}.linux-amd64.tar.gz && \
    export PATH="/usr/local/go/bin:$PATH";

ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
