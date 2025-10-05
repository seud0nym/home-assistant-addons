# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile
ARG BUILD_FROM
FROM $BUILD_FROM

COPY rootfs /
RUN chmod +x /etc/services.d/sigenergy2mqtt/*

RUN apk add pipx && pipx install /dist/sigenergy2mqtt-2025.10.5-py3-none-any.whl

