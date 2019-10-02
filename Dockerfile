FROM golang:alpine
MAINTAINER SHOGO MAEDA

LABEL io.whalebrew.config.environment '["SAKURACLOUD_ACCESS_TOKEN", "SAKURACLOUD_ACCESS_TOKEN_SECRET" , "SAKURACLOUD_ZONE" , "SAKURACLOUD_TIMEOUT" , "SAKURACLOUD_TRACE_MODE","SACLOUD_OJS_ACCESS_KEY_ID","SACLOUD_OJS_SECRET_ACCESS_KEY" ]'

ENV TERRAFORM_VERSION=0.12.3

RUN apk add --update git bash openssh curl unzip

RUN mkdir -p ~/terraform \
 && cd ~/terraform \
 && curl -sL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform.zip \
 && unzip terraform.zip -d /bin \
 && rm -f terraform.zip

ADD https://github.com/sacloud/terraform-provider-sakuracloud/releases/download/v1.16.3/terraform-provider-sakuracloud_1.16.3_linux-amd64.zip ./
RUN unzip terraform-provider-sakuracloud_1.16.3_linux-amd64.zip -d /bin
RUN rm -f terraform-provider-sakuracloud_1.16.3_linux-amd64.zip

VOLUME ["/workdir"]
WORKDIR /workdir

RUN go get -u github.com/mercari/tfnotify
RUN go get -u github.com/ak1ra24/mnoclient
RUN go get -u github.com/ak1ra24/tfstatediff

ENTRYPOINT ["/bin/terraform"]
CMD ["--help"]
