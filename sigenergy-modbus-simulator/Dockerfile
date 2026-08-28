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

WORKDIR /app

# Clone the sigenergy2mqtt repository (which contains the Modbus simulator)
RUN apk add --no-cache bash git \
    && git clone --depth=1 https://github.com/seud0nym/sigenergy2mqtt.git /app \
    && /app/scripts/dependencies --install-only --skip-build-deps \
    && apk del git

# Displayed by the simulator at start-up
RUN echo "$(date +"%Y-%m-%dT%H:%M:%S%z")" > /app/build_date.txt

COPY rootfs /
RUN chmod +x /etc/services.d/sigenergy-modbus-simulator/*

EXPOSE 502