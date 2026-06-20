# Changelog

## [2026.6.20] - 2026-06-20

- update base image to alpine 3.24 and enable host network access

---

## [2026.6.10] - 2026-06-10

- update pymodbus logger configuration and enable multi-inverter firmware upgrade simulation
- enum sensors were defaulted incorrectly
- add device naming to test logs and a dummy catch-all unit to modbus test server
- log device ids and address counts in modbus test server
- simulated grid outage during startup for EVAC not on backup circuit
- grid_status_initial_state had no default when setting from envvar
- restart after outage-skipped AC charger when grid restores

---

## [2026.4.17] - 2026-04-17

- Reimplement Modbus test server using pymodbus v3.13.0 SimDevice

---

## [2026.4.9a1] - 2026-04-09

- Initial release of the Sigenergy Modbus Simulator Home Assistant add-on
