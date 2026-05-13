# Nätverkstopologi — Purdue-modellen

## Zoner och subnät

| Zon | Purdue-nivå | Subnät | VLAN |
|---|---|---|---|
| IT-zon | 4-5 | 10.0.10.0/24 | 10 |
| DMZ | 3 | 10.0.30.0/24 | 30 |
| OT-zon | 0-2 | 10.0.50.0/24 | 50 |

---

## Komponenter

### IT-zon
- IT Workstation
- Wazuh Manager

### DMZ
- Jump Server
- Suricata IDS

### OT-zon
- OpenPLC Runtime
- HMI Client

---

## Tillåtna trafikflöden

- IT → DMZ: SSH (22)
- DMZ → OT: Modbus TCP (502)
- OT → DMZ: Syslog (514)
- DMZ → IT: Alerts och loggar
- IT → OT direkt: BLOCKERAD
- OT → IT direkt: BLOCKERAD
- Internet → OT: BLOCKERAD

---

## Säkerhetsmål

- Segmentera OT från IT
- Begränsa lateral movement
- Centralisera OT-åtkomst via jump server
- Övervaka OT-trafik med IDS
- Implementera Zero Trust-principer
