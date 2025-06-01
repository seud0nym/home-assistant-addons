# Home Assistant Add-on: sigenergy2mqtt

[![License](https://img.shields.io/github/license/seud0nym/sigenergy2mqtt.svg?style=flat)](https://github.com/seud0nym/sigenergy2mqtt/blob/master/LICENSE) 
![PyPI - Version](https://img.shields.io/pypi/v/sigenergy2mqtt)
![Dynamic YAML Badge](https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fseud0nym%2Fhome-assistant-addons%2Frefs%2Fheads%2Fmain%2Fsigenergy2mqtt%2Fconfig.yaml&query=%24.version&prefix=v&label=add-on)
![Supports aarch64 Architecture](https://img.shields.io/badge/aarch64-yes-green.svg)
![Supports amd64 Architecture](https://img.shields.io/badge/amd64-yes-green.svg)
![Maintenance](https://img.shields.io/maintenance/yes/2025)

[sigenergy2mqtt](https://github.com/seud0nym/sigenergy2mqtt) is a bridge between the Modbus interface of the Sigenergy energy system and the MQTT lightweight publish/subscribe messaging protocol.

In addition, `sigenergy2mqtt` has several optional features: 

## PVOutput

You can automatically upload your production (and optionally, consumption) data to [PVOutput](https://pvoutput.org/). All you need to do is enable it in the configuration, and enter your API Key and System ID. By default, uploads occur every 5 minutes, but is configurable to 5, 10 or 15 minute intervals (the interval should match the Status Interval setting under Live Settings in the system settings)

## Third-Party Solar Production

Since the V100R001C00SPC108 firmware update, production systems connected to the Sigenergy Gateway Smart-Port are no longer included in the PV Power reported by the Modbus interface. Without this production data, calculation of consumption is problematic, since PV production is a core element in the computation and if third-party production is not counted, it leads to obvious errors like negative consumption. 

Whilst this may change in future firmware releases, at the moment there is no way through the Modbus data to include third-party PV production.

`sigenergy2mqtt` can incorporate third-party PV production via internal Python modules (at this stage, only Enphase micro-inverters are supported), or by subscribing to an MQTT topic that provides the data.

