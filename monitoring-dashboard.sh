#!/bin/bash
# OT Monitoring Dashboard — Labb 2
# Visar realtidsövervakning av IT/OT-gränsen

SURICATA_LOG="$HOME/labb2-ics/suricata/logs/eve.json"
SURICATA_FAST="$HOME/labb2-ics/suricata/logs/fast.log"

clear
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║           OT SÄKERHETSÖVERVAKNING — DASHBOARD               ║"
echo "║           $(date '+%Y-%m-%d %H:%M:%S')                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# --- Suricata-alerter ---
echo "┌── SURICATA IDS ALERTER (senaste 10) ──────────────────────┐"
if [ -f "$SURICATA_LOG" ]; then
  jq -r 'select(.event_type=="alert") |
    "\(.timestamp | split("T")[1] | split(".")[0]) [\(.alert.severity)] \(.alert.signature) | \(.src_ip) → \(.dest_ip)"' \
    "$SURICATA_LOG" 2>/dev/null | tail -10
  echo ""
  echo "  Totalt antal alerter: $(jq -r 'select(.event_type=="alert")' "$SURICATA_LOG" 2>/dev/null | wc -l)"
else
  echo "  Inga alerter registrerade ännu"
fi
echo "└──────────────────────────────────────────────────────────────┘"
echo ""

# --- Modbus-trafik ---
echo "┌── MODBUS-TRAFIK (senaste 5 min) ──────────────────────────┐"
if [ -f "$SURICATA_LOG" ]; then
  echo "  Modbus-flöden: $(jq -r 'select(.event_type=="flow" and .app_proto=="modbus")' "$SURICATA_LOG" 2>/dev/null | wc -l)"
  echo "  Write-kommandon: $(jq -r 'select(.event_type=="alert" and (.alert.signature | contains("Write")))' "$SURICATA_LOG" 2>/dev/null | wc -l)"
fi
echo "└──────────────────────────────────────────────────────────────┘"
echo ""

# --- Cross-zone trafik ---
echo "┌── CROSS-ZONE TRAFIK ──────────────────────────────────────┐"
echo "  IT → OT (direkt):  $(jq -r 'select(.src_ip | startswith("10.0.10.")) | select(.dest_ip | startswith("10.0.50."))' "$SURICATA_LOG" 2>/dev/null | wc -l) paket"
echo "  IT → DMZ:          $(jq -r 'select(.src_ip | startswith("10.0.10.")) | select(.dest_ip | startswith("10.0.30."))' "$SURICATA_LOG" 2>/dev/null | wc -l) paket"
echo "  DMZ → OT:          $(jq -r 'select(.src_ip | startswith("10.0.30.")) | select(.dest_ip | startswith("10.0.50."))' "$SURICATA_LOG" 2>/dev/null | wc -l) paket"
echo "  OT → DMZ:          $(jq -r 'select(.src_ip | startswith("10.0.50.")) | select(.dest_ip | startswith("10.0.30."))' "$SURICATA_LOG" 2>/dev/null | wc -l) paket"
echo "└──────────────────────────────────────────────────────────────┘"
echo ""

# --- Systemstatus ---
echo "┌── SYSTEMSTATUS ───────────────────────────────────────────┐"
for container in plc-runtime hmi-client jump-server suricata-ids wazuh-manager it-workstation; do
  status=$(docker inspect -f '{{.State.Status}}' "$container" 2>/dev/null || echo "ej hittad")
  if [ "$status" = "running" ]; then
    echo "  ✓ $container: AKTIV"
  else
    echo "  ✗ $container: $status"
  fi
done
echo "└──────────────────────────────────────────────────────────────┘"


