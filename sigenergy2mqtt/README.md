# Home Assistant Add-on: sigenergy2mqtt

[![License](https://img.shields.io/github/license/seud0nym/sigenergy2mqtt.svg?style=flat)](https://github.com/seud0nym/sigenergy2mqtt/blob/master/LICENSE) 
![PyPI - Version](https://img.shields.io/pypi/v/sigenergy2mqtt)
![Dynamic YAML Badge](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fseud0nym%2Fhome-assistant-addons%2Frefs%2Fheads%2Fmain%2Fsigenergy2mqtt%2Fconfig.yaml&query=%24.version&prefix=v&label=add-on)
![Supports aarch64 Architecture](https://img.shields.io/badge/aarch64-yes-green.svg)
![Supports amd64 Architecture](https://img.shields.io/badge/amd64-yes-green.svg)
![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/seud0nym/sigenergy2mqtt?link=https%3A%2F%2Fgithub.com%2Fseud0nym%2Fsigenergy2mqtt%2Fissues)
![Maintenance](https://img.shields.io/maintenance/yes/2025)

[sigenergy2mqtt](https://github.com/seud0nym/sigenergy2mqtt) is a bridge between the Modbus interface of the Sigenergy energy system and the MQTT lightweight publish/subscribe messaging protocol.

## Optional features: 

### PVOutput

You can automatically upload your production (and optionally, consumption) data to [PVOutput](https://pvoutput.org/). All you need to do is enable it in the configuration, and enter your API Key and System ID. Uploads occur at the interval defined in Status Interval setting under Live Settings in the PVOutput system settings.

### Third-Party Solar Production

Prior to the V100R001C00SPC108 firmware update, production systems connected to the Sigenergy Gateway Smart-Port were included in the Plant PV Power reported by the Modbus interface. In firmware V100R001C00SPC108, the PV Power register only reports production from panels connected directly to Sigenergy. Firmware V100R001C00SPC109 adds a new sensor for Third-Party PV Power. This register, however, only appears to be updated every 8-10 seconds in my testing with my Enphase micro-inverters, so if you want more frequent updates of Total PV Power and Consumed Power, then you should enable smart-port in the configuration and configure either the Enphase Envoy and/or the MQTT smart-port integrations.

`sigenergy2mqtt` can incorporate third-party PV production via internal Python modules (at this stage, only Enphase micro-inverters are supported), or by subscribing to an MQTT topic that provides the data.

## Issues

If you a have a problem with this add-on, please raise an issue [here](https://github.com/seud0nym/sigenergy2mqtt/issues).