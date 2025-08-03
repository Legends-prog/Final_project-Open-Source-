# Final_project-Open-Source-
A project on Open Source Log analysis and Alert System

This project consists of a shell script ('analyze_logs.sh') that monitors system logs ('/var/logs/auth.log') for failed logins attempts and other errors. 
The script performs the following actions:
– Analyze '/var/log/auth.log' for keywords like "failed password" and "error".
– Generate a daily report at '~/myproject/docs/log_report.txt'.
– Logs its own execution status to '~/myproject/logs/analyze.log'.
– Send an email alert to the system administrator if any issues are found.

This system is automated using a cron job to run once every day
