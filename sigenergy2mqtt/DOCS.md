# Home Assistant App: sigenergy2mqtt

## Pre-Requisites

### Sigenergy ESS

Your Sigenergy ESS must be configured to act as a Modbus server. This is an installer-only option, so organise with your installer to enable this option.

### MQTT

The `sigenergy2mqtt` app requires an MQTT broker to operate. 

You must either have installed the Home Assistant [Mosquitto broker app](https://github.com/home-assistant/addons/blob/master/mosquitto/DOCS.md) or have an existing MQTT broker that you have already integrated with Home Assistant.

## Configuration

There are two ways to configure the app. You can provide configuration through the Configuration tab and/or you can upload a Configuration file.

### Configuration File

You can upload a [configuration file](https://github.com/seud0nym/sigenergy2mqtt/blob/main/sigenergy2mqtt.yaml) to the addon_configs directory on your Home Assistant server for more advanced configuration options. The file _must_ be named `sigenergy2mqtt.yaml`, and placed inside the `addon_configs/4cee8162_sigenergy2mqtt` directory.

**NOTE:** If you provide _both_ an advanced configuration file _and_ enter options into the Configuration tab, the Configuration tab will **override** any identical settings in the configuration file. If you are using the Mosquitto Broker app, the MQTT host, port, username and password will _always_ override what is the configuration file. 

When using the configuration file, the default is to _not_ automatically publish the Sigenergy devices and entities in Home Assistant. If you wish that to occur, you must include the following option in your file:

```yaml
home-assistant:
  enabled: true
```

### Configuration Tab

**NOTE:** These settings will **override** any identical settings in the configuration file.

#### Sigenergy Device Auto-Discovery

| Option | Description |
|--------|-------------|
| `Force Auto-Discovery` | Enable to force the automatic discovery of Sigenergy Modbus hosts and associated Device IDs. You only need enable this if you have previously auto-discovered hosts/device IDs and your network or devices have changed. Once auto-discovery has been forced, this option will be reset to disabled. However, this may _not_ be reflected in the Configuration User Interface until you refresh the screen. |
| `Ping Timeout` | The ping timeout, in seconds, to use when performing auto-discovery of Sigenergy devices on the network. The default is **0.5** (seconds). |
| `Modbus Timeout` | The Modbus timeout, in seconds, to use when performing auto-discovery of Sigenergy devices on the network. The default is **0.25** (seconds). |
| `Maximum Retries` | The maximum retry count to use when performing auto-discovery of Sigenergy devices on the network. The default is **0**.

#### Manual Sigenergy Device Configuration

The Sigenergy Modbus Host and the Device IDs for Inverters, AC Chargers, and DC Chargers will be automatically discovered, or you may enter them manually. If your host is not listening on the default port 502, you _must_ enter the **Modbus Port**

| Option | Description |
|--------|-------------|
| `Host Address` | The hostname or IP address of the Sigenergy device. If you do not specify the host, auto-discovery will be attempted. If a host is auto-discovered, all associated Device IDs will also be auto-discovered. Auto-discovery results are cached, so you only need to force auto-discovery if anything has changed. |
| `Modbus Port` | The Sigenergy device Modbus port number. The default is **502** |
| `Inverter Device ID` | The Sigenergy Inverter Modbus Device ID. This defaults to **1** if not specified, *OR* it will be determined automatically during auto-discovery. If you have multiple inverters, you can specify a space-separated list of IDs. |
| `AC-Charger Device ID` | The Sigenergy AC Charger Modbus Device ID. Auto-discovery will identify AC Charger devices. |
| `DC-Charger Device ID` | The Sigenergy DC Charger Modbus Device ID. Auto-discovery will identify DC Charger devices. The `DC-Charger Device ID` is normally the same as the `Inverter Device ID`. |

#### Sensor Scan Intervals

| Option | Description |
|--------|-------------|
| `Near Realtime Frequency` | The scan interval in seconds for Modbus registers that are to be scanned in near-real time. Default is **5** (seconds), and the minimum value is 1. |
| `High Frequency` | The scan interval in seconds for Modbus registers that are to be scanned at a high frequency. Default is **10** (seconds), and the minimum value is 1. |
| `Medium Frequency` | The scan interval in seconds for Modbus registers that are to be scanned at a medium frequency. Default is **60** (seconds), and the minimum value is 1. |
| `Low Frequency` | The scan interval in seconds for Modbus registers that are to be scanned at a low frequency. Default is **600** (seconds), and the minimum value is 1. |

#### PVOutput.org Integration

If you enable status updates to PVOutput, you must enter both the ***API Key*** and ***System ID***. If you donate to PVOutput, battery data will be uploaded and you can configure the extended data fields (see below).

<table>
  <thead><tr><th>Option</th><th>Description</th></tr></thead>
  <tbody>
    <tr><td><code>Enable Uploading</code></td><td>Enable status updates to PVOutput.</td></tr>
    <tr><td><code>API Key</code></td><td>Your API Key for PVOutput. This is <i>mandatory</i> if PVOutput enabled.</td></tr>
    <tr><td><code>System ID</code></td><td>Your PVOutput System ID. This is <i>mandatory</i> if PVOutput enabled.</td></tr>
    <tr><td><code>Enable Consumption Uploads</code></td><td>Enable sending consumption data to PVOutput.</td></tr>
    <tr><td><code>Enable Exports Uploads</code></td><td>Enable sending export data to PVOutput.</td></tr>
    <tr><td><code>Enable Imports Uploads</code></td><td>Enable sending import data to PVOutput.</td></tr>
    <tr><td><code>Enable End-of-Day Upload</code></td><td>If enabled, peak generation and the daily totals for exports and imports (if enabled) are sent to PVOutput at end of day <i>only</i>.<br>If disabled, these values are uploaded at the same interval as status updates.<br><br>If uploaded at the same interval as status updates, PVOutput can overwrite the uploaded values during the day. If this occurs, it will be fixed at end of day.</td></tr>
    <tr><td><code>Voltage Source</code></td><td>The source of the voltage value to be sent to PVOutput. Use 'Phase A' for single-phase systems, 'Phase B', 'Phase C' or 'Line to Line Average' for three-phase or 'Line to Neutral Average' or 'PV Average' for either. The default is 'Line to Neutral Average'.</td></tr>
    <tr><td><code>Extended Data v7</code></td><td rowspan=6>A sensor class name, or entity_id without the 'sensor.' prefix, that will be used to populate the associated extended data field in PVOutput. If not specified, OR your donation status is not current, the field will not be sent to PVOutput. You can use any sensor with a numeric value.<br><br> See note below.</td></tr>
    <tr><td><code>Extended Data v8</code></td></tr>
    <tr><td><code>Extended Data v9</code></td></tr>
    <tr><td><code>Extended Data v10</code></td></tr>
    <tr><td><code>Extended Data v11</code></td></tr>
    <tr><td><code>Extended Data v12</code></td></tr>
    <tr><td><code>Temperature Topic</code></td><td>The MQTT topic to which to subscribe to obtain the current temperature data for PVOutput. If specified, the temperature will be sent to PVOutput. See note below.</td></tr>
  </tbody>
</table>

##### PVOutput Battery Data

If your donation status is current, the Battery Power, SoC, Usable Capacity, and Lifetime Charge/Discharge will be automatically uploaded with each status update.

##### PVOutput Tariff Time Periods

You can define time periods so that `sigenergy2mqtt` can upload exports and imports into their correct tariff time slot (peak, off-peak, shoulder and high-shoulder).

Unfortunately, the relative complexity of the data makes it unsuitable for defining through the Home Assistant App Configuration screen. Therefore, you must define these time periods in the configuration file.

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

You can publish temperature to PVOutput. As an app, `sigenergy2mqtt` does not have direct access to the Home Assistant sensors. It can only consume temperature that has been published to MQTT.

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

##### Extended Data Fields

Extended data fields are only sent to PVOutput if your donation status is current. 

The sensor class names that you can use for these fields can be found in the Attributes of the sensor you wish to send to PVOutput. You can use any sensor that shows a numeric value. 

If a sensor class is used for multiple sensors (e.g. the `PhaseVoltage` sensor class is used for phases A, B and C), the sensor values will be averaged and a single value sent to PVOutput.
If you specify an Energy sensor class, the value sent to PVOutput will be the <i>power</i> value over the Status Interval.

#### MQTT Broker Configuration

If you are using the [Mosquitto Broker](https://github.com/home-assistant/addons/tree/master/mosquitto) Home Assistant App, you can skip the MQTT configuration options. `sigenergy2mqtt` will retrieve them automatically.

Otherwise, you _must_ enter the IP address or host name of the **MQTT Broker**, the **MQTT Port** (if it is not listening on the default port 1883), and if the broker requires authentication, the **MQTT User Name** and **MQTT Password**.

| Option | Description |
|--------|-------------|
| `Broker Address` | The hostname or IP address of your MQTT broker. |
| `MQTT Port` | The listening port of the MQTT broker. The default is 1883, unless MQTT TLS Communication is enabled, in which case the default is 8883. |
| `Enable TLS Communication` | Enable secure communication to MQTT broker over TLS/SSL (if the broker supports it). |
| `User Name` | A valid user name for the MQTT broker. |
| `Password` | A valid password for the MQTT broker username. |

#### InfluxDB Configuration

The `sigenergy2mqtt` app for writing sensor data to your InfluxDB database is different from using the [InfluxDB App](https://github.com/hassio-addons/addon-influxdb). The InfluxDB App only publishes enabled sensors and does not publish repeating data. The `sigenergy2mqtt` app publishes _all_ sensor data (unless includes or excludes are specified), _including_ repeating data, meaning that there are no gaps in the data. The data is published into a different database (`sigenergy` by default) to that used by InfluxDB App, which is usually 'homeassistant'.

The InfluxDB App configuration and credentials are _not_ accessible to the `sigenergy2mqtt` app, so you _must_ configure these options in `sigenergy2mqtt`.

| Option | Description |
|--------|-------------|
| `Enable InfluxDB` | Enable the publication of sensor data to InfluxDB. |
| `Host` | The hostname or IP address of your InfluxDB database. The default is 'a0d7b954-influxdb' (the hostname of the InfluxDB Home Assistant app). |
| `Port` | The listening port of the InfluxDB database. The default is **8086**. |
| `User Name` | A valid user name for the InfluxDB database. |
| `Password` | A valid password for the InfluxDB database username. |
| `Database` | The name of the database to use. The default is **sigenergy**. |
| `Organization` | The InfluxDB v2 organization name or ID. If not specified, the v1 API will be used. |
| `Token` | The InfluxDB v2 authentication token. If supplied, v2 APIs will be used in preference to v1. |
| `Bucket` | The InfluxDB v2 bucket name. If not specified, the value of 'database' will be used as the v2 bucket name. |
| `Include` | A list of sensors to include when publishing to InfluxDB, using either the full or partial entity id or sensor class name, or a regular expression to be matched against the entity id or sensor class name. If not specified, all sensors will be included. |
| `Exclude` | A list of sensors to exclude when publishing to InfluxDB, using either the full or partial entity id or sensor class name, or a regular expression to be matched against the entity id or sensor class name. If not specified, no sensors will be excluded. |

##### InfluxDB API Version

The app supports both InfluxDB v1 and v2 APIs:

- **InfluxDB v1**: Provide `Host`, `Port`, `User Name`, `Password`, and `Database`. Leave `Organization` and `Token` empty.
- **InfluxDB v2**: Provide `Host`, `Port`, `Organization`, `Token`, and optionally `Bucket`. If `Bucket` is not specified, the `Database` value will be used as the bucket name.

If both v1 credentials (username/password) and v2 credentials (token) are provided, the v2 API will be used in preference.

#### Advanced Settings

| Option | Description |
|--------|-------------|
| `Clean MQTT Retained Messages` | Enable to clean MQTT retained messages to refresh Home Assistant sigenergy2mqtt MQTT Devices. **USE WITH CAUTION!** Any defined Home Assistant helpers that reference `sigenergy2mqtt` sensors will be *removed*! |
| `Enable Read Only` | Enable to only read data from the Sigenergy device. Disable to allow writing data to the Sigenergy device. |
| `Disable Remote EMS` | Enable to hide all read/write sensors used for remote Energy Management System (EMS) integration. This may be applicable if, for example, you are part of a VPP which manages the battery. Ignored if `Read Only' is enabled. |
| `Disable Remote EMS Checks` | Enable to turn OFF the validation that disables ESS Max Charging/Discharging and PV Max Power limits when Remote EMS Control Mode is not Command Charging/Discharging. This setting does NOT comply with the Sigenergy Modbus Protocol documentation, and may lead to changes not being applied in some instances. Use with caution! Ignored if `Disable Remote EMS` is enabled. |
| `Enable Percentage Box Editor` | Enable to use a numeric entry box to change the value of percentage sensors or leave disabled to use a slider to change the value. |
| `Sigenergy-Local-Modbus Naming` | Enable to use the TypQxQ/Sigenergy-Local-Modbus entity naming convention for sensors. You should also enable `Clean MQTT Retained Messages` when changing this option, otherwise the new entity names will be ignored by Home Assistant.<br><br>Note that this only affects the _naming_ of the entity id. The underlying unique id is unchanged and will be different from the unique id used by Sigenergy-Local-Modbus, so you will need to remove the old entities from Home Assistant before enabling this option. This also means that it is not possible to migrate historical data from Sigenergy-Local-Modbus to sigenergy2mqtt. |
| `Enable Metrics` | Enable the publication of sigenergy2mqtt metrics to Home Assistant. |
| `Consumption Method` | Set the method of calculating the `Plant Consumed Power` sensor. Valid values are:<br>`Calculated` (consumption is calculated from other sensors, using the algorithm: TotalPVPower &plus; GridSensorActivePower &minus; BatteryPower &minus; ACChargerChargingPower &minus; DCChargerOutputPower),<br>`Total Load` (use `Total Load Power` sensor which is general household load plus AC/DC Charger load), or<br>`General Load` (use the `General Load Power` sensor, which is household load only).<br>The default is **Calculated** on firmware earlier than that supporting Modbus Protocol V2.8 and cannot be changed. On firmware supporting Modbus Protocol V2.8, the default is `Total Load`. |
| `Sanity Check Default kW` | The default value in kW used for sanity checks to validate the maximum and minimum values for actual value of power sensors and the delta value of energy sensors. The default value is **500** kW per second, meaning readings outside the range ±500 are ignored. |
| `Language` | The language to use for `sigenergy2mqtt`. The default is the language defined in Settings → System → Language, or if that language is not supported, the default is English. |
| `Environment Variables` | Allows you to configure advanced environment variables for the sigenergy2mqtt service. The full list of available environment variables can be found [here](https://github.com/seud0nym/sigenergy2mqtt/blob/main/resources/configuration/ENV.md#environment-variables). |

#### Logging Configuration

| Option | Description |
|--------|-------------|
| `sigenergy2mqtt` | Use to set the `sigenergy2mqtt` log level. By default, only WARNING messages are logged. |
| `Sensor to Debug` | Specify a sensor to be debugged using either the full entity id, a partial entity id, the full sensor class name, or a partial sensor class name. You can also use regular expressions. For example, specifying 'daily' would match all sensors with daily in their entity name. If specified, `Logging Level` is also forced to **DEBUG**. |
| `App Run Script` | Set the app run script log level. **WARNING!** Setting this to ALL, TRACE or DEBUG will produce very verbose output. |
| `Modbus` | Set the pymodbus logging level. **WARNING!** Setting this to DEBUG will produce very verbose output. |
| `PVOutput` | Set the PVOutput services logging level. |
| `MQTT` | Set the paho.mqtt logging level. **WARNING!** Setting this to DEBUG will produce very verbose output. |
| `InfluxDB` | Set the InfluxDB logging level. **WARNING!** Setting this to DEBUG may produce very verbose output. |

