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

COPY rootfs /
RUN chmod +x /etc/services.d/sigenergy2mqtt/*

RUN pip install --root-user-action=ignore --break-system-packages --no-cache-dir /dist/sigenergy2mqtt-2026.4.4-py3-none-any.whl
