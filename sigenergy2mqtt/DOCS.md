# Home Assistant Add-on: sigenergy2mqtt

You must configure the add-on before starting it.

There are two ways to configure the add-on. You can provide basic configuration through the Configuration tab and/or you can upload a Configuration file.

# Configuration File

You can upload a [configuration file](https://github.com/seud0nym/sigenergy2mqtt/blob/main/sigenergy2mqtt.yaml) to the addon_configs directory on your Home Assistant server for more advanced configuration options. The file _must_ be named `sigenergy2mqtt.yaml`, and placed inside the directory under addon_configs that ends with `sigenergy2mqtt`.

**NOTE:** If you provide _both_ an advanced configuration file _and_ enter options into the Configuration tab, the Configuration tab will **override** any identical settings in the configuration file. If you are using the Mosquitto Broker addon, the MQTT host, port, username and password will _always_ override what is the configuration file. 

When using the configuration file, the default is to _not_ automatically publish the Sigenergy devices and entities in Home Assistant. If you wish that to occur, you must include the following option in your file:

```yaml
home-assistant:
  enabled: true
```

# Configuration Tab

**NOTE:** These settings will **override** any identical settings in the configuration file.

## `sigenergy2mqtt` General Configuration

### Option: `Logging Level` (optional)

Use to set the `sigenergy2mqtt` log level. By default, only WARNING messages are logged.

### Option: `Sensor to Debug` (optional)

Specify a sensor to be debugged using either the full entity id, a partial entity id, the full sensor class name, or a partial sensor class name. For example, specifying 'daily' would match all sensors with daily in their entity name. If specified, 'Logging Level' is also forced to DEBUG.

## Home Assistant Integration Configuration

### Option: `Home Assistant Discovery Prefix` (optional)

Override the Home Assistant MQTT Discovery topic prefix to use. Only change this if you have already changed it in the MQTT settings in Home Assistant. The default is 'homeassistant'.

### Option: `Home Assistant Entity ID Prefix` (optional)

The prefix to use for Home Assistant entity IDs. e.g. A prefix of 'prefix' will prepend 'prefix_' to entity IDs. If you don't specify a prefix, the entity ID will be prefixed with 'sigen'.  

### Option: `Home Assistant Unique ID Prefix` (optional)

The prefix to use for Home Assistant unique IDs. e.g. A prefix of 'prefix' will prepend 'prefix_' to unique IDs. Once you have set this, you should NEVER change it, as it will break existing entities in Home Assistant. If you don't specify a prefix, the entity ID will be prefixed with 'sigen'.

### Option: `Home Assistant Device Name Prefix` (optional)

The prefix to use for Home Assistant entity names. e.g. A prefix of 'prefix' will prepend 'prefix ' to entity names. The default is no prefix.

## MQTT Broker Configuration

If you are using the [Mosquitto Broker](https://github.com/home-assistant/addons/tree/master/mosquitto) Home Assistant Add-on, you can skip the MQTT configuration options. `sigenergy2mqtt` will retrieve them automatically.

Otherwise, you _must_ enter the IP address or host name of the **MQTT Broker**, the **MQTT Port** (if it is not listening on the default port 1883), and if the broker requires authentication, the **MQTT User Name** and **MQTT Password**.

### Option: `MQTT Broker` (optional)

The hostname or IP address of your MQTT broker.

### Option: `MQTT Port` (optional)

The listening port of the MQTT broker.

### Option: `MQTT User Name` (optional)

A valid user name for the MQTT broker.

### Option: `MQTT Password` (optional)

A valid password for the MQTT broker username.

### Option: `MQTT Logging Level` (optional)

Set the paho.mqtt logging level.

## Sigenergy Modbus Interface Configuration

You must enter the IP address or host name of your **Sigenergy Modbus Host**. If it is not listening on the default port 502, your must also enter the **Sigenergy Modbus Port**

### Option: `Sigenergy Modbus Host`

The hostname or IP address of the Sigenergy device. This is _mandatory_.

### Option: `Sigenergy Modbus Port` (optional)

The Sigenergy device Modbus port number.

### Option: `Sigenergy Inverter Device ID`

The Sigenergy Inverter Modbus Device ID (Slave ID). This is _mandatory_, but defaults to **1** if not specified.

### Option: `Sigenergy AC-Charger Device ID` (optional)

The Sigenergy AC Charger Modbus Device ID (Slave ID).

### Option: `Sigenergy DC-Charger Device ID` (optional)

The Sigenergy DC Charger Modbus Device ID (Slave ID).

### Option: `Scan Interval (Near Realtime Frequency)` (optional)

The scan interval in seconds for Modbus registers that are to be scanned in near-real time. Default is 5 (seconds), and the minimum value is 1.

### Option: `Scan Interval (High Frequency)` (optional)

The scan interval in seconds for Modbus registers that are to be scanned at a high frequency. Default is 10 (seconds), and the minimum value is 5.

### Option: `Scan Interval (Medium Frequency)` (optional)

The scan interval in seconds for Modbus registers that are to be scanned at a medium frequency. Default is 60 (seconds), and the minimum value is 30.

### Option: `Scan Interval (Low Frequency)` (optional)

The scan interval in seconds for Modbus registers that are to be scanned at a low frequency. Default is 600 (seconds), and the minimum value is 300.

### Option: `Sanity Check Default kW` (optional)

The default value in kW used for sanity checks to validate the maximum and minimum values for actual value of power sensors and the delta value of energy sensors. The default value is 100 kW per second, meaning readings outside the range ±100 are ignored.

### Option: `Modbus Logging Level` (optional)

Set the pymodbus logging level.

## Third-Party PV Production Configuration

### Option: `Smart-Port Enabled` (optional)

Enable interrogation of a third-party device for production data.

### Option: `Smart-Port Module Name` (optional)

The name of the module which will be used to obtain third-party device production data.

### Option: `Smart-Port Host` (optional)

The IP address or hostname of the third-party device.

### Option: `Smart-Port User Name` (optional)

The user name to authenticate to the third-party device.

### Option: `Smart-Port Password` (optional)

The password to authenticate to the third-party device.

### Option: `Smart-Port PV power` (optional)

The sensor class to hold the production data obtained from the third-party device.

### Option: `Smart-Port MQTT topic` (optional)

The MQTT topic to which to subscribe to obtain the production data for the third-party device.

### Option: `Smart-Port MQTT gain` (optional)

The gain to be applied to the production data for the third-party device obtained from the MQTT topic. (e.g. 1000 if the data is in kW) Default is 1 (Watts).

## PVOutput Configuration

### Option: `PVOutput Enabled` (optional)

Enable status updates to PVOutput.

### Option: `PVOutput API Key`

Your API Key for PVOutput.

### Option: `PVOutput System ID`

Your PVOutput System ID.

### Option: `PVOutput Consumption` (optional)

Enable sending consumption status to PVOutput.

### Option: `PVOutput Interval` (optional)

The interval in minutes to send data to PVOutput.

### Option: `PVOutput Logging Level` (optional)

Set the PVOutput logging level.


