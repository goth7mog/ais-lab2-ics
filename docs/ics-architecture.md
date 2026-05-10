# ICS Architecture - Lab 2

## Components

| Component | Role | IP Address | Port | Protocol |
|-----------|------|------------|------|-----------|
| OpenPLC | PLC Runtime | 10.0.50.10 | 502 | Modbus TCP |
| HMI Client | Simulated HMI | 10.0.50.20 | Dynamic | Modbus TCP |

## Communication Flow

- HMI client polls the PLC every second
- Communication uses Modbus TCP over port 502
- Traffic is unencrypted and unauthenticated

## Security Observations

1. Modbus TCP lacks encryption
2. No authentication between HMI and PLC
3. OT traffic is readable in plaintext
4. Continuous polling behavior observed
5. PLC services exposed internally on OT network



# ICS-arkitektur — Labb 2

## Komponenter

| Komponent   | Roll             | IP-adress   | Port | Protokoll   |
|-------------|------------------|-------------|------|-------------|
| OpenPLC     | PLC Runtime      | 10.0.50.10 | 502  | Modbus TCP  |
| HMI Client  | Simulerad HMI    | 10.0.50.20 | Dynamisk | Modbus TCP |

---

## Kommunikationsflöden

- HMI Client → OpenPLC: Modbus TCP (port 502), polling av register varje sekund
- Operatör → OpenPLC: HTTP (port 8080), programuppladdning och konfiguration
- Modbus-trafik fångades och analyserades med tcpdump

---

## Identifierad attackyta

1. Modbus TCP saknar autentisering
2. Modbus-trafik är okrypterad (plaintext)
3. OpenPLC webbgränssnitt exponeras utan TLS
4. Standardlösenord används i OpenPLC
5. Ingen nätverkssegmentering mellan OT-komponenter
6. Ingen IDS/övervakning aktiv ännu
7. PLC-register kan läsas från nätverket utan åtkomstkontroll

---

## Observerad OT-trafik

- Kommunikation observerades mellan:
  - 10.0.50.20 → 10.0.50.10
- Port 502 användes för Modbus TCP
- Kontinuerlig polling observerades ungefär varje sekund
- Trafiken analyserades med tcpdump och PCAP-filer

---

## Säkerhetsreflektion

Modbus TCP designades för isolerade industriella nätverk och saknar moderna säkerhetsfunktioner såsom:
- kryptering
- autentisering
- integritetsskydd

Det gör OT-miljöer känsliga för:
- obehörig registerläsning
- manipulation av PLC-värden
- nätverksbaserade attacker
- lateral movement inom OT-zonen
