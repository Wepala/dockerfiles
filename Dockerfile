FROM ubuntu

LABEL maintainer="marcus.sanatan@wepala.com"

# Go variables
ENV GOVERSION 1.12
ENV GOPATH /go

# Terraform variables
ENV TERRAFORM_VERSION 0.11.13

# Update repos so we can install later
RUN apt-get update

# Handle Timezone bug
RUN apt-get install -y tzdata
ENV TZ=America/Port_of_Spain
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install generic depedencies, python, node.js and php 
RUN apt-get install -y wget gcc g++ libssl-dev libc6-dev make pkg-config git openssl \
    curl unzip zip \
    python3 python3-pip python3-setuptools
RUN apt-get install -y nodejs npm 
RUN apt-get install -y php php-common php-dev php-pear php-cli php-mbstring

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install AWS CLI
RUN pip3 install awscli

# Install terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install go
RUN wget https://dl.google.com/go/go${GOVERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xvf go${GOVERSION}.linux-amd64.tar.gz && \
    rm go${GOVERSION}.linux-amd64.tar.gz && \
    export PATH="/usr/local/go/bin:$PATH";

ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
RUN go get -u github.com/golang/dep/cmd/dep && go get -u github.com/pressly/goose/cmd/goose
