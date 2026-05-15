# 🏭 AIS-Lab2 — Industrial Security Lab (ICS/SCADA)

## Overview

This project demonstrates a simulated Industrial Control System (ICS) / SCADA environment focused on OT/ICS security, Modbus TCP communication, network segmentation, monitoring, and incident response.

The environment was built using Docker containers and simulates communication between a PLC runtime and a Human Machine Interface (HMI) client inside an isolated OT network.

The lab focuses on:

* ICS/SCADA simulation
* OT network communication
* Modbus TCP analysis
* Packet capture and traffic inspection
* IT/OT segmentation using the Purdue Model
* IDS and SIEM monitoring
* Zero Trust access control
* OT attack simulation and incident response
* ICS-CERT style reporting

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

### Screenshots

* `screenshots/01-openplc-running.png`
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

```text
HMI Client  --->  Modbus TCP  --->  OpenPLC Runtime
```

## Identified Attack Surface

1. Modbus TCP lacks authentication
2. Modbus traffic is unencrypted
3. OpenPLC web interface exposed without TLS
4. Standard credentials used
5. No IDS or monitoring enabled initially
6. Limited network segmentation in the original OT setup
7. PLC registers accessible directly over the network

## Network Scanning

Open ports were identified using:

```bash
nmap -sT -p 1-1024 10.0.50.10 10.0.50.20
```

## Security Reflection

Industrial protocols such as Modbus TCP were originally designed for trusted and isolated environments and therefore lack modern security mechanisms such as:

* Encryption
* Authentication
* Integrity validation

This creates significant risks in modern connected OT environments.

### Screenshots

* `screenshots/06-nmap-scan.png`
* `screenshots/07-ics-architecture.png`

---

# 🏭 Part 2 — IT/OT Network Segmentation (Purdue Model)

This phase focused on implementing secure industrial network segmentation using the Purdue Model.

## Implemented Zones

| Zone    | Subnet       | Purpose                     |
| ------- | ------------ | --------------------------- |
| IT Zone | 10.0.10.0/24 | Workstations and monitoring |
| DMZ     | 10.0.30.0/24 | Jump server and IDS         |
| OT Zone | 10.0.50.0/24 | PLC and HMI systems         |

## Components

* OpenPLC (PLC Runtime)
* HMI Client
* Jump Server / Bastion Host
* Suricata IDS
* Wazuh Manager
* IT Workstation

## Security Controls

* Network segmentation using Docker networks
* Industrial DMZ architecture
* iptables firewall rules
* Deny-all / allow-required-only policy
* Controlled OT access through jump server
* SSH hardening on bastion host
* Restricted Modbus communication

## Segmentation Tests

| Test                   | Expected Result | Status |
| ---------------------- | --------------- | ------ |
| IT → OT direct access  | Blocked         | PASS   |
| IT → PLC Modbus access | Blocked         | PASS   |
| IT → Jump Server SSH   | Allowed         | PASS   |
| Jump Server → PLC      | Allowed         | PASS   |
| OT → IT direct access  | Blocked         | PASS   |

## Result

The environment successfully demonstrated:

* Purdue-model segmentation
* Secure IT/OT separation
* Controlled OT access through DMZ
* Firewall enforcement with iptables
* Industrial network isolation principles

### Evidence

Screenshots included:

* Docker segmented environment
* Firewall rules
* Blocked IT/OT traffic
* SSH access to jump server
* PLC communication tests
* Segmentation verification

---

# 🔍 Part 3 — OT Monitoring and Zero Trust

This phase focused on implementing monitoring and security controls for the OT/ICS environment.

The environment consisted of segmented IT, DMZ, and OT networks where communication was routed through a secured jump server.

## Implemented Components

* Wazuh SIEM for centralized log collection and monitoring
* Suricata IDS for OT traffic inspection and detection
* Real-time monitoring dashboard for cross-zone visibility
* Zero Trust OT Gateway for controlled OT access
* Audit logging for OT commands and user activity
* Role-based access control for PLC operations

## Security Improvements

The project demonstrates how secure OT communication can be implemented using:

* Network segmentation
* IDS monitoring
* Centralized logging
* Controlled OT access
* Zero Trust principles
* Jump server architecture

---

# 🚨 Part 4 — Incident Response and OT Attack Simulation

This phase simulated attacks against the OT environment in order to test segmentation, access controls, monitoring, and incident response capabilities.

## Simulated OT Attack from the IT Zone

A Modbus TCP attack was executed from the IT workstation against the PLC in the OT zone.

The attack used unauthorized Modbus write commands to manipulate PLC registers and simulate process manipulation.

The attack demonstrated that direct communication between the IT zone and the OT zone was still possible in the initial configuration, highlighting the importance of stronger segmentation and firewall enforcement.

## Manipulated PLC Values

```text
PLC Registers: [999, 0, 0, 0, 0]
```

The manipulated values simulated:

* Dangerous tank level changes
* Unauthorized process control
* Potential industrial process disruption

---

# 📊 Step 17 — OT Traffic Detection via Suricata IDS

Suricata successfully captured and logged OT network traffic through `eve.json`, verifying that the IDS monitoring pipeline functioned correctly.

## Verified Capabilities

* Suricata IDS packet capture
* OT network flow logging
* Cross-zone traffic monitoring
* Real-time dashboard visibility
* PLC communication monitoring

---

# 🧯 Step 18 — Incident Response and Recovery

Incident response procedures were performed after the simulated OT attack.

## Actions Performed

* Isolation of the PLC environment
* Collection of IDS logs and access logs
* Preservation of forensic evidence
* Recovery of PLC values to safe defaults
* Verification of restored OT communication

## Evidence Collected

The following evidence was collected and stored:

* Suricata IDS logs
* Firewall rules
* OT access logs
* Network monitoring data
* Recovery verification output

---

# 📑 Step 19 — ICS-CERT Incident Report

An ICS-CERT-style incident report was created to document:

* Attack timeline
* Detection process
* Incident impact
* Recovery actions
* Root cause analysis
* Security recommendations

The report demonstrates structured OT incident handling and industrial cybersecurity documentation.

---

# 🖼️ Screenshots

The project contains screenshots verifying:

* OpenPLC runtime
* Docker OT networks
* Modbus TCP traffic
* IT/OT segmentation
* Firewall enforcement
* Suricata IDS detection
* Zero Trust OT gateway
* Incident response and recovery
* OT monitoring dashboard

---

# ✅ Summary

This project successfully demonstrated:

* ICS/SCADA simulation
* PLC runtime deployment
* OT network communication
* Modbus TCP analysis
* Packet capture and traffic inspection
* Purdue-model segmentation
* IT/OT separation
* Suricata IDS monitoring
* Wazuh SIEM integration
* Zero Trust access control
* OT attack simulation
* Incident response and recovery
* ICS-CERT incident reporting
* Real-time OT monitoring

The environment provides a strong foundation for future work involving:

* Advanced OT threat detection
* Custom Suricata rules
* Industrial anomaly detection
* IEC 62443 alignment
* Secure industrial architecture
* SOC and OT monitoring workflows

---

# 👨‍💻 Author

**Abdihakim**
DevOps & Cybersecurity Student
