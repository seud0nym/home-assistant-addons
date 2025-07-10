<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->

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
