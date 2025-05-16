# seud0nym's Home Assistant Add-on Repository


## Add-on Repository Installation

### Automatic

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fseud0nym%2Fhome-assistant-addons)

### Manual

Follow these steps to get the add-on repository installed on your system:

1. Navigate in your Home Assistant frontend to **Settings** -> **Add-ons** -> **Add-on store**.
1. Click the three vertical dots in the top-right corner and select **Repositories**.
1. Enter https://github.com/seud0nym/home-assistant-addons and click the **ADD** button.
1. Close the Repositories window.


## Add-ons in this Repository

### [sigenergy2mqtt](./sigenergy2mqtt)

![Supports aarch64 Architecture](https://img.shields.io/badge/aarch64-yes-green.svg)
![Supports amd64 Architecture](https://img.shields.io/badge/amd64-yes-green.svg)
![Supports armhf Architecture](https://img.shields.io/badge/armhf-yes-green.svg)
![Supports armv7 Architecture](https://img.shields.io/badge/armv7-yes-green.svg)

`sigenergy2mqtt` allows you to publish Modbus data from your Sigenergy energy management system to an MQTT Broker (such as the [Mosquitto](https://github.com/home-assistant/addons/tree/master/mosquitto) Home Assistant Add-on). The Sigenergy devices will be auto-discovered by Home Assistant. In addition, it supports optionally uploading production (and consumption if desired) to [PVOutput](https://pvoutput.org/).
