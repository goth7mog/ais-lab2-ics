# 🏭 AIS-Lab2 — Industrial Security Lab (ICS/SCADA)

## Overview

This lab demonstrates a simulated Industrial Control System (ICS) environment focused on OT/ICS security, Modbus TCP communication, and network visibility.

The environment was built using Docker containers and simulates communication between a PLC runtime and a Human Machine Interface (HMI) client inside an isolated OT network.

The lab focuses on:

* ICS/SCADA simulation
* OT network communication
* Modbus TCP analysis
* Packet capture and traffic inspection
* Attack surface identification
* OT security documentation

---

# ⚙️ Step 1 — Build the ICS Environment

A dedicated OT lab environment was created using Docker Compose.

## Components

| Component  | Role          | IP Address | Protocol   |
| ---------- | ------------- | ---------- | ---------- |
| OpenPLC    | PLC Runtime   | 10.0.50.10 | Modbus TCP |
| HMI Client | Simulated HMI | 10.0.50.20 | Modbus TCP |

## Docker Network

A dedicated OT network was created:

```bash
10.0.50.0/24
```

## Docker Compose

The ICS environment was started using:

```bash
docker compose -f docker-compose-ics.yml up -d
```

## Verification

Container status was verified using:

```bash
docker ps
```

### Screenshot

* `screenshots/02-docker-ps.png`
* `screenshots/03-docker-network.png`

---

# 🧠 Step 2 — Configure OpenPLC

OpenPLC was configured as the simulated PLC runtime.

The OpenPLC web interface was accessed through:

```text
http://localhost:8080
```

Default credentials:

```text
openplc / openplc
```

## PLC Program

A Structured Text (ST) program was created to simulate a simple industrial process.

### Features

* Tank level monitoring
* Pump control
* Valve control
* High and low threshold logic

## Program File

```text
simple_process.st
```

## PLC Runtime

The PLC runtime was successfully started and verified.

### Screenshot

* `screenshots/01-openplc-running.png`

---

# 🌐 Step 3 — Simulated HMI Communication

Because the original ScadaBR Docker image referenced in the assignment was no longer publicly available, a lightweight Ubuntu-based HMI client container was deployed instead.

The HMI client communicated with OpenPLC over Modbus TCP inside the OT network.

## Communication Test

Connectivity was verified using:

```bash
ping 10.0.50.10
```

## Modbus Polling

Modbus traffic was generated using:

```bash
mbpoll -m tcp 10.0.50.10
```

This simulated continuous HMI polling behavior against the PLC.

### Screenshot

* `screenshots/04-mbpoll-traffic.png`

---

# 📡 Step 4 — OT Traffic Analysis

Modbus TCP communication between the HMI client and OpenPLC runtime was captured and analyzed.

## Packet Capture

Traffic was captured using tcpdump:

```bash
tcpdump -i eth0 -w ot_traffic.pcap port 502
```

## Analysis

Captured traffic showed:

* Continuous polling behavior
* Communication over TCP port 502
* Unencrypted Modbus TCP traffic
* Repeated request/response patterns

## Observed Communication

| Source     | Destination | Protocol   |
| ---------- | ----------- | ---------- |
| 10.0.50.20 | 10.0.50.10  | Modbus TCP |

## Security Observation

Modbus TCP traffic is transmitted in plaintext and lacks authentication.

### Screenshot

* `screenshots/05-modbus-tcpdump.png`

---

# 🛡️ Step 5 — ICS Architecture & Attack Surface Analysis

The ICS architecture and OT communication flow were documented.

## Architecture

The environment consisted of:

```text
HMI Client  --->  Modbus TCP  --->  OpenPLC Runtime
```

## Identified Attack Surface

1. Modbus TCP lacks authentication
2. Modbus traffic is unencrypted
3. OpenPLC web interface exposed without TLS
4. Standard credentials used
5. No IDS or monitoring enabled yet
6. No network segmentation beyond Docker OT network
7. PLC registers can be queried directly over the network

## Network Scanning

Open ports were identified using:

```bash
nmap -sT -p 1-1024 10.0.50.10 10.0.50.20
```

## Security Reflection

Industrial protocols such as Modbus TCP were designed for trusted and isolated environments and therefore lack modern security mechanisms such as:

* Encryption
* Authentication
* Integrity validation

This creates significant risks in modern connected OT environments.

### Screenshots

* `screenshots/06-nmap-scan.png`
* `screenshots/07-ics-architecture.png`

---

# 📁 Project Structure

```text
labb2-ics/
├── docs/
│   └── ics-architecture.md
├── screenshots/
│   ├── 01-openplc-running.png
│   ├── 02-docker-ps.png
│   ├── 03-docker-network.png
│   ├── 04-mbpoll-traffic.png
│   ├── 05-modbus-tcpdump.png
│   ├── 06-nmap-scan.png
│   └── 07-ics-architecture.png
├── docker-compose-ics.yml
├── ot_traffic.pcap
├── simple_process.st
└── README.md
```

---

# ✅ Summary

This lab successfully demonstrated:

* ICS/SCADA simulation
* PLC runtime deployment
* OT network communication
* Modbus TCP analysis
* Packet capture and traffic inspection
* Attack surface identification
* Basic industrial security analysis

The environment now provides a foundation for future work involving:

* IDS deployment
* Suricata rules
* Wazuh integration
* IT/OT segmentation
* Purdue model implementation
* OT threat detection

---

# 👨‍💻 Author

Abdihakim
DevOps & Cybersecurity Student
