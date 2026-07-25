# https://developers.home-assistant.io/docs/apps/configuration#app-dockerfile
# Supported images can be found at https://github.com/home-assistant/docker-base/pkgs/container/base-python#python-images
FROM ghcr.io/home-assistant/base-python:3.14-alpine3.24

# https://security.snyk.io/vuln/SNYK-ALPINE324-CURL-17716543
# https://security.snyk.io/vuln/SNYK-ALPINE324-CURL-17716663
# https://security.snyk.io/vuln/SNYK-ALPINE324-CURL-17717190
# https://security.snyk.io/vuln/SNYK-ALPINE324-CURL-17717313
# https://security.snyk.io/vuln/SNYK-ALPINE324-CURL-17717410
# https://security.snyk.io/vuln/SNYK-ALPINE324-CURL-17717433
# https://security.snyk.io/vuln/SNYK-ALPINE324-CURL-17717489
# https://security.snyk.io/vuln/SNYK-ALPINE324-CURL-17717495
# https://security.snyk.io/vuln/SNYK-ALPINE324-CURL-17717584
# https://security.snyk.io/vuln/SNYK-ALPINE324-CURL-17717618
# https://security.snyk.io/vuln/SNYK-ALPINE324-CURL-17717651
# https://security.snyk.io/vuln/SNYK-ALPINE324-CURL-17717674
# https://security.snyk.io/vuln/SNYK-ALPINE324-CURL-17717707
# https://security.snyk.io/vuln/SNYK-ALPINE324-CURL-17717716
# https://security.snyk.io/vuln/SNYK-ALPINE324-CURL-17717717
# https://security.snyk.io/vuln/SNYK-ALPINE324-CURL-17717718
# https://security.snyk.io/vuln/SNYK-ALPINE324-CURL-17717719
# https://security.snyk.io/vuln/SNYK-ALPINE324-CURL-17717720
RUN apk upgrade --no-cache curl
# https://security.snyk.io/vuln/SNYK-ALPINE324-EXPAT-17662022
# https://security.snyk.io/vuln/SNYK-ALPINE324-EXPAT-17662023
# https://security.snyk.io/vuln/SNYK-ALPINE324-EXPAT-17662024
# https://security.snyk.io/vuln/SNYK-ALPINE324-EXPAT-17662025
# https://security.snyk.io/vuln/SNYK-ALPINE324-EXPAT-17662026
# https://security.snyk.io/vuln/SNYK-ALPINE324-EXPAT-17662027
# https://security.snyk.io/vuln/SNYK-ALPINE324-EXPAT-17662028
# https://security.snyk.io/vuln/SNYK-ALPINE324-EXPAT-17662029
# https://security.snyk.io/vuln/SNYK-ALPINE324-EXPAT-17662030
# https://security.snyk.io/vuln/SNYK-ALPINE324-EXPAT-17662031
# https://security.snyk.io/vuln/SNYK-ALPINE324-EXPAT-17662032
# https://security.snyk.io/vuln/SNYK-ALPINE324-EXPAT-17662033
# https://security.snyk.io/vuln/SNYK-ALPINE324-EXPAT-17662034
RUN apk upgrade --no-cache libexpat

ENV PYTHONUNBUFFERED=1

COPY rootfs /
RUN chmod +x /etc/services.d/sigenergy2mqtt/*

RUN pip install --root-user-action=ignore --break-system-packages --no-cache-dir /dist/sigenergy2mqtt-2026.7.25b3-py3-none-any.whl
