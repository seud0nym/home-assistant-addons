# https://developers.home-assistant.io/docs/apps/configuration#app-dockerfile
# Supported images can be found at https://github.com/home-assistant/docker-base/pkgs/container/base-python#python-images
FROM ghcr.io/home-assistant/base-python:3.14-alpine3.24

# Update all available packages to mitigate vulnerabilities
RUN apk upgrade --update --no-cache --available

ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Clone the sigenergy2mqtt repository (which contains the Modbus simulator)
RUN apk add --no-cache bash git && git clone --depth=1 https://github.com/seud0nym/sigenergy2mqtt.git /app && apk del git
   
# Install the dependencies
RUN /app/scripts/dependencies --install-only --skip-build-deps

# Displayed by the simulator at start-up
RUN echo "$(date +"%Y-%m-%dT%H:%M:%S%z")" > /app/build_date.txt

COPY rootfs /
RUN chmod +x /etc/services.d/sigenergy-modbus-simulator/*

EXPOSE 502