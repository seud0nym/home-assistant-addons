# https://developers.home-assistant.io/docs/apps/configuration#app-dockerfile
# Supported images can be found at https://github.com/home-assistant/docker-base/pkgs/container/base-python#python-images
FROM ghcr.io/home-assistant/base-python:3.15-alpine3.24

# Update all available packages to mitigate vulnerabilities
RUN apk upgrade --update --no-cache --available

# Mitigate Snyk findings for Alpine 3.24 and Python 3.14
#  -  https://security.snyk.io/vuln/SNYK-GOLANG-STDCRYPTOTLS-18858453
#  -  https://security.snyk.io/vuln/SNYK-GOLANG-STDCRYPTOX509-21400137
#  -  https://security.snyk.io/vuln/SNYK-GOLANG-STDENCODINGASN1-18858463
#  -  https://security.snyk.io/vuln/SNYK-GOLANG-STDENCODINGXML-18858455
#  -  https://security.snyk.io/vuln/SNYK-GOLANG-STDHTMLTEMPLATE-18858461
#  -  https://security.snyk.io/vuln/SNYK-GOLANG-STDNET-18858450
#  -  https://security.snyk.io/vuln/SNYK-GOLANG-STDNETHTTP-18858429
#  -  https://security.snyk.io/vuln/SNYK-GOLANG-STDNETURL-18858438
RUN rm -f /usr/bin/tempio

# Mitigate Snyk findings for Alpine 3.24 and Python 3.15
# - https://security.snyk.io/vuln/SNYK-ALPINE324-OPENSSL-22602641
# - https://security.snyk.io/vuln/SNYK-ALPINE324-OPENSSL-22602642
# - https://security.snyk.io/vuln/SNYK-ALPINE324-OPENSSL-22602643
# - https://security.snyk.io/vuln/SNYK-ALPINE324-OPENSSL-22602645
# - https://security.snyk.io/vuln/SNYK-ALPINE324-OPENSSL-22602647
RUN apk update && \
    apk add --no-cache 'openssl>=3.5.9-r1' 'libcrypto3>=3.5.9-r1' 'libssl3>=3.5.9-r1'

# Mitigate Snyk findings for Alpine 3.24 and Python 3.15
# - https://security.snyk.io/vuln/SNYK-ALPINE324-LIBXML2-22636290
RUN apk update && \
    apk add --no-cache 'libxml2>=2.13.9-r3'

ENV PYTHONUNBUFFERED=1

COPY rootfs /
RUN chmod +x /etc/services.d/sigenergy2mqtt/*

RUN pip install --root-user-action=ignore --break-system-packages --no-cache-dir /dist/sigenergy2mqtt-2026.11.23b2-py3-none-any.whl
