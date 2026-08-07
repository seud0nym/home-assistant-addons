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
# https://security.snyk.io/vuln/SNYK-ALPINE324-CARES-17896522
RUN apk upgrade --no-cache c-ares
# https://security.snyk.io/vuln/SNYK-ALPINE324-BIND-18310067
# https://security.snyk.io/vuln/SNYK-ALPINE324-BIND-18310068
# https://security.snyk.io/vuln/SNYK-ALPINE324-BIND-18310071
# https://security.snyk.io/vuln/SNYK-ALPINE324-BIND-18310072
# https://security.snyk.io/vuln/SNYK-ALPINE324-BIND-18310073
# https://security.snyk.io/vuln/SNYK-ALPINE324-BIND-18310075
# https://security.snyk.io/vuln/SNYK-ALPINE324-BIND-18310076
# https://security.snyk.io/vuln/SNYK-ALPINE324-BIND-18310077
# https://security.snyk.io/vuln/SNYK-ALPINE324-BIND-18310078
RUN apk upgrade --no-cache bind bind-libs bind-tools

ENV PYTHONUNBUFFERED=1

COPY rootfs /
RUN chmod +x /etc/services.d/sigenergy2mqtt/*

RUN pip install --root-user-action=ignore --break-system-packages --no-cache-dir /dist/sigenergy2mqtt-2026.8.7b1-py3-none-any.whl
