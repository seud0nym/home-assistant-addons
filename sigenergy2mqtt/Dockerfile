# https://developers.home-assistant.io/docs/apps/configuration#app-dockerfile
ARG BUILD_FROM
FROM $BUILD_FROM

COPY rootfs /
RUN chmod +x /etc/services.d/sigenergy2mqtt/*

RUN apk add pipx && pipx install /dist/sigenergy2mqtt-2026.3.21b2-py3-none-any.whl

