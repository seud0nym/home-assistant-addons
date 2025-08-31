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

* Auto-discovery of Sigenergy hosts and device IDs for inverters and chargers
* You can automatically upload your production (and optionally, consumption) data to [PVOutput](https://pvoutput.org/).
* `sigenergy2mqtt` can incorporate third-party PV production via internal Python modules (at this stage, only Enphase micro-inverters are supported), or by subscribing to an MQTT topic that provides the data, as an alternative to using the Sigenergy Modbus registers for third-party PV.

## Issues

If you a have a problem with this add-on, please raise an issue [here](https://github.com/seud0nym/sigenergy2mqtt/issues).