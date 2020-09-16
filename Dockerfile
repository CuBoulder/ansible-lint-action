####################################
## Dockerfile to run Anisble Lint ##
####################################
FROM python:alpine

#########################################
# Label the instance and set maintainer #
#########################################
LABEL com.github.actions.name="Ansible Lint" \
    com.github.actions.description="Lint your code base with Ansible Lint" \
    com.github.actions.icon="code" \
    com.github.actions.color="red" \
    maintainer="CU Boulder"

RUN apk add --update --no-cache \
    bash \
    gcc \
    git git-lfs \
    py3-setuptools \
    musl-dev \
    libffi-dev \
    openssl-dev \
    python3-dev

RUN pip3 install ansible-lint

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
