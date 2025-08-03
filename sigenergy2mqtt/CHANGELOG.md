<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->


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
