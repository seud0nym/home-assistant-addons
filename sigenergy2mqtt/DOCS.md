# Home Assistant Add-on: sigenergy2mqtt

## Pre-Requisites

The `sigenergy2mqtt` add-on requires an MQTT broker to operate. 

You must either have installed the Home Assistant [Mosquitto broker add-on](https://github.com/home-assistant/addons/blob/master/mosquitto/DOCS.md) or have an existing MQTT broker that you have already integrated with Home Assistant.

## Configuration

You must configure the add-on before starting it.

There are two ways to configure the add-on. You can provide basic configuration through the Configuration tab and/or you can upload a Configuration file.

### Configuration File

You can upload a [configuration file](https://github.com/seud0nym/sigenergy2mqtt/blob/main/sigenergy2mqtt.yaml) to the addon_configs directory on your Home Assistant server for more advanced configuration options. The file _must_ be named `sigenergy2mqtt.yaml`, and placed inside the directory under addon_configs that ends with `sigenergy2mqtt`.

**NOTE:** If you provide _both_ an advanced configuration file _and_ enter options into the Configuration tab, the Configuration tab will **override** any identical settings in the configuration file. If you are using the Mosquitto Broker addon, the MQTT host, port, username and password will _always_ override what is the configuration file. 

When using the configuration file, the default is to _not_ automatically publish the Sigenergy devices and entities in Home Assistant. If you wish that to occur, you must include the following option in your file:

```yaml
home-assistant:
  enabled: true
```

### Configuration Tab

**NOTE:** These settings will **override** any identical settings in the configuration file.

#### `sigenergy2mqtt` General Configuration

| Option | Condition | Description |
|--------|-----------|-------------|
| `sigenergy2mqtt Logging Level` | Optional | Use to set the `sigenergy2mqtt` log level. By default, only WARNING messages are logged. |
| `Enable sigenergy2mqtt Metrics` | Optional | Enable the publication of sigenergy2mqtt metrics to Home Assistant. |
| `Sensor to Debug` | Optional | Specify a sensor to be debugged using either the full entity id, a partial entity id, the full sensor class name, or a partial sensor class name. For example, specifying 'daily' would match all sensors with daily in their entity name. If specified, 'Logging Level' is also forced to DEBUG. |

#### Sigenergy Modbus Interface Configuration

The Sigenergy Modbus Host and the Device IDs for Inverters, AC Chargers, and DC Chargers will be automatically discovered, or you may enter them manually. If your host is not listening on the default port 502, your _must_ enter the **Sigenergy Modbus Port**

| Option | Condition | Description |
|--------|-----------|-------------|
| `Force Modbus Auto Discovery` | Optional | Enable to force the automatic discovery of Sigenergy Modbus hosts and associated Device IDs. You only need enable this if you have previously auto-discovered hosts/device IDs and your network or devices have changed. Once auto-discovery has been forced, this option will be reset to disabled. However, this may not be reflected in the Configuration User Interface. |
| `Sigenergy Modbus Host` | Optional | The hostname or IP address of the Sigenergy device. If you do not specify the host, auto-discovery will be attempted. If a host is auto-discovered, all associated Device IDs will also be auto-discovered. Auto-discovery results are cached, so you only need to force auto-discovery if anything has changed. |
| `Sigenergy Modbus Port` | Optional | The Sigenergy device Modbus port number. The default is **502** |
| `Sigenergy Inverter Device ID` | Optional | The Sigenergy Inverter Modbus Device ID. This defaults to **1** if not specified, *OR* it will be determined automatically during auto-discovery. |
| `Sigenergy AC-Charger Device ID` | Optional | The Sigenergy AC Charger Modbus Device ID. Auto-discovery will identify AC Charger devices. |
| `Sigenergy DC-Charger Device ID` | Optional | The Sigenergy DC Charger Modbus Device ID. Auto-discovery will identify DC Charger devices. |
| `Scan Interval (Near Realtime Frequency)` | Optional | The scan interval in seconds for Modbus registers that are to be scanned in near-real time. Default is 5 (seconds), and the minimum value is 1. |
| `Scan Interval (High Frequency)` | Optional | The scan interval in seconds for Modbus registers that are to be scanned at a high frequency. Default is 10 (seconds), and the minimum value is 5. |
| `Scan Interval (Medium Frequency)` | Optional | The scan interval in seconds for Modbus registers that are to be scanned at a medium frequency. Default is 60 (seconds), and the minimum value is 30. |
| `Scan Interval (Low Frequency)` | Optional | The scan interval in seconds for Modbus registers that are to be scanned at a low frequency. Default is 600 (seconds), and the minimum value is 300. |
| `Sanity Check Default kW` | Optional | The default value in kW used for sanity checks to validate the maximum and minimum values for actual value of power sensors and the delta value of energy sensors. The default value is 100 kW per second, meaning readings outside the range ±100 are ignored. |
| `Modbus Logging Level` | Optional | Set the pymodbus logging level. |

#### PVOutput Configuration

If you enable status updates to PVOutput, you must enter both the ***API Key*** and ***System ID***. If you donate to PVOutput, you can configure the extended data fields (see below).

| Option | Condition | Description |
|--------|-----------|-------------|
| `PVOutput Enabled` | Optional | Enable status updates to PVOutput. |
| `PVOutput API Key` | Optional | Your API Key for PVOutput. This is _mandatory_ if PVOutput enabled. |
| `PVOutput System ID` | Optional | Your PVOutput System ID. This is _mandatory_ if PVOutput enabled. |
| `PVOutput Consumption` | Optional | Enable sending consumption data to PVOutput. See note below. |
| `PVOutput Exports` | Optional | Enable sending export data to PVOutput. See note below. |
| `PVOutput Imports` | Optional | Enable sending import data to PVOutput. See note below. |
| `PVOutput End-of-Day Upload` | Optional | If enabled, peak generation and the daily totals for exports and imports (if enabled) are sent to PVOutput at end of day. If disabled, these values are uploaded on the same schedule as status updates. |
| `PVOutput Temperature Topic` | Optional | The MQTT topic to which to subscribe to obtain the current temperature data for PVOutput. If specified, the temperature will be sent to PVOutput. |
| `PVOutput Extended Data v7` | Optional | A sensor class name that will be used to populate the v7 extended data field in PVOutput. |
| `PVOutput Extended Data v8` | Optional | A sensor class name that will be used to populate the v8 extended data field in PVOutput. |
| `PVOutput Extended Data v9` | Optional | A sensor class name that will be used to populate the v9 extended data field in PVOutput. |
| `PVOutput Extended Data v10` | Optional | A sensor class name that will be used to populate the v10 extended data field in PVOutput. |
| `PVOutput Extended Data v11` | Optional | A sensor class name that will be used to populate the v11 extended data field in PVOutput. |
| `PVOutput Extended Data v12` | Optional | A sensor class name that will be used to populate the v12 extended data field in PVOutput. |
| `PVOutput Logging Level` | Optional | Set the PVOutput logging level. |

##### PVOutput Consumption, Exports and Imports

When you enable recording of consumption in PVOutput, PVOutput automatically calculates exports and imports. The calculated values, however, will probably be incorrect because they do not take into consideration battery charge/discharger. 

`sigenergy2mqtt` can upload your actual exports and imports at the end of the day (along with the peak power reading), if it is enabled in your configuration. This is the default. 

If consumption and either or both of exports/imports are enabled, PVOutput may automatically calculate exports and imports and the uploaded values may be ignored.

##### PVOutput Temperature

You can publish temperature changes from Home Assistant using the the default weather integration, or whatever integration you use. This is an example of an automation that will publish the temperature whenever it changes (you will need to modify the `entity_id` to match your location):

```yaml
alias: Publish Current Temperature
description: ""
triggers:
  - trigger: state
    entity_id:
      - weather.forecast_prahran
    attribute: temperature
conditions: []
actions:
  - action: mqtt.publish
    data:
      qos: "1"
      retain: true
      topic: homeassistant/weather/temperature
      payload: "{{ state_attr(\"weather.forecast_prahran\", \"temperature\") }}"
mode: single
```

Once you have this automation running, you can add it to your PVOutput status uploads by specifying the MQTT topic `homeassistant/weather/temperature` in the `PVOutput Temperature Topic` configuration field.

##### PVOutput Extended Data Fields

Extended data fields are only sent to PVOutput if your donation status is current. 

The sensor class names that you can use for these fields can be found in the Attributes of the sensor you wish to send to PVOutput. You can use any sensor that shows a numeric value. If a sensor class is used for multiple sensors (e.g. the `PhaseVoltage` sensor class is used for phases A, B and C), the sensor values will be averaged and a single value sent to PVOutput.

#### MQTT Broker Configuration

If you are using the [Mosquitto Broker](https://github.com/home-assistant/addons/tree/master/mosquitto) Home Assistant Add-on, you can skip the MQTT configuration options. `sigenergy2mqtt` will retrieve them automatically.

Otherwise, you _must_ enter the IP address or host name of the **MQTT Broker**, the **MQTT Port** (if it is not listening on the default port 1883), and if the broker requires authentication, the **MQTT User Name** and **MQTT Password**.

| Option | Condition | Description |
|--------|-----------|-------------|
| `MQTT Broker` | Optional | The hostname or IP address of your MQTT broker. |
| `MQTT Port` | Optional | The listening port of the MQTT broker. The default is 1883, unless MQTT TLS Communication is enabled, in which case the default is 8883. |
| `MQTT TLS Communication Enabled` | Enable secure communication to MQTT broker over TLS/SSL (if the broker supports it). |
| `MQTT User Name` | Optional | A valid user name for the MQTT broker. |
| `MQTT Password` | Optional | A valid password for the MQTT broker username. |
| `MQTT Logging Level` | Optional | Set the paho.mqtt logging level. |

#### Home Assistant Integration Configuration

These optional settings should only changed if you have very specific requirements.

| Option | Condition | Description |
|--------|-----------|-------------|
| `Home Assistant Discovery Prefix` | Optional | Override the Home Assistant MQTT Discovery topic prefix to use. Only change this if you have already changed it in the MQTT settings in Home Assistant. The default is 'homeassistant'. |
| `Home Assistant Entity ID Prefix` | Optional | The prefix to use for Home Assistant entity IDs. e.g. A prefix of 'prefix' will prepend 'prefix_' to entity IDs. If you don't specify a prefix, the entity ID will be prefixed with 'sigen'.  |
| `Home Assistant Unique ID Prefix` | Optional | The prefix to use for Home Assistant unique IDs. e.g. A prefix of 'prefix' will prepend 'prefix_' to unique IDs. Once you have set this, you should NEVER change it, as it will break existing entities in Home Assistant. If you don't specify a prefix, the entity ID will be prefixed with 'sigen'. |
| `Home Assistant Device Name Prefix` | Optional | The prefix to use for Home Assistant entity names. e.g. A prefix of 'prefix' will prepend 'prefix ' to entity names. The default is no prefix. |

#### Third-Party PV Production Configuration

Third-party PV is an optional configuration if you wish faster updates than the Sigenergy Modbus Third-party PC sensors provide.

At this time, only Enphase Envoy with firmware versions prefixed with D7 and D8 can be directly integrated. Other third-party PV systems may be integrated if their data can be derived via MQTT.

| Option | Condition | Description |
|--------|-----------|-------------|
| `Smart-Port Enabled` | Optional | Enable interrogation of a third-party device for production data. |
| `Smart-Port Module Name` | Optional | The name of the module which will be used to obtain third-party device production data. |
| `Smart-Port Host` | Optional | The IP address or hostname of the third-party device. |
| `Smart-Port User Name` | Optional | The user name to authenticate to the third-party device. |
| `Smart-Port Password` | Optional | The password to authenticate to the third-party device. |
| `Smart-Port PV power` | Optional | The sensor class to hold the production data obtained from the third-party device. |
| `Smart-Port MQTT topic` | Optional | The MQTT topic to which to subscribe to obtain the production data for the third-party device. |
| `Smart-Port MQTT gain` | Optional | The gain to be applied to the production data for the third-party device obtained from the MQTT topic. (e.g. 1000 if the data is in kW) Default is 1 (Watts). |

