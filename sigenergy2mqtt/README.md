# Home Assistant App: sigenergy2mqtt

[![License](https://img.shields.io/github/license/seud0nym/sigenergy2mqtt.svg?style=flat)](https://github.com/seud0nym/sigenergy2mqtt/blob/master/LICENSE) 
![Dynamic YAML Badge](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fseud0nym%2Fhome-assistant-addons%2Frefs%2Fheads%2Fmain%2Fsigenergy2mqtt%2Fconfig.yaml&query=%24.version&label=stable)
![Dynamic YAML Badge](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fseud0nym%2Fhome-assistant-addons%2Frefs%2Fheads%2Fbeta%2Fsigenergy2mqtt%2Fconfig.yaml&query=%24.version&label=beta&color=orange)
![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/seud0nym/sigenergy2mqtt?link=https%3A%2F%2Fgithub.com%2Fseud0nym%2Fsigenergy2mqtt%2Fissues)
![Maintenance](https://img.shields.io/maintenance/yes/2026)  

[sigenergy2mqtt](https://github.com/seud0nym/sigenergy2mqtt) is a bridge between the Modbus interface of the Sigenergy energy system and the MQTT lightweight publish/subscribe messaging protocol.

## Features

* Auto-discovery of Sigenergy hosts and device IDs for inverters and chargers (or you can manually specify them)
* Automatic detection of Home Assistant language, and translations into German, Spanish, French, Italian, Japanese, Korean, Dutch, Portuguese and Simplified Chinese
* [_Optional_] You can automatically upload your generation, battery (for donators only) and optionally, consumption, exports and imports, data to [PVOutput](https://pvoutput.org/).
* [_Optional_] You can automatically publish _all_ sensor data to InfluxDB (v1/2). This is different to the Home Assistant integration with InfluxDB, which only publishes enabled sensors, and does not publish repeating data. You can also import historical `sigenergy2mqtt` sensor data from an existing InfluxDB 'homeassistant' database.

## Minimum Requirements

- A Sigenergy ESS or PV Inverter, with the Modbus-TCP server enabled by your installer
- The Home Assistant [Mosquitto broker app](https://github.com/home-assistant/addons/blob/master/mosquitto/DOCS.md) or an existing MQTT broker that you have already integrated with Home Assistant.

## MQTT Devices

For each Sigenergy host, an MQTT device will be created in Home Assistant. A host can be configured in the app Configuration tab, or it can be discovered automatically.

The first host will be called `Sigenergy Plant` (plant is the terminology used in the "Sigenergy Modbus Protocol", and is in the context of a power plant). Each plant will have one or more related MQTT devices, such as `Sigenergy Plant Grid Sensor` and `Sigenergy Plant Statistics`. Plants will also have associated inverters, and their names will include the model and serial number (e.g. `SigenStor EC 6.0 SP CMUxxxxxxxxxx`). Each inverter will have an an Energy Storage System device (e.g. `SigenStor CMUxxxxxxxxxx ESS`) and as many PV String devices as the inverter supports. Chargers will be named `Sigenergy AC Charger` and `Sigenergy DC Charger`.

Example:
```
Sigenergy Plant
   ├─ Sigenergy Plant Grid Code
   ├─ Sigenergy Plant Grid Sensor
   ├─ Sigenergy Plant Smart-Port
   ├─ Sigenergy Plant Statistics
   ├─ Sigenergy AC Charger
   ├─ SigenStor CMUxxxxxxxxxx Energy Controller (ID 1)
   │    ├─ SigenStor CMUxxxxxxxxxx ESS
   │    ├─ SigenStor CMUxxxxxxxxxx PV String 1
   │    ├─ SigenStor CMUxxxxxxxxxx PV String 2
   │    ├─ SigenStor CMUxxxxxxxxxx PV String 3
   │    ├─ SigenStor CMUxxxxxxxxxx PV String 4
   │    └─ Sigenergy DC Charger
   └─ SigenStor CMUyyyyyyyyyy Energy Controller (ID 2)
        ├─ SigenStor CMUyyyyyyyyyy ESS
        ├─ SigenStor CMUyyyyyyyyyy PV String 1
        ├─ SigenStor CMUyyyyyyyyyy PV String 2
        └─ Sigenergy DC Charger
```

