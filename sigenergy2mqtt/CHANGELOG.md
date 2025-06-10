<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->

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
