# Home Assistant App: sigenergy2mqtt

[![License](https://img.shields.io/github/license/seud0nym/sigenergy2mqtt.svg?style=flat)](https://github.com/seud0nym/sigenergy2mqtt/blob/master/LICENSE) 
![Dynamic YAML Badge](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fseud0nym%2Fhome-assistant-addons%2Frefs%2Fheads%2Fmain%2Fsigenergy2mqtt%2Fconfig.yaml&query=%24.version&label=stable)
![Dynamic YAML Badge](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fseud0nym%2Fhome-assistant-addons%2Frefs%2Fheads%2Fbeta%2Fsigenergy2mqtt%2Fconfig.yaml&query=%24.version&label=beta&color=orange)
![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fghcr-badge.elias.eu.org%2Fapi%2Fseud0nym%2Fhome-assistant-addons%2Fhome-assistant-addon-sigenergy2mqtt-amd64&query=downloadCount&label=amd64%20downloads&color=green&link=https%3A%2F%2Fgithub.com%2Fseud0nym%2Fhome-assistant-addons%2Fpkgs%2Fcontainer%2Fhome-assistant-addon-sigenergy2mqtt-amd64)
![Dynamic JSON Badge](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fghcr-badge.elias.eu.org%2Fapi%2Fseud0nym%2Fhome-assistant-addons%2Fhome-assistant-addon-sigenergy2mqtt-aarch64&query=downloadCount&label=aarch64%20downloads&color=green&link=https%3A%2F%2Fgithub.com%2Fseud0nym%2Fhome-assistant-addons%2Fpkgs%2Fcontainer%2Fhome-assistant-addon-sigenergy2mqtt-aarch64)
![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/seud0nym/sigenergy2mqtt?link=https%3A%2F%2Fgithub.com%2Fseud0nym%2Fsigenergy2mqtt%2Fissues)
![Maintenance](https://img.shields.io/maintenance/yes/2026)  

[sigenergy2mqtt](https://github.com/seud0nym/sigenergy2mqtt) is a bridge between the Modbus interface of the Sigenergy energy system and the MQTT lightweight publish/subscribe messaging protocol.

## Features: 

* Auto-discovery of Sigenergy hosts and device IDs for inverters and chargers (or you can manually specify them)
* Automatic detection of Home Assistant language, and translations into German, Spanish, French, Italian, Japanese, Korean, Dutch, Portuguese and Simplified Chinese
* [_Optional_] You can automatically upload your generation, battery (for donators only) and optionally, consumption, exports and imports, data to [PVOutput](https://pvoutput.org/).
* [_Optional_] You can automatically publish _all_ sensor data to InfluxDB (v1/2). This is different to the Home Assistant integration with InfluxDB, which only publishes enabled sensors, and does not publish repeating data. You can also import historical `sigenergy2mqtt` sensor data from an existing InfluxDB 'homeassistant' database.
* [_Optional_] `sigenergy2mqtt` can incorporate third-party PV production via internal Python modules (at this stage, only Enphase micro-inverters are supported), or by subscribing to an MQTT topic that provides the data, as an alternative to using the Sigenergy Modbus registers for third-party PV. (_This feature is under consideration for removal in a future release. Have your say in the [discussion](https://github.com/seud0nym/sigenergy2mqtt/discussions/124)._)

## Beta Testing

Beta releases are available for testing new features and bug fixes before they are released as stable versions. Beta version numbers use the format `YYYY.M.DbN` (e.g. `2026.3.15b1`).

### Installing the Beta Repository

1. Ensure you have **Advanced Mode** enabled in your Home Assistant profile (**Settings** → **People** → select your user → **Advanced Mode**).
2. Add the beta repository to Home Assistant:

   [![Open your Home Assistant instance and show the add app repository dialogue with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fseud0nym%2Fhome-assistant-addons%23beta)

   Or manually: **Settings** → **Apps** → **App store** → ⋮ → **Repositories** → add `https://github.com/seud0nym/home-assistant-addons#beta`

3. The beta version of sigenergy2mqtt will appear in the App store.

### Switching Between Beta and Stable

Both the stable and beta versions can be installed simultaneously, but **only one should be running at a time**. To switch:

1. **Stop** the currently running version (stable or beta).
2. **Start** the other version (beta or stable).

> [!WARNING]
> Running both versions simultaneously will cause conflicts (duplicate MQTT topics, Modbus connection issues). The app will detect and prevent this.

## Issues

If you have a problem with this app, please raise an issue [here](https://github.com/seud0nym/sigenergy2mqtt/issues).

