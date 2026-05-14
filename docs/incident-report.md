# ICS-CERT Incidentrapport

## 1. Sammanfattning
- **Rapportdatum**: 2026-05-14
- **Rapportör**: Abdihakim
- **Incidenttyp**: Obehörig processmanipulering via Modbus TCP
- **Allvarlighetsgrad**: HÖG
- **Påverkade system**: OpenPLC Runtime (PLC), processtyrsystem
- **Status**: Löst

## 2. Incidentbeskrivning
En obehörig Modbus Write Single Register (FC 0x06) och Write Single Coil
(FC 0x05) detekterades mot PLC-systemet (10.0.50.10:502). Angriparen
manipulerade processparametrar:

- Tank_Level ändrades till 999 (farligt högt, normalt ~500)
- Pump_On tvingades till TRUE
- Valve_Open tvingades till FALSE

Kombinationen av dessa ändringar kunde i en verklig miljö orsaka
tanköverfyllnad och tryckuppbyggnad.

## 3. Detektion
- **Detektionstid**: 2026-05-14 11:10 UTC
- **Detektionsmetod**: Suricata IDS med OT-specifika regler
- **Kompletterande**: Zero Trust access-loggar verifierade aktivitet
- **Övervakning**: Real-time dashboard och network flow logging

## 4. Påverkan
- **Processäkerhet**: Potentiell fysisk skada (tanköverfyllnad)
- **Tillgänglighet**: PLC isolerades under incidentrespons
- **Konfidentialitet**: Processdata exponerad under rekognoscering
- **Integritet**: Registervärden manipulerade

## 5. Åtgärder vidtagna
1. Isolering av PLC via brandväggsregler
2. Insamling av IDS-loggar och access-loggar
3. Analys av attackväg och Modbus-trafik
4. Återställning av PLC till säkra standardvärden
5. Verifiering av OT-övervakning via Suricata IDS

## 6. Grundorsak
- Modbus TCP saknar autentisering och kryptering
- Direkt åtkomst till PLC möjliggjorde manipulation
- Segmentering och IDS behövde förstärkas för OT-miljön

## 7. Rekommendationer
1. Implementera Modbus/TCP Security (TLS)
2. Begränsa skrivkommandon till auktoriserade system
3. Använd vitlistning av Modbus-funktionskoder
4. Implementera redundant OT-övervakning
5. Genomför regelbunden granskning av brandväggsregler
6. Använd anomalidetektering för processövervakning

## 8. Lärdomar
- Segmentering mellan IT och OT är kritiskt
- Modbus TCP kräver kompletterande säkerhetskontroller
- Zero Trust förbättrar spårbarhet och åtkomstkontroll
- Realtidsövervakning ger bättre synlighet i OT-miljöer
- Incidentrespons kräver både tekniska och organisatoriska processer
