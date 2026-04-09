# Sigenergy Modbus Simulator

A Home Assistant add-on that runs a **Modbus TCP simulator** for SigenStor/Sigenergy
inverters, sourced from the
[sigenergy2mqtt](https://github.com/seud0nym/sigenergy2mqtt) project.

Use this add-on to test `sigenergy2mqtt` (or any Modbus client) without needing
a physical inverter on your network.


## How it works

The add-on clones the `sigenergy2mqtt` repository at build time and launches
`tests/utils/modbus_test_server.py` — a Modbus TCP server that simulates a
SigenStor inverter on **port 502**.


## Notes

- The simulator is intended for **testing and development** only.
- Port 502 is a privileged port on Linux. The add-on container runs with the
  permissions required to bind it; no extra host capabilities are needed
  because Home Assistant OS manages port mapping for add-ons.