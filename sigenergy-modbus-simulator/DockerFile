# https://developers.home-assistant.io/docs/apps/configuration#app-dockerfile
# ARG BUILD_FROM=ghcr.io/home-assistant/amd64-base:latest
# FROM ${BUILD_FROM}

# The Supervisor always injects BUILD_FROM pointing to the plain base image, overriding the ARG default. 
# But you can just hardcode the FROM without the ARG at all:
FROM ghcr.io/home-assistant/base-python:3.14-alpine3.23
# Supported images can be found at https://github.com/home-assistant/docker-base/pkgs/container/base-python#python-images

# CVE-2026-27171 | CVSS 5.5 – Medium
RUN apk upgrade --no-cache zlib

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