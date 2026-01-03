<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->

## 2026.1.3

### What's Fixed

* Fixed bug that caused external MQTT broker configuration to always default to 127.0.0.1 and therefore failed to connect ([#88](https://github.com/seud0nym/sigenergy2mqtt/issues/88))
* Fixed minor bugs revealed by new integration and unit tests

### What's Changed

* Minor code changes to support integration and unit testing
* Removed unused classes
* Upgraded dependencies:
  * psutil: 7.2.0 → 7.2.1
  * scapy: 2.6.1 → 2.7.0
  * ruamel-yaml: 0.18.17 → 0.19.1


## 2025.12.29

### What's Fixed

* Fixed RuntimeWarning about coroutines not being awaited that broke PVOutput uploads and setting sensor values ([#84](https://github.com/seud0nym/sigenergy2mqtt/issues/84))
* Fixed sanity check on power sensors that did not have gain=1000 ([#85](https://github.com/seud0nym/sigenergy2mqtt/issues/85))
* Fixed variable access outside of scope error message that occurred occasionally when handling a PVOutput upload failure ([#84](https://github.com/seud0nym/sigenergy2mqtt/issues/84))
* Maximum number of Modbus registers read in a single scan should be 124, not 125

### What's Changed

* Removed Grid Phase Current/Voltage sensors that were in the pre-release V2.8 protocol, but not in the final release (these sensors were never available because their registers always returned ILLEGAL DATA ADDRESS)


## 2025.12.27

### What's Fixed

* Write-only controls (AC/DC-Charger Start/Stop, and Plant/Inverter Power On/Off) were not working ([#83](https://github.com/seud0nym/sigenergy2mqtt/issues/83))
* AC-Charger Total Energy Consumed state class should be TOTAL_INCREASING ([#83](https://github.com/seud0nym/sigenergy2mqtt/issues/83))


## 2025.12.25🎄

### What's Fixed

* Fixed some issues with minimum/maximum validation
* Fixed error 'expected float for dictionary value @ data['min']' when processing MQTT discovery message topic ([#81](https://github.com/seud0nym/sigenergy2mqtt/issues/81))
* Fixed potential issue with creating battery sensors if both Hybrid and PV inverter installed in same Plant

### What's Changed

* Changed maximum allowed value of LVRT Negative Sequence Reactive Power Compensation Factor, which appears to be at least 20.0 rather than 10.0 as documented ([#80](https://github.com/seud0nym/sigenergy2mqtt/issues/80#issuecomment-3689277867))
* Upgraded dependencies:
  * psutil: 7.1.3 → 7.2.0


## 2025.12.23

### What's Fixed

* Removed clean of devices on upgrade as it caused associated statistics helper entities to get removed ([#77](https://github.com/seud0nym/sigenergy2mqtt/discussions/77))
* Do not start sensor scan group task if all sensors unpublishable ([#79](https://github.com/seud0nym/sigenergy2mqtt/discussions/79))
* Fixed handling of systems that do not have battery modules attached ([#80](https://github.com/seud0nym/sigenergy2mqtt/issues/80))

### What's Changed

* More optimisation of Modbus register pre-reads during sensor scanning
* Refactored code to remove unnecessary properties

### What's New?

* New option to allow percentage sliders to be replaced with number edit boxes


## 2025.12.20

### What's Fixed

* DC-Charger power was not included in consumption calculation after the entity id was renamed in 2025.12.16 ([#74](https://github.com/seud0nym/sigenergy2mqtt/issues/74))
* Fixed UnboundLocalError during initialisation when second inverter found

### What's Changed

* Modified handling of sensors defined in the protocol that fail with ILLEGAL DATA ADDRESS errors in case they are available on some devices (previously they were permanently marked as unpublishable)
* Upgraded dependencies:
  * ruamel-yaml: 0.18.16 → 0.18.17

### What's New?

* Added an option to use either of the new V2.8 Total/General Load Power sensors as the source for the Plant Consumed Power sensor, instead of calculating consumption from multiple inputs
* Added cache hits percentage metric


## 2025.12.18

### What's Fixed

* Fixed bug that prevented switch sensors (e.g. Remote EMS) from being toggled
* Fixed bug in register count calculation for non-contiguous read optimisation plus minor adjustments to contiguous read optimisation


## 2025.12.16

### What's Fixed

* Improved performance of non-contiguous multi-register scans
* Improved write performance and subsequent read/publish of updated value
* Fixed data points randomly missing in upload to PVOutput ([#65](https://github.com/seud0nym/sigenergy2mqtt/discussions/65))
* Fixed issue where sum of PVOutput export/import time period values might not sum to total exports/imports
* Fixed decimals on maximum value (was 4294967.0 but should have been 4294967.29) of these updatable Plant sensors:
  * PV Max Power Limit
  * Grid Max Export Limit
  * Grid Max Import Limit
  * PCS Max Export Limit
  * PCS Max Import Limit
* Fixed entity ids of DC Charger sensors that were incorrectly and inconsistently named as Plant sensors: i.e. (actual ids depend on Device ID of inverter)
  * `sigen_0_plant_vehicle_battery_voltage` → `sigen_0_dc_charger_1_vehicle_battery_voltage`
  * `sigen_0_plant_vehicle_charging_current` → `sigen_0_dc_charger_1_vehicle_charging_current`
  * `sigen_0_plant_dc_charger_output_power` → `sigen_0_dc_charger_1_output_power`
  * `sigen_0_plant_vehicle_soc` → `sigen_0_dc_charger_1_vehicle_soc`
  * `sigen_0_plant_dc_charger_current_charging_capacity` → `sigen_0_dc_charger_1_current_charging_capacity`
  * `sigen_0_plant_dc_charger_current_charging_duration` → `sigen_0_dc_charger_1_current_charging_duration`
* Fixed Max Charge Limit, Max Discharge Limit, and PV Max Power Limit controls that should only be available if the relevant Remote EMS mode (e.g. Command Charging or Command Discharging) is active
* Fixed controls for values associated with Independent Phase Power Control that should only be available when Independent Phase Power Control was enabled 

### What's Changed?

* All sensors are now Modbus Protocol version aware, and are only scanned and published if the firmware supports the protocol version
* Write operations are now validated before committing, and failed validations will be logged
* Upgraded dependencies:
  * pymodbus: 3.11.3 → 3.11.4

### What's New?

* Implemented Sigenergy Modbus Protocol V2.8 (2025-11-20), although sensor changes will not be published until the appropriate firmware has been installed:
  * New Sigenergy Plant Grid Code device to manage HVRT, LVRT, and Over/Under-frequency settings
  * Plant-level alarm sensors
  * Plant General/Total Load Power sensors
  * Plant Grid Sensor phase current and phase voltage sensors
  * Plant Active Power Regulation Gradient control
  * DC Charger Running State
  * Added support for new inverter models that can have up to 36 PV strings
  * Removed sensors that are not available to some specific inverter models (does not affect SigenStor or Sigen Hybrid)


## 2025.11.23

### What's Fixed

* Fixed errors found during an audit of the sensors against the Modbus Protocol document:
  * Missing sensor: InverterPowerFactorAdjustmentFeedback
  * ACChargerChargingPower was being incorrectly decoded as an unsigned value but should be a signed value
  * ACChargerRatedVoltage was being incorrectly decoded as a signed value but should be an unsigned value
  * Inverter PhaseCurrent was being incorrectly decoded as an unsigned value but should be a signed value

### What's New?

* Added new options for specifying which Voltage value is uploaded to PVOutput ([#61](https://github.com/seud0nym/sigenergy2mqtt/issues/61))

## 2025.11.19

### What's Fixed

* Fixed handling of decimal places on PVOutput extended data ([#59](https://github.com/seud0nym/sigenergy2mqtt/issues/59))
* Modified Inverter Power Factor error handling so that when an invalid value (such as 64536) is read from the Modbus interface, the actual Power Factor will be calculated from Active Power and Reactive Power and then published, rather than just ignoring the invalid value

### What's New?

* You can now define time periods (which must match the tariff time periods defined in PVOutput) for uploading exports and imports in the correct tariff slot (peak, off-peak, shoulder and high-shoulder)


## 2025.11.11

### What's Fixed

* Fixed missing device class that caused enumeration values to not be available in Home Assistant (https://whrl.pl/RgRDwB)
* Fixed missing data type in derived sensors that caused `sigenergy2mqtt` to crash on start when they were used as PVOutput extended data ([#59](https://github.com/seud0nym/sigenergy2mqtt/issues/59))

### What's Changed

* Modified verification of end-of-day PVOutput updates to try and work around issue where PVOutput will silently ignore uploads
* Upgraded dependencies:
  * psutil: 7.1.1 → 7.1.3
  * ruamel-yaml: 0.18.15 → 0.18.16 

### What's New?

* Added new optional configuration options that control ping timeouts, and Modbus timeouts and retries, during auto-discovery


## 2025.10.21

### What's Fixed

* Changed the way that the random MQTT Client ID was generated because of issues with entropy in Docker containers ([#47](https://github.com/seud0nym/sigenergy2mqtt/issues/47))
* Now exits gracefully with an appropriate error message if auto-discovery fails to find a device, rather than just crashing ([#49](https://github.com/seud0nym/sigenergy2mqtt/issues/49))
* Fixed bug in detection of PVOutput donation status that caused it to always be false, so extended data fields were never uploaded
* Data errors in PVOutput uploads are now reported correctly and do not trigger a retry of the upload
* During a grid outage, AC/DC charger power will be ignored in the calculation of Plant Consumed Power because if these devices are not backed up, the absence of data causes consumption to not be published

### What's Changed

* All scan intervals now have a minimum interval of 1 second
* Generation and consumption uploaded to PVOutput is now the power value over the status interval (rather than uploading lifetime energy and letting PVOutput calculate power) so that the system will show correctly in Live Outputs
* If an energy sensor is specified in the PVOutput extended data fields, the value sent to PVOutput will be the power value over the status interval for consistency with other PVOutput uploads
* The entity id can now be used to specify PVOutput extended data fields (sensor class name can still be used)
* Upgraded dependencies:
  * psutil: 7.1.0 → 7.1.1

### What's New?

* PVOutput now supports battery data (for donators only), so status updates will now automatically include Battery Power, SoC, Usable Capacity, and Lifetime Charge/Discharge


## 2025.10.12

### What's Fixed

* Fixed default_entity_id missing platform prefix in Home Assistant MQTT auto-discovery that caused all sensors to be named `unnamed_device_xx_xxx` ([#44](https://github.com/seud0nym/sigenergy2mqtt/issues/44)/[#45](https://github.com/seud0nym/sigenergy2mqtt/issues/45)) for _new_ installs

### What's Changed

* Internal code refactoring in PVOutput services


## 2025.10.5

### Known Issues

1. Invalid Inverter Power Factor values outside of the valid range of 0.0 to 1.0 have been ignored and not published since Release 2025.9.24 (although a warning log message is generated). Nonsensical values like 64.5 have been reported to Sigenergy with detailed logs.
1. The PVOutput end-of-day output upload (exports, imports, and peak power) sometimes appears to fail with no reason. Peak power gets recorded, but exports and imports do not appear in the Daily Standard or Details views in PVOutput. No error is reported by PVOutput. This problem is still under investigation.

### What's Fixed

* Corrected the state class for Total Consumption on Smart Load ports (should be TOTAL INCREASING, not TOTAL) [(#39)](https://github.com/seud0nym/sigenergy2mqtt/pull/39) - Thanks to @3432
* Home Assistant MQTT auto-discovery requires "default_entity_id" as of Core 2025.10

### What's Changed?

* Reworked PVOutput upload to try and fix several issues:
  * Changed scheduling logic because end-of-day output upload (export/import/peak power) could drift past midnight [(#36)](https://github.com/seud0nym/sigenergy2mqtt/issues/36)
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
