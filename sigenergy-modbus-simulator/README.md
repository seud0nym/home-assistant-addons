# Sigenergy Modbus Simulator

A Home Assistant add-on that runs a **Modbus TCP simulator** for SigenStor/Sigenergy
inverters, sourced from the
[sigenergy2mqtt](https://github.com/seud0nym/sigenergy2mqtt) project.

Use this add-on to test `sigenergy2mqtt` (or any Modbus client) without needing
a physical inverter on your network.

---

## How it works

The add-on clones the `sigenergy2mqtt` repository at build time and launches
`tests/utils/modbus_test_server.py` — a Modbus TCP server that simulates a
SigenStor inverter on **port 502**.

---

## Installation

### Add test repository to your Home Assistant add-on store

#### Automatic

[![Open your Home Assistant instance and show the add app repository dialogue with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fseud0nym%2Fhome-assistant-addons#test)

#### Manual

1. Navigate in your Home Assistant frontend to **Settings** -> **Apps** -> **App store**.
1. Click the three vertical dots in the top-right corner and select **Repositories**.
1. Enter https://github.com/seud0nym/home-assistant-addons#test and click the **ADD** button.
1. Close the Repositories window and refresh.

### Install the app

1. Install **Sigenergy Modbus Simulator**.
2. Start the add-on.

---


## Notes

- The simulator is intended for **testing and development** only.
- Port 502 is a privileged port on Linux. The add-on container runs with the
  permissions required to bind it; no extra host capabilities are needed
  because Home Assistant OS manages port mapping for add-ons.