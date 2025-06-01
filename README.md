# seud0nym's Home Assistant Add-on Repository


## Add-on Repository Installation

### Automatic

[![Open your Home Assistant instance and show the add add-on repository dialogue with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fseud0nym%2Fhome-assistant-addons)

### Manual

Follow these steps to get the add-on repository installed on your system:

1. Navigate in your Home Assistant frontend to **Settings** -> **Add-ons** -> **Add-on store**.
1. Click the three vertical dots in the top-right corner and select **Repositories**.
1. Enter https://github.com/seud0nym/home-assistant-addons and click the **ADD** button.
1. Close the Repositories window and refresh.


## Add-ons in this Repository

### [sigenergy2mqtt](./sigenergy2mqtt)

[![License](https://img.shields.io/github/license/seud0nym/sigenergy2mqtt.svg?style=flat)](https://github.com/seud0nym/sigenergy2mqtt/blob/master/LICENSE) 
![Dynamic YAML Badge](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fseud0nym%2Fhome-assistant-addons%2Frefs%2Fheads%2Fmain%2Fsigenergy2mqtt%2Fconfig.yaml&query=%24.version&prefix=v&label=add-on)
[![PyPI - Version](https://img.shields.io/pypi/v/sigenergy2mqtt)](https://pypi.org/project/sigenergy2mqtt/)
![Supports aarch64 Architecture](https://img.shields.io/badge/aarch64-yes-green.svg)
![Supports amd64 Architecture](https://img.shields.io/badge/amd64-yes-green.svg)
![Maintenance](https://img.shields.io/maintenance/yes/2025)

`sigenergy2mqtt` allows you to publish Modbus data from your Sigenergy energy management system to an MQTT Broker (such as the [Mosquitto](https://github.com/home-assistant/addons/tree/master/mosquitto) Home Assistant Add-on). The Sigenergy devices will be auto-discovered by Home Assistant. In addition, it supports optionally uploading production (and consumption if desired) to [PVOutput](https://pvoutput.org/).
