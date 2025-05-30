<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->

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
