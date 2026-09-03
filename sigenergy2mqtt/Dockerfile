# https://developers.home-assistant.io/docs/apps/configuration#app-dockerfile
# Supported images can be found at https://github.com/home-assistant/docker-base/pkgs/container/base-python#python-images
FROM ghcr.io/home-assistant/base-python:3.14-alpine3.24

# https://security.snyk.io/vuln/SNYK-ALPINE324-OPENSSL-19257375
# https://security.snyk.io/vuln/SNYK-ALPINE324-OPENSSL-19257376
# https://security.snyk.io/vuln/SNYK-ALPINE324-OPENSSL-19257380
# https://security.snyk.io/vuln/SNYK-ALPINE324-OPENSSL-19257381
# https://security.snyk.io/vuln/SNYK-ALPINE324-OPENSSL-19257382
# https://security.snyk.io/vuln/SNYK-ALPINE324-OPENSSL-19257384
# https://security.snyk.io/vuln/SNYK-ALPINE324-OPENSSL-19257388
# https://security.snyk.io/vuln/SNYK-ALPINE324-OPENSSL-19257390
# https://security.snyk.io/vuln/SNYK-ALPINE324-OPENSSL-19257391
# https://security.snyk.io/vuln/SNYK-ALPINE324-OPENSSL-19257392
RUN apk add --update --no-cache openssl

ENV PYTHONUNBUFFERED=1

COPY rootfs /
RUN chmod +x /etc/services.d/sigenergy2mqtt/*

RUN pip install --root-user-action=ignore --break-system-packages --no-cache-dir /dist/sigenergy2mqtt-2026.9.4b2-py3-none-any.whl
