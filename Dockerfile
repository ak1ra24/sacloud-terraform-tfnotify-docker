FROM golang:1.13.10-alpine

ENV TERRAFORM_VERSION=0.12.20
ENV SACLOUD_TERRAFORM_VERSION=1.21.3

RUN apk add --update git bash openssh curl unzip tar


RUN mkdir -p ~/terraform \
 && cd ~/terraform \
 && curl -sL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform.zip \
 && unzip terraform.zip -d /bin \
 && rm -f terraform.zip

ADD https://github.com/sacloud/terraform-provider-sakuracloud/releases/download/v${SACLOUD_TERRAFORM_VERSION}/terraform-provider-sakuracloud_${SACLOUD_TERRAFORM_VERSION}_linux-amd64.zip ./
RUN unzip terraform-provider-sakuracloud_${SACLOUD_TERRAFORM_VERSION}_linux-amd64.zip -d /bin
RUN rm -f terraform-provider-sakuracloud_${SACLOUD_TERRAFORM_VERSION}_linux-amd64.zip

RUN curl -sL https://github.com/mercari/tfnotify/releases/download/v0.6.0/tfnotify_linux_amd64.tar.gz > tfnotify.tar.gz \
 && tar -zxvf tfnotify.tar.gz -C /bin \
 && rm -f tfnotify.tar.gz

VOLUME ["/workdir"]
WORKDIR /workdir

ENV GO111MODULE=on

RUN go get -u github.com/ak1ra24/mnoclient
RUN go get -u github.com/ak1ra24/tfstatediff

ENTRYPOINT ["/bin/terraform"]
CMD ["--help"]
