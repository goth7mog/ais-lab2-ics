#!/bin/bash
# OT Monitoring Dashboard — Lab 2
# Shows real-time monitoring of the IT/OT boundary

SURICATA_LOG="$HOME/labb2-ics/suricata/logs/eve.json"
SURICATA_FAST="$HOME/labb2-ics/suricata/logs/fast.log"

clear
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║           OT SECURITY MONITORING — DASHBOARD                ║"
echo "║           $(date '+%Y-%m-%d %H:%M:%S')                              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# --- Suricata alerts ---
echo "┌── SURICATA IDS ALERTS (latest 10) ───────────────────────┐"
if [ -f "$SURICATA_LOG" ]; then
  jq -r 'select(.event_type=="alert") |
    "\(.timestamp | split("T")[1] | split(".")[0]) [\(.alert.severity)] \(.alert.signature) | \(.src_ip) → \(.dest_ip)"' \
    "$SURICATA_LOG" 2>/dev/null | tail -10
  echo ""
  echo "  Total number of alerts: $(jq -r 'select(.event_type=="alert")' "$SURICATA_LOG" 2>/dev/null | wc -l)"
else
  echo "  No alerts registered yet"
fi
echo "└──────────────────────────────────────────────────────────────┘"
echo ""

# --- Modbus traffic ---
echo "┌── MODBUS TRAFFIC (last 5 min) ───────────────────────────┐"
if [ -f "$SURICATA_LOG" ]; then
  echo "  Modbus flows: $(jq -r 'select(.event_type=="flow" and .app_proto=="modbus")' "$SURICATA_LOG" 2>/dev/null | wc -l)"
  echo "  Write commands: $(jq -r 'select(.event_type=="alert" and (.alert.signature | contains("Write")))' "$SURICATA_LOG" 2>/dev/null | wc -l)"
fi
echo "└──────────────────────────────────────────────────────────────┘"
echo ""

# --- Cross-zone traffic ---
echo "┌── CROSS-ZONE TRAFFIC ────────────────────────────────────┐"
echo "  IT → OT (direct):   $(jq -r 'select(.src_ip | startswith("10.0.10.")) | select(.dest_ip | startswith("10.0.50."))' "$SURICATA_LOG" 2>/dev/null | wc -l) packets"
echo "  IT → DMZ:           $(jq -r 'select(.src_ip | startswith("10.0.10.")) | select(.dest_ip | startswith("10.0.30."))' "$SURICATA_LOG" 2>/dev/null | wc -l) packets"
echo "  DMZ → OT:           $(jq -r 'select(.src_ip | startswith("10.0.30.")) | select(.dest_ip | startswith("10.0.50."))' "$SURICATA_LOG" 2>/dev/null | wc -l) packets"
echo "  OT → DMZ:           $(jq -r 'select(.src_ip | startswith("10.0.50.")) | select(.dest_ip | startswith("10.0.30."))' "$SURICATA_LOG" 2>/dev/null | wc -l) packets"
echo "└──────────────────────────────────────────────────────────────┘"
echo ""

# --- System status ---
echo "┌── SYSTEM STATUS ──────────────────────────────────────────┐"
for container in plc-runtime hmi-client jump-server suricata-ids wazuh-manager it-workstation; do
  status=$(docker inspect -f '{{.State.Status}}' "$container" 2>/dev/null || echo "ej hittad")
  if [ "$status" = "running" ]; then
    echo "  ✓ $container: ACTIVE"
  else
    echo "  ✗ $container: $status"
  fi
done
echo "└──────────────────────────────────────────────────────────────┘"


