# Sigenergy Modbus Simulator

This app runs a simulated Sigenergy/SigenStor inverter over Modbus TCP,
sourced from the [sigenergy2mqtt](https://github.com/seud0nym/sigenergy2mqtt)
project. It is intended for **testing and development only** — specifically
for validating [sigenergy2mqtt](https://github.com/seud0nym/sigenergy2mqtt)
configuration and behaviour without requiring a physical inverter.

The simulator listens on port **502** (standard Modbus TCP).

The following devices are simulated:

```
Sigenergy Plant (Device ID 247)
   ├─ SigenStor EC 12.0 TP CMU123A45BP678 (Device ID 1)
   │    ├─ SigenStor EC 12.0 TP CMU123A45BP678 PV String 1
   │    ├─ SigenStor EC 12.0 TP CMU123A45BP678 PV String 2
   │    ├─ SigenStor EC 12.0 TP CMU123A45BP678 PV String 3
   │    ├─ SigenStor EC 12.0 TP CMU123A45BP678 PV String 4
   │    └─ Sigenergy DC Charger
   ├─ Sigenergy AC Charger (Device ID 2)
   └─ Sigen PV Max 5.0 TP CMU876A54BP321 (Device ID 3)
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 1
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 2
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 3
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 4
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 5
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 6
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 7
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 8
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 9
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 10
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 11
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 12
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 13
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 14
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 15
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 16
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 17
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 18
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 19
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 20
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 21
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 22
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 23
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 24
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 25
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 26
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 27
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 28
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 29
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 30
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 31
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 32
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 33
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 34
        ├─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 35
        └─ Sigen PV Max 5.0 PV TP CMU876A54BP321 String 36
```

When a production Sigenergy device is used for seeding, the model and serial 
number of the device will be used instead of the dummy numbers above for 
Device ID 1 only.

The seeding device is assumed to be single phase, and subsequently some of the 
phase B and C values will be duplicated from phase A values.

---

## Getting started

1. Install and start the app with all options at their defaults.
2. Point your `sigenergy2mqtt` instance at your Home Assistant host IP on
   port `502`.
3. The simulator will respond to Modbus reads with synthetic inverter data.

---

## Seeding initial state

By default the simulator starts with built-in synthetic register values.
For more realistic testing you can seed it from a live source so that it
starts with the actual current state of a real inverter.

Two seeding methods are available — you should use one or the other, not
both at the same time.

### Seed from a live Modbus inverter

Set **Live Modbus Host** to the IP address of a real Sigenergy inverter on
your network. The simulator will connect to it over Modbus TCP at startup,
copy its current register values, and use those as its initial state.

| Option | Default | Notes |
|---|---|---|
| Live Modbus Host | _(unset)_ | IP address of the live inverter |
| Live Modbus Port | `502` | Only change if your inverter is on a non-standard port |

### Seed from an MQTT broker

Set **MQTT Broker** to the hostname or IP of an MQTT broker that is already
being populated by a live `sigenergy2mqtt` instance. The simulator will
subscribe to the relevant topics and use the retained values to seed its
registers. It will then continue to receive updates via MQTT, and will 
use these values to update its internal state, rather than generating 
random values. Not all registers will be updated via MQTT, so some 
registers will be randomly generated. 

| Option | Default | Notes |
|---|---|---|
| MQTT Broker | _(unset)_ | Hostname or IP of the broker |
| MQTT Port | `1883` | Standard MQTT port |
| MQTT Username | _(unset)_ | Leave blank for anonymous access |
| MQTT Password | _(unset)_ | Leave blank for anonymous access |
| MQTT Log Level | `WARNING` | Increase to `DEBUG` to trace the seeding subscription |

---

## Simulation options

These options enable specific behaviours that are useful for testing how
`sigenergy2mqtt` handles edge cases.

| Option | Default | Description |
|---|---|---|
| Simulate Grid Outages | `false` | Periodically toggles the grid-connected state |
| Simulate Firmware Upgrade | `false` | Cycles through a firmware upgrade sequence |
| Simulate Power Factor Errors | `false` | Injects out-of-range power factor values |
| Use Simplified Topics | `false` | Match this to your production `sigenergy2mqtt` topic mode |

### Use Simplified Topics

This must match the `simplified_topics` setting in your `sigenergy2mqtt`
configuration. If they differ, MQTT seeding will not find the expected
topics and the simulator will fall back to its synthetic defaults.

### Simulate Firmware Upgrade

When enabled, the simulator reports the **Initial Firmware Version** at
startup and then transitions to the **Upgrade Firmware Version** during the
simulated cycle. Set both version strings to match firmware versions
relevant to your inverter model, or leave them blank to use the
simulator's built-in defaults.

---

## Firmware version options

| Option | Default | Example |
|---|---|---|
| Initial Firmware Version | _(simulator default)_ | `A.00.00.00.00.0251` |
| Upgrade Firmware Version | _(simulator default)_ | `A.00.00.00.00.0252` |
| Protocol Version | _(simulator default)_ | _(consult sigenergy2mqtt docs)_ |

---

## Logging

| Option | Default | Description |
|---|---|---|
| Log Level | `INFO` | Controls the simulator's own log verbosity |
| MQTT Log Level | `WARNING` | Controls MQTT client log verbosity (seeding only) |
| Registers to Debug | _(unset)_ | Comma-separated Modbus register addresses for trace logging |

Set **Log Level** to `DEBUG` for full Modbus request/response traces.
Use **Registers to Debug** to limit trace output to specific registers of
interest (e.g. `30001,30002`) rather than logging every register access.

---

## Port mapping

The app exposes port **502/tcp**. Port 502 is the standard Modbus TCP
port, so no changes are needed if you are running `sigenergy2mqtt` on the
same Home Assistant host.

If port 502 is already in use on your host (e.g. by a real inverter bridge),
you can remap the host-side port in the app's **Network** settings. You
will then need to point `sigenergy2mqtt` at the alternative port.

---

## Troubleshooting

**`sigenergy2mqtt` cannot connect to the simulator**
Confirm the app is running and check that your `sigenergy2mqtt`
configuration points to the correct host IP and port 502 (or your remapped
port). The app log at `INFO` level will show an entry for each incoming
Modbus connection.

**Simulator starts with unexpected/zero register values**
Check that your chosen seeding source (Modbus or MQTT) is reachable and that
the credentials and topic mode (**Use Simplified Topics**) match your live
`sigenergy2mqtt` instance. Set the relevant log level to `DEBUG` to trace
the seeding process.

**`sigenergy2mqtt` behaves differently against the simulator than against the real inverter**
This is expected — the simulator replicates the Modbus register map but does
not model all inverter physics. It is best used for testing configuration,
topic structure, and edge-case handling rather than validating energy
calculations.