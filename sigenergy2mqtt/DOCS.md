# Home Assistant Add-on: sigenergy2mqtt

## Pre-Requisites

The `sigenergy2mqtt` add-on requires an MQTT broker to operate. 

You must either have installed the Home Assistant [Mosquitto broker add-on](https://github.com/home-assistant/addons/blob/master/mosquitto/DOCS.md) or have an existing MQTT broker that you have already integrated with Home Assistant.

## Configuration

You must configure the add-on before starting it.

There are two ways to configure the add-on. You can provide basic configuration through the Configuration tab and/or you can upload a Configuration file.

### Configuration File

You can upload a [configuration file](https://github.com/seud0nym/sigenergy2mqtt/blob/main/sigenergy2mqtt.yaml) to the addon_configs directory on your Home Assistant server for more advanced configuration options. The file _must_ be named `sigenergy2mqtt.yaml`, and placed inside the `addon_configs/4cee8162_sigenergy2mqtt` directory.

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
| `Percentage Box Editor` | Optional | Enable to use a numeric entry box to change the value of percentage sensors or leave disabled to use a slider to change the value. |

#### Sigenergy Modbus Interface Configuration

The Sigenergy Modbus Host and the Device IDs for Inverters, AC Chargers, and DC Chargers will be automatically discovered, or you may enter them manually. If your host is not listening on the default port 502, your _must_ enter the **Sigenergy Modbus Port**

| Option | Condition | Description |
|--------|-----------|-------------|
| `Force Modbus Auto-Discovery` | Optional | Enable to force the automatic discovery of Sigenergy Modbus hosts and associated Device IDs. You only need enable this if you have previously auto-discovered hosts/device IDs and your network or devices have changed. Once auto-discovery has been forced, this option will be reset to disabled. However, this may _not_ be reflected in the Configuration User Interface. |
| `Auto-Discovery Ping Timeout` | Optional | The ping timeout, in seconds, to use when performing auto-discovery of Sigenergy devices on the network. The default is **0.5** (seconds). |
| `Auto-Discovery Modbus Timeout` | Optional | The Modbus timeout, in seconds, to use when performing auto-discovery of Sigenergy devices on the network. The default is **0.25** (seconds). |
| `Auto-Discovery Modbus Retries` | Optional | The maximum retry count to use when performing auto-discovery of Sigenergy devices on the network. The default is **0**.
| `Modbus Host` | Optional | The hostname or IP address of the Sigenergy device. If you do not specify the host, auto-discovery will be attempted. If a host is auto-discovered, all associated Device IDs will also be auto-discovered. Auto-discovery results are cached, so you only need to force auto-discovery if anything has changed. |
| `Modbus Port` | Optional | The Sigenergy device Modbus port number. The default is **502** |
| `Inverter Device ID` | Optional | The Sigenergy Inverter Modbus Device ID. This defaults to **1** if not specified, *OR* it will be determined automatically during auto-discovery. |
| `AC-Charger Device ID` | Optional | The Sigenergy AC Charger Modbus Device ID. Auto-discovery will identify AC Charger devices. |
| `DC-Charger Device ID` | Optional | The Sigenergy DC Charger Modbus Device ID. Auto-discovery will identify DC Charger devices. The `DC-Charger Device ID` is normally the same as the `Inverter Device ID`. |
| `Read Only` | Optional | Enable to only read data from the Sigenergy device. Disable to allow writing data to the Sigenergy device. |
| `No Remote EMS` | Optional | Enable to hide all read/write sensors used for remote Energy Management System (EMS) integration. This may be applicable if, for example, you are part of a VPP which manages the battery. Ignored if 'Modbus Read Only' is enabled. |
| `Consumption Method` | Optional | Set the method of calculating the `Plant Consumed Power` sensor. Valid values are: `Calculated`, `Total Load` (use `Total Load Power` sensor), or `General Load` (use the `General Load Power` sensor). The default is **Calculated**. This option is _ignored_ on firmware earlier than that supporting Modbus Protocol V2.8. |
| `Scan Interval (Near Realtime Frequency)` | Optional | The scan interval in seconds for Modbus registers that are to be scanned in near-real time. Default is **5** (seconds), and the minimum value is 1. |
| `Scan Interval (High Frequency)` | Optional | The scan interval in seconds for Modbus registers that are to be scanned at a high frequency. Default is **10** (seconds), and the minimum value is 1. |
| `Scan Interval (Medium Frequency)` | Optional | The scan interval in seconds for Modbus registers that are to be scanned at a medium frequency. Default is **60** (seconds), and the minimum value is 1. |
| `Scan Interval (Low Frequency)` | Optional | The scan interval in seconds for Modbus registers that are to be scanned at a low frequency. Default is **600** (seconds), and the minimum value is 1. |
| `Sanity Check Default kW` | Optional | The default value in kW used for sanity checks to validate the maximum and minimum values for actual value of power sensors and the delta value of energy sensors. The default value is **500** kW per second, meaning readings outside the range ±100 are ignored. |
| `Modbus Logging Level` | Optional | Set the pymodbus logging level. |

#### PVOutput Configuration

If you enable status updates to PVOutput, you must enter both the ***API Key*** and ***System ID***. If you donate to PVOutput, battery data will be uploaded and you can configure the extended data fields (see below).

<table>
  <thead><tr><th>Option</th><th>Condition</th><th>Description</th></tr></thead>
  <tbody>
    <tr><td><code>PVOutput Enabled</code></td><td>Optional</td><td>Enable status updates to PVOutput.</td></tr>
    <tr><td><code>PVOutput API Key</code></td><td>Optional</td><td>Your API Key for PVOutput. This is <i>mandatory</i> if PVOutput enabled.</td></tr>
    <tr><td><code>PVOutput System ID</code></td><td>Optional</td><td>Your PVOutput System ID. This is <i>mandatory</i> if PVOutput enabled.</td></tr>
    <tr><td><code>PVOutput Consumption</code></td><td>Optional</td><td>Enable sending consumption data to PVOutput.</td></tr>
    <tr><td><code>PVOutput Exports</code></td><td>Optional</td><td>Enable sending export data to PVOutput.</td></tr>
    <tr><td><code>PVOutput Imports</code></td><td>Optional</td><td>Enable sending import data to PVOutput.</td></tr>
    <tr><td><code>PVOutput End-of-Day Upload</code></td><td>Optional</td><td>If enabled, peak generation and the daily totals for exports and imports (if enabled) are sent to PVOutput at end of day <i>only</i>.<br>If disabled, these values are uploaded at the same interval as status updates.<br><br>If uploaded at the same interval as status updates, PVOutput can overwrite the uploaded values during the day. If this occurs, it will be fixed at end of day.</td></tr>
    <tr><td><code>PVOutput Temperature Topic</code></td><td>Optional</td><td>The MQTT topic to which to subscribe to obtain the current temperature data for PVOutput. If specified, the temperature will be sent to PVOutput. See note below.</td></tr>
    <tr><td><code>PVOutput Voltage Upload</code></td><td>Optional</td><td>The source of the voltage value to be sent to PVOutput. Use 'Phase A' for single-phase systems, 'Phase B', 'Phase C' or 'Line to Line Average' for three-phase or 'Line to Neutral Average' or 'PV Average' for either. The default is 'Line to Neutral Average'.</td></tr>
    <tr><td><code>PVOutput Extended Data v7</code></td><td>Optional</td><td rowspan=6>A sensor class name, or entity_id without the 'sensor.' prefix, that will be used to populate the associated extended data field in PVOutput. If not specified, OR your donation status is not current, the field will not be sent to PVOutput. You can use any sensor with a numeric value.<br><br> See note below.</td></tr>
    <tr><td><code>PVOutput Extended Data v8</code></td><td>Optional</td></tr>
    <tr><td><code>PVOutput Extended Data v9</code></td><td>Optional</td></tr>
    <tr><td><code>PVOutput Extended Data v10</code></td><td>Optional</td></tr>
    <tr><td><code>PVOutput Extended Data v11</code></td><td>Optional</td></tr>
    <tr><td><code>PVOutput Extended Data v12</code></td><td>Optional</td></tr>
    <tr><td><code>PVOutput Logging Level</code></td><td>Optional</td><td>Set the PVOutput logging level.</td></tr>
  </tbody>
</table>

##### PVOutput Battery Data

If your donation status is current, the Battery Power, SoC, Usable Capacity, and Lifetime Charge/Discharge will be automatically uploaded with each status update.

##### PVOutput Tariff Time Periods

You can define time periods so that `sigenergy2mqtt` can upload exports and imports into their correct tariff time slot (peak, off-peak, shoulder and high-shoulder).

Unfortunately, the relative complexity of the data makes it unsuitable for defining through the Home Assistant Add-on Configuration screen. Therefore, you must define these time periods in the configuration file.

Create (or update) your configuration file, which must be called `sigenergy2mqtt.yaml` and must be located in the `addon_configs/4cee8162_sigenergy2mqtt` directory. The following is a basic example of the file contents:

```yaml
home-assistant:
  enabled: true
pvoutput:
  enabled: true
  time-periods:
  - plan: Zero Hero
    to-date: 2026-05-31
    periods:
      - type: off-peak
        start: 11:00
        end: 14:00
      - type: peak
        start: 15:00
        end: 21:00
  - plan: Four Free
    from-date: 2026-06-01
    default: peak
    periods:
      - type: off-peak
        start: 10:00
        end: 14:00
```

The first four lines are **mandatory**. If not included in your configuration file, _neither_ Home Assistant nor PVOutput will be updated.

This example configuration file defines two time periods:
  - The first will be active until 2026-05-31, and defines off-peak and peak time ranges. At all other times, shoulder will be applied.
  - The second takes effect from 2026.06.01, and defines only the off-peak period. At all other times, the overridden default of peak will be applied.

The `time-periods` element contains an array of time periods that describe the peak, shoulder, high-shoulder and off-peak periods for a specific date range. THE TIME PERIODS SPECIFIED MUST MATCH THE TIME PERIODS CONFIGURED IN YOUR PVOUTPUT TARIFF DEFINITIONS. Multiple date ranges may be specified, and each can have the following attributes:

- plan:      
  - An optional name for the time period. Duplicates are permitted.
- from-date: 
  - The start date for the time period in YYYY-MM-DD format. If not specified, the time period is effective immediately.
  - **NOTE**: When initially configuring time-periods, it is _strongly_ recommended that you configure the from-date as _tomorrows date_, so that there is no mismatch between the total exports and the sum of the off-peak/peak/shoulder/high-shoulder export figures today.
- to-date:
  - The end date for the time period in YYYY-MM-DD format. If not specified, the time period is effective indefinitely.
- default:
  - One of off-peak, peak, shoulder, or high-shoulder that will be used for all other times not specifically defined in the `periods` array (below). If not specified, the default is `shoulder`.
- periods: 
  - An array of time period definitions. At least one must be specified. Each period has the following attributes:
    - type:  
      - One of off-peak, peak, shoulder, or high-shoulder.
    - start: 
      - The period start time in H:MM format.
    - end:
      - The period end time in H:MM format. 24:00 may be specified for the end of the day.
    - days:
      - The optional array of days to which the period applies. The default is `[All]`. Valid values are:
          - Mon
          - Tue
          - Wed
          - Thu
          - Fri
          - Sat
          - Sun
          - Weekdays
          - Weekends
          - All
                                   
If plans or time periods overlap, the first match will be used.

##### PVOutput Temperature

You can publish temperature to PVOutput. As an add-on, `sigenergy2mqtt` does not have direct access to the Home Assistant sensors. It can only consume temperature that has been published to MQTT.

If your Home Assistant weather integration does not publish the temperature to MQTT, you can create an automation that will publish the temperature whenever it changes. This is an example (you will need to modify the `entity_id` to match your location):

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

The sensor class names that you can use for these fields can be found in the Attributes of the sensor you wish to send to PVOutput. You can use any sensor that shows a numeric value. 

If a sensor class is used for multiple sensors (e.g. the `PhaseVoltage` sensor class is used for phases A, B and C), the sensor values will be averaged and a single value sent to PVOutput.
If you specify an Energy sensor class, the value sent to PVOutput will be the <i>power</i> value over the Status Interval.

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

