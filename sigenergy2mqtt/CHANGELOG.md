<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->

## 2025.10.5

### Known Issues

1. Invalid Inverter Power Factor values outside of the valid range of 0.0 to 1.0 have been ignored and not published since Release 2025.9.24 (although a warning log message is generated). Nonsensical values like 64.5 have been reported to Sigenergy with detailed logs.
1. The PVOutput end-of-day output upload (exports, imports, and peak power) sometimes appears to fail with no reason. Peak power gets recorded, but exports and imports do not appear in the Daily Standard or Details views in PVOutput. No error is reported by PVOutput. This problem is still under investigation.

### What's Fixed

* Corrected the state class for Total Consumption on Smart Load ports (should be TOTAL INCREASING, not TOTAL) [(#39)](https://github.com/seud0nym/sigenergy2mqtt/pull/39) - Thanks to @3432
* Home Assistant MQTT auto-discovery requires "default_entity_id" instead of "object_id" as of Core 2025.10

### What's Changed?

* Reworked PVOutput upload to try and fix several issues:
  * Changed scheduling logic because end-of-day output upload (export/import/peak power) could drift past midnight [(#36)](https://github.com/seud0nym/sigenergy2mqtt/pull/36)
  * Upload of exports and imports can now be disabled (in addition to consumption which was already optional)
  * End of day totals upload can now be scheduled to run at same interval as status updates, which means that export/import/peak power changes are visible during the day, rather than having to wait until next day
  * Under some circumstances, some data was missing from the uploads
* Auto-discovery changes:
  * Modbus devices with lowest latency will be scanned first, to try and detect the Ethernet connection in preference to the Wi-Fi connection
  * Already detected serial numbers will be ignored to prevent duplication of devices that have both Ethernet and Wi-Fi connectivity 
* Retry failed MQTT connection on start-up 3 times at 30 second intervals before failing
* Upgraded dependencies:
  * pymodbus: 3.11.2 → 3.11.3

### What's New?

* Added tracing of Modbus packets when sensor debugging enabled


## 2025.9.24-1

### What's Fixed?

* Installations with multiple inverters were _still_ not able to manually define multiple device ids [(#36)](https://github.com/seud0nym/sigenergy2mqtt/issues/36)


## 2025.9.24

### What's Fixed?

* Installations with multiple inverters were not able to enter multiple device ids [(#36)](https://github.com/seud0nym/sigenergy2mqtt/issues/36)
* Auto-discovery could not be over-ridden by manually configuring a `Sigenergy Modbus Host` [(#36)](https://github.com/seud0nym/sigenergy2mqtt/issues/36)
* Auto-discovery could duplicate plant and inverters when connected to LAN by both ethernet and Wi-Fi [(#36)](https://github.com/seud0nym/sigenergy2mqtt/issues/36)
* AC/DC Charger Start/Stop actions reversed
* MQTT subscriptions were not being renewed on reconnection to the MQTT broker (e.g. after updating the Mosquitto add-on), so no control value changes were being processed and no data was uploaded to PVOutput until add-on was restarted
* Status uploads are now only sent to PVOutput if the source sensors are being updated
* Improved documentation

### What's New?

* PVOutput donators can now specify up to six numeric sensor classes to be uploaded as extended data
* Verification of PVOutput daily upload and retry if not recorded correctly

### What's Changed?

* Refactored Phase sensors and sensors that have string values to remove code duplication
* Refactored sensor publishing locking strategy
* Refactored Modbus handling to reduce number of reads and improve performance at high-frequency scan intervals
* Added sanity checks to inverter power factor and temperature sensors
* Upgraded home-assistant/builder: 2025.03.0 → 2025.09.0
* Upgraded dependencies:
  * pymodbus: 3.11.1 → 3.11.2
  * psutil: 7.0.0 → 7.1.0


## 2025.8.31

### What's Fixed?

* Fixed bug in resetting calculated daily sensors on restart
* Fixed names of AC/DC Charger Start/Stop buttons (previously labelled as Power On/Off)

### What's New?

* Auto-discovery of Sigenergy Modbus hosts and device IDs. This will happen by default if no Sigenergy Modbus Host is specified in the Configuration, or you may optionally force it.

### What's Changed?

* Upgraded dependencies:
  * pymodbus: 3.11.0 → 3.11.1
  * requests: 2.32.4 → 2.32.5
  * ruamel.yaml: 0.18.14 → 0.18.15
* Added CRITICAL logging level for PVOutput, MQTT and Modbus to eliminate all log messages except those that are fatal
* Ensure the length of combined alarm sensor values does not exceed HA limit of 255 characters
* Exclude .yaml files from stale file clean-up


## 2025.8.15

### What's Fixed?

* Fixed AssertionError when creating AC Charger device


## 2025.8.11

### What's Fixed?

* Smart Load Power sensors (01-24) had incorrect Unit of Measurement (kWh should be kW) and Device Class (Energy should be Power) ([#20](https://github.com/seud0nym/sigenergy2mqtt/issues/20))

### What's Changed?

* Sensor attributes now contain source for derived (calculated) sensors and any relevant comments from the Modbus Protocol document
* Consumed Power now includes AC/DC Charger output power
* Alarms and AC/DC Charger power sensors are now refreshed at the 'realtime' scan interval (default = 5s)
* Upgraded to pymodbus 3.11.0
* Add-on now built from same wheel as Docker build, rather than pulling latest version from PyPi

### What's New?

* MQTT broker communication can now be configured to use TSL/SSL encryption if the configured broker supports it ([#19](https://github.com/seud0nym/sigenergy2mqtt/issues/19))


## 2025.8.5

### What's Fixed?

* Fixed 'dictionary changed size during iteration' error in PVOutput services ([#16](https://github.com/seud0nym/sigenergy2mqtt/issues/16))
* Fixed infinite loop on error in PVOutput services ([#16](https://github.com/seud0nym/sigenergy2mqtt/issues/16))
* Fixed incorrect device class and state class for inverter `Reactive Power Fixed Value Adjustment Feedback`
* Fixed 'Lock bound to different event loop' error during metrics publish
* Logged failure to connect to MQTT broker rather than silently failing

### What's Changed?

* Improved accuracy of sensor scanning intervals
* Improved general exception logging with improved representation of error
* PVOutput last updated warnings will only appear at most once per hour


## 2025.8.3

### What's Fixed?

* Fixed merging of add-on configuration when a configuration file was used ([#14](https://github.com/seud0nym/sigenergy2mqtt/issues/14))


## 2025.8.2-1

### What's Fixed?

* Fixed bug introduced in 2025.8.2 when handling command line options ([#15](https://github.com/seud0nym/sigenergy2mqtt/issues/15))


## 2025.8.2

### What's Fixed?

* Fixed Max Charge Limit, Max Discharge Limit and PV Max Power Limit not available when Remote EMS enabled ([#12](https://github.com/seud0nym/sigenergy2mqtt/issues/12))
* Fixed incorrect publishing of unpublishable sensors on Home Assistant restart
* Fixed warning log messages when saved state files contain initial `None` value
* Fixed Sigenergy Modbus Protocol version in Plant Device Info (was showing V2.5 but should be V2.7)
* Fixed Inverter Device Info hardware version not updating after firmware update
* Workaround for alarm values returned as a list rather than single UINT16
* Fixed handling of Modbus connection failure and reduced associated log spamming

### What's New?

* Added a new `Sigenergy Metrics` device containing some `sigenergy2mqtt` Modbus read/write metrics
  * By default this is disabled, but there is a new configuration option called `Enable sigenergy2mqtt Metrics` which can be used to control the publication of the metrics
* Added some inverter sensors that threw ILLEGAL DATA ADDRESS errors prior to Firmware V100R001C00SPC110 (these sensors will not be enabled by default):
  * Active Power Fixed Value Adjustment Feedback
  * Reactive Power Fixed Value Adjustment Feedback
  * Active Power Percentage Adjustment Feedback
  * Reactive Power Percentage Adjustment Feedback
* The attributes of updatable sensors now contains the update topic for use in automations 
* Added warning log message if PVOutput source topics not updated within last update interval

### What's Gone?

* The `PVOutput Interval` configuration option has been removed because the Status Interval is now determined from the settings on pvoutput.org via the PVOutput API
* AC/DC Charger statistics will not be published if no chargers defined

### What's Changed?

* Upgraded dependencies:
  * paho-mqtt: 1.6.1 → 2.1.0
  * pymodbus: 3.8.4 → 3.10.0
  * requests: 2.32.3 → 2.32.4
  * ruamel.yaml: 0.18.6 → 0.18.14
* Cleaned up some informational messages that were only used for debugging
* Removed stale persistent state files on initialisation

## 2025.7.19

* Fixed bug that caused some write operations to fail ([#9](https://github.com/seud0nym/sigenergy2mqtt/issues/9))
* Fixed potential issue with installations that have multiple inverters
* Added average voltage across PV strings to PVOutput status updates
* Added ability to optionally add temperature to PVOutput status updates by defining an MQTT topic from which current temperature can be obtained

## 2025.7.13-1

* Fixed bug that caused DailyChargeEnergy, DailyDischargeEnergy, TotalLoadDailyConsumption, and InverterPVDailyGeneration to be disabled at midnight when they reset to zero ([Discussion #6](https://github.com/seud0nym/sigenergy2mqtt/discussions/6))


## 2025.7.13

* Fixed bug that prevented PVOutput peak-power reporting
* Fixed bug that caused PVOutput values to be incorrect by factor of 10
  * Because of the way that PVOutput validates uploaded data, the remaining updates for the day you install this fix may not be recorded
* Minor fixes to aid debugging

## 2025.7.10

> [!WARNING]  
> All accumulation sensors that were previously calculated by `sigenergy2mqtt` and have now been replaced by values read from the Modbus interface will probably record a large increase or decrease after installing this release, reflecting the change from an estimated value to the real value as provided by the Modbus interface.

> [!WARNING]  
> All daily sensors that were previously derived from a calculated accumulation sensor will also reflect a large increase or decrease, as they are calculated from the accumulation sensor value as at the previous midnight. You can adjust the daily figures manually through the provided "Set Daily ..." controls, or they will update correctly on the next day.

* Fixed stepping on the percentage sliders so that they increment/decrement by 1 rather than fractions
* Added default sanity checks on all power and energy sensors
  * The sanity check value can be modified through the Add-on configuration
  * The default value is 100:
    * Power sensor values that are outside the range of ±100 kW per second (measured by scan interval) will be ignored
    * Changes in energy sensor values that are outside the range of ±100 kWh per second (measured by scan interval) will be ignored
  * Sanity check minimum/maximum values for individual sensors can be set using a configuration file

* Implemented Sigenergy Modbus Protocol V2.6
  * Replaced calculated plant running info sensors with values now supplied by the Modbus interface: 
    * Lifetime PV Production
    * Daily Consumption
    * Lifetime Consumption 
  * Added new plant sensors for Smart Load 01-24 Total Consumption and Power
  * Ability to set battery Backup SoC, Charge Cut-Off SoC, and Discharge Cut-Off SoC
  * Replaced calculated inverter sensors with values supplied by the Modbus interface: 
    * Daily PV Production
    * Lifetime PV Production
    
* Implemented Sigenergy Modbus Protocol V2.7
  * New sensors for Third-Party PV Power and Lifetime PV Energy supplied by the Modbus interface
      * These sensor can replace the `sigenergy2mqtt` Smart-Port configuration (although they do appear to be updated less frequently)
  * Replaced calculated plant running info sensors with values now supplied by the Modbus interface: 
    * Lifetime Charge Energy
    * Lifetime Discharge Energy
    * Lifetime Imported Energy
    * Lifetime Exported Energy
  * Added new accumulation sensors now supplied by the Modbus interface:
    * Lifetime DC EV Charge Energy
    * Lifetime DC EV Discharge Energy
    * Lifetime Generator Output Energy
  * Added new Plant Statistics device for the new Modbus energy statistics interface to distinguish them from the legacy lifetime sensors
    * Sensor values supplied by the Modbus interface: 
      * Total Common Load Consumption
      * Total AC EV Charge Energy
      * Total Self PV Generation
      * Total Third-Party PV Generation
      * Total Charge Energy
      * Total Discharge Energy
      * Total DC EV Charge Energy
      * Total DC EV Discharge Energy
      * Total Imported Energy
      * Total Exported Energy
      * Total Generator Output Energy
      
> [!IMPORTANT]
> For the new energy statistics interface from Modbus Protocol V2.7, after upgrading the device firmware to support this interface, the sensor values will reset to 0 and start fresh counting without inheriting historical data. They may therefore differ from the legacy sensors on the Plant device.


## 2025.6.14

* Firmware V100R001C00SPC109 added new EMS Work Mode 'Time-Based Control'
* Fixed Inverter Device Info not updating after firmware update
* Ignored spurious peak power values for PVOutput outside of daylight hours
* Ignored empty payloads from subscribed MQTT topics ([#4](https://github.com/seud0nym/sigenergy2mqtt/issues/4))
* Changed wait timeout for Home Assistant discovery acknowledgement to 10s

## 2025.6.11

* Added configuration options to allow scanning interval frequencies to be overridden
* Fixed bug in scheduling next days PVOutput peak power update

## 2025.6.5

* Fixed PVOutput service losing daily peak power when service restarted
* Refactored PVOutput services to remove code duplication
* Refactored Modbus locking to implement timeouts

## 2025.5.31

Note: There is a version mismatch with this release. The actual version of `sigenergy2mqtt` included with this release of the add-on is 2025.6.1.

* Fixed bug in calculation of PV string power ([#2](https://github.com/seud0nym/sigenergy2mqtt/issues/2))
* Fixed bug where Remote EMS availability was incorrectly applied to inverter R/W sensors, causing them to be unavailable for updates unless Remote EMS was enabled
* Fixed bug in resetting daily accumulation totals
* Fixed bug that prevented Enphase Smart-Port daily PV energy from being updated
* Improved handling of negatives when accumulating energy lifetime statistics ([#2](https://github.com/seud0nym/home-assistant-addons/issues/2))
* Added sanity check to ignore negative consumption ([#2](https://github.com/seud0nym/home-assistant-addons/issues/2))
* Added new configuration option to allow all Remote EMS-related sensors to be hidden
* Added new configuration option to log debug messages from a sensor (or from multiple sensors whose names contain the same string)

## 2025.5.30-1

* Fix for failed start on 3 phase installations ([#3](https://github.com/seud0nym/home-assistant-addons/issues/3))

## 2025.5.30

* Fixed bug that caused all writes to Modbus registers to fail silently
* Fixed bug that caused sensors that were only applicable to a PV inverter to be added to a Hybrid inverter, and vice-versa
* Fixed bug that caused some sensors that are only applicable to 3 phase setups to be published for single phase installations
* Fixed issues with precision when publishing derived sensors
* Fixed bug that prevented PVOutput to be configured via Home Assistant Add-On, command line options and environment variables
* Fixed handling of some environment variables and command line options that were documented but not fully implemented
* Added capability to set sanity checking limits on values read from the Modbus registers via sensor overrides
  * Added sanity check on `GridSensorActivePower` to ignore readings ±100kW ([#1](https://github.com/seud0nym/home-assistant-addons/issues/1))
* Fixed logging level of some warnings that were incorrectly logged as errors ([#2](https://github.com/seud0nym/home-assistant-addons/issues/2))

## 2025.5.24

* Daily Peak PV Power will now be automatically updated on PVOutput at 21:45 each day
* Minor bug fixes

## 2025.5.18

* Fixed bug in applying device sensor publishable overrides
* Fixed bug in initialisation of AC-Charger device
* Added new configuration option to allow configuring for read-only access to the Modbus interface

## 2025.5.16-1

* Fixed validation issues and handling of multiple device IDs

## 2025.5.16

* Initial release
