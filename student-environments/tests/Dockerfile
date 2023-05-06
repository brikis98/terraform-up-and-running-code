FROM alpine:latest

ENV AWSCLI_VERSION "1.16.243"
ENV TERRAFORM_VERSION="0.12.9"

RUN apk add --no-cache git jq curl \
	python \
    python-dev \
    py-pip \
    build-base \
    && pip install awscli==$AWSCLI_VERSION --upgrade --user \
    && apk --purge -v del py-pip \
    && rm -rf /var/cache/apk/*


RUN curl -O https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_$TERRAFORM_VERSION_linux_amd64.zip && \
	unzip terraform_$TERRAFORM_VERSION_linux_amd64.zip -d /usr/bin/

ENV AWS_DEFAULT_REGION=
ENV AWS_ACCESS_KEY_ID=
ENV AWS_SECRET_ACCESS_KEY=
ENV TF_VAR_student_alias=

RUN mkdir -p /workdir
WORKDIR /workdir

