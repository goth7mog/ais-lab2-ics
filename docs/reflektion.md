Reflektion

Under denna labb har en komplett OT/ICS-säkerhetsmiljö designats, implementerats och analyserats med fokus på industriell cybersäkerhet, nätverkssegmentering och incidenthantering. Syftet med projektet var att simulera en modern industriell miljö där IT- och OT-system separeras enligt Purdue-modellen för att minska attackytan och förbättra säkerheten i kritisk infrastruktur.

Miljön byggdes upp med hjälp av Docker och bestod av flera separerade zoner: en IT-zon, en DMZ-zon och en OT-zon. I OT-zonen implementerades OpenPLC som simulerad PLC samt en HMI-klient som kommunicerade över Modbus TCP. Genom denna miljö kunde industriell nätverkstrafik analyseras och säkerhetsrisker identifieras i ett kontrollerat labbscenario.

En viktig del av projektet var att implementera nätverkssegmentering och kontrollerad åtkomst mellan zonerna. Detta genomfördes med hjälp av Docker-nätverk, brandväggsregler och en jump server i DMZ-zonen som fungerade som den enda auktoriserade åtkomstpunkten till OT-miljön. Genom segmenteringstester verifierades att direkt trafik mellan IT och OT kunde begränsas och att åtkomst till PLC-system endast kunde ske via kontrollerade kommunikationsvägar.

Projektet inkluderade även implementation av säkerhetsövervakning och detektion. Suricata IDS användes för att övervaka nätverkstrafik och analysera Modbus-kommunikation medan Wazuh SIEM implementerades för central logginsamling och säkerhetsövervakning. En realtidsdashboard byggdes för att visualisera cross-zone-trafik, nätverksflöden och säkerhetshändelser i OT-miljön.

För att simulera realistiska hot genomfördes attacker mot PLC-miljön där obehöriga Modbus write-kommandon användes för att manipulera registervärden och processparametrar. Attackerna demonstrerade tydligt de säkerhetsrisker som finns i äldre industriella protokoll som saknar autentisering och kryptering. Samtidigt visade labben hur övervakning, segmentering och kontrollerad åtkomst kan användas för att förbättra säkerheten i industriella miljöer.

En stor del av arbetet fokuserade även på incidentrespons och återställning. Under incidenthanteringen isolerades PLC-systemet, loggar och bevismaterial samlades in och PLC:n återställdes till säkra standardvärden. En incidentrapport skapades enligt ICS-CERT-format för att dokumentera attackförlopp, påverkan, detektion och åtgärder.

Genom projektet har flera viktiga lärdomar identifierats. Det blev tydligt att segmentering mellan IT och OT är avgörande för att begränsa attacker mot industriella system. Labben visade även att Modbus TCP saknar inbyggda säkerhetsmekanismer och därför kräver kompletterande skydd såsom brandväggar, IDS och Zero Trust-principer. Realtidsövervakning med Suricata och Wazuh gav bättre synlighet i OT-miljön och förbättrade möjligheterna att identifiera avvikande trafik och potentiella attacker.

Sammanfattningsvis gav labben en praktisk förståelse för hur moderna OT/ICS-miljöer skyddas genom segmentering, övervakning, incidentrespons och kontrollerad åtkomst. Projektet demonstrerar både tekniska och organisatoriska säkerhetsprinciper som används för att skydda industriella system och kritisk infrastruktur mot cyberhot.
