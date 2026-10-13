# Changelog

## [2026.10.13] - 2026-10-13

- fix: fix ModuleNotFoundError: No module named 'sigenergy2mqtt'

---

## [2026.10.10] - 2026-10-10

- fix: Remove "Custom Operation Mode" to match SigenergyCloudClient
- fix: support Fahrenheit cloud temperature units
- test: rework tests to match fixed API and updated code
- fix: instant control internal state and removed installerSetEnable from battery export limitation update
- fix: incorrect test data
- test: exercise Cloud API editor reload behaviour
- feat: add live Cloud API test server editor
- refactor: disable import grid limit
- feat: add environment variable documentation for modbus test server
- refactor: reformatted
- test: simulate cloud internet outages
- test: add three-phase cloud gateway endpoint
- refactor: organize sensors by device type
- refactor: renamed community cloud adapter to mySigen cloud adapter
- fix: fixed modbus_test_server.py to handle None values for protocol_version and grid_status_initial_state.
- test: fixed linting errors in test
- test: seed Modbus inverter identities consistently
- test: align cloud API fixtures with Modbus devices
- feat: add community cloud device list retrieval
- fix: add battery export limitation control
- fix: support cloud test token refresh
- feat: add cloud API integration test server
- fix: reset default logging level to INFO

---

## [2026.9.6] - 2026-09-06

- fix: ensured WriteOnlySensorMixin sensors are correctly seeded in Modbus test server to prevent ILLEGAL_ADDRESS errors
- fix: logging level overrides were not be being applied

---

## [2026.9.5] - 2026-09-05

- feat: use DC charger rated power values to set max dis/charging power and update DC charger initialization in test utilities

---

## [2026.8.29] - 2026-08-29

- fix: used Python venv for execution
- test: add AC charger and DC charger power sensors seed values to modbus test server
- refactor: reduce mock data range limits in test server
- refactor: constrain test server generated values to safe subsets to avoid overflows and unrealistic readings
- refactor: Protocol version references to use ProtocolVersion
- refactor: optimize modbus test server logic
- fix: update modbus test server to use unsigned uint16 register packing
- refactor: introduce UNSIGNED_DATA_TYPES for code readability and maintainability
- refactor: reduced log noise

---

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
