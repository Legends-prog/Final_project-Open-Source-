#!/usr/bin/env bash
#analyze_logs.sh
#sample daily log analysis script with email alerts.

#configuration
AUTH_LOG="/var/log/auth.log"
SYS_LOG="/var/log/syslog"
REPORT_FILE="$HOME/myproject/docs/log_report.txt"
EXEC_LOG="$HOME/myproject/logs/analyze.log"
ALERT_USER="USER"

#Ensure log directories exist
mkdir -p "$(dirname "$EXEC_LOG")"
mkdir -p "$(dirname "$REPORT_FILE")"

timestamp() {
  date '+%Y-%m-%H:%M:%S'
}

log() {
  echo "[$(timestamp)] $1" >> "$EXEC_LOG"
}

#Analyze authentication failures
analyze_auth_log() {
  echo "=== Authentication Failures ===" > "$REPORT_FILE"
  grep -i "failed password" "$AUTH_LOG" >>  "$REPORT_FILE" || echo "NO auth failures." >> "$REPORT_FILE"
}

analyze_syslog() {
  echo -e "\n=== system errors ===" >> "$REPORT_FILE"
  grep -i "error" "$SYS_LOG" | grep -v "alert email" | tail -n 10 >> "$REPORT_FILE" || "NO system errors," "$REPORT_FILE" 
}
# send email alert if report contains any entries
send_email_alert() {
   SUBJECT="System log alert from $(hostname)"
   TO_USER="$USER"
	if grep -qi "failed password\|errors" "$REPORT_FILE"; then
		cat "$REPORT_FILE" | mail -s "$SUBJECT" "$TO_USER"
		log "local email sent to $TO_USER"
	else
		log "No issues detected; no email sent"
	fi
}


#main"
log "script started"
analyze_auth_log
analyze_syslog
send_email_alert
log "script finished"
