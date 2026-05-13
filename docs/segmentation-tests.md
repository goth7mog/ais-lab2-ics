# Segmenteringstester

| Test | Källa | Mål | Port | Förväntat | Resultat |
|------|-------|-----|------|-----------|----------|
| 1 | IT (10.0.10.50) | PLC (10.0.50.10) | ICMP | BLOCKERAD | PASS |
| 2 | IT (10.0.10.50) | PLC (10.0.50.10) | 502 | BLOCKERAD | PASS |
| 3 | IT (10.0.10.50) | Jump (10.0.30.10) | 22 | TILLÅTEN | PASS |
| 4 | Jump (10.0.30.10) | PLC (10.0.50.10) | 502 | TILLÅTEN | PASS |
| 5 | HMI (10.0.50.20) | IT (10.0.10.50) | ICMP | BLOCKERAD | PASS |

## Slutsats

Nätverkssegmenteringen enligt Purdue-modellen fungerar korrekt.

- Direkt trafik mellan IT och OT blockeras
- All OT-access sker via jump server i DMZ
- Modbus TCP tillåts endast genom auktoriserad väg
- Brandväggsregler implementerar "deny all, allow required only"

Miljön demonstrerar grundläggande industriell nätverkssegmentering och säker OT-access.
