# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile
ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add pipx && pipx install sigenergy2mqtt

COPY rootfs /
RUN chmod +x /etc/services.d/sigenergy2mqtt/*