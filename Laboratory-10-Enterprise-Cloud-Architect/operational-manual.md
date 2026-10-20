CCM101 – Cloud Computing

Enterprise Cloud Architect – Operational Manual

Project: Secure Multi-Tier Web Application
Application Stack: WordPress + MySQL
Prepared by: Parino, Frankie M.
Section: BSIT 4 K
Instructor: Jenkielyn C. Torres
Date: October 2026

---

1. Project Overview

This operational manual documents the deployment, configuration, security, backup, and maintenance of a multi-tier web application using WordPress and MySQL. The application runs in Docker containers on Ubuntu Server hosted by Oracle VirtualBox.

The project demonstrates container deployment, database connectivity, network access, persistent database storage, firewall configuration, and automated database backups.

2. Infrastructure and Architecture

The infrastructure consists of the following components:

- Host machine: Windows laptop
- Hypervisor: Oracle VirtualBox
- Guest operating system: Ubuntu Server 24.04 LTS
- Container platform: Docker and Docker Compose
- Web application: WordPress
- Database: MySQL 8.0
- Firewall: UFW
- Persistent storage: Docker named volume "db_data"
- Backup storage: Separate disk mounted at "/mnt/backup"

Network Configuration

Purpose| Host Port| Guest Port
SSH| 2222| 22
Website HTTP| 8080| 80

The website is accessed from the host browser at:

"http://localhost:8080"

SSH access is available through:

ssh -p 2222 parinogroup@localhost

Architecture Diagram

The traffic flow is:

Windows Host → VirtualBox NAT Port Forwarding → Ubuntu Server → UFW Firewall → Docker WordPress Container → MySQL Container.

WordPress connects to MySQL through the Docker Compose service name "db" on port "3306". The database uses the named volume "db_data" to preserve data beyond the lifetime of an individual container.

Screenshot: Insert the actual architecture diagram as "architecture-diagram.png".

3. Docker Deployment

The project directory is:

"/home/parinogroup/ccm101-final-requirements"

The Docker Compose configuration defines two services:

- "db": MySQL 8.0 database server.
- "wordpress": WordPress web application.

The services use environment variables from a private ".env" file. Database credentials must not be committed to a public repository.

Start the application

cd ~/ccm101-final-requirements
docker compose up -d

Check service status

docker compose ps

Both the "db" and "wordpress" services should be running.

View service logs

docker compose logs wordpress
docker compose logs db

Open the website

Visit "http://localhost:8080" from the Windows host.

Screenshot: Insert the actual Docker Compose status and working WordPress website screenshots.

4. Database Connectivity and Persistent Storage

The database uses the Docker named volume "db_data", mounted at "/var/lib/mysql".

To list Docker volumes:

docker volume ls

To inspect a volume, use the exact volume name shown by the previous command:

docker volume inspect VOLUME_NAME

The database should remain available after a normal container restart or Ubuntu reboot.

Important: Do not use "docker compose down -v" unless deleting the database volume is intentional and the data has been safely backed up.

5. Security Configuration

UFW is used to manage incoming connections to Ubuntu Server.

The project allows SSH and HTTP traffic through the configured firewall rules.

sudo ufw status verbose

The expected allowed ports are TCP 22 for SSH and TCP 80 for HTTP.

The default incoming policy must be verified. If the requirement is to deny incoming connections by default, inspect the current rules before changing them:

sudo ufw status verbose

Only apply the following if the current configuration has been reviewed and SSH access is confirmed:

sudo ufw default deny incoming
sudo ufw default allow outgoing

Do not expose MySQL port 3306 to the public network unnecessarily. Keep database credentials private and do not upload ".env" to GitHub.

6. Automated Database Backup

The backup script is stored at:

"/usr/local/bin/wordpress-backup.sh"

The separate backup disk is mounted at:

"/mnt/backup"

The script exports the WordPress database to a timestamped SQL file. It checks that the generated file is not empty before reporting success.

Run a manual backup

sudo /usr/local/bin/wordpress-backup.sh

List backup files

sudo ls -lh /mnt/backup

View the backup log

sudo cat /var/log/wordpress-backup.log

A successful backup produces a message similar to:

"Backup successful: /mnt/backup/wordpress_DATE.sql"

The actual filename contains the date and time of the backup.

The script should be reviewed whenever the database service name or backup disk location changes.

7. Cron Automation

The root user's Cron schedule runs the backup script daily at 2:00 AM.

The configured entry is:

0 2 * * * /usr/local/bin/wordpress-backup.sh >> /var/log/wordpress-backup.log 2>&1

To inspect the root Cron schedule:

sudo crontab -l

To check the Cron service:

systemctl is-active cron

The Cron service should report "active". The backup log and the timestamped SQL file can be checked to verify scheduled execution.

8. Database Restoration

The restoration script is located at:

"/home/parinogroup/restore.sh"

Before restoring a database, confirm that the chosen SQL file exists and that the current database has a separate backup if its contents must be preserved.

List the available backups:

sudo ls -lh /mnt/backup

The restoration script accepts a backup path, requests confirmation, and imports the SQL file into the database.

Example command:

sudo /home/parinogroup/restore.sh /mnt/backup/wordpress_BACKUP-FILENAME.sql

Use the actual backup filename. Proceed only after confirming that the file is correct and that importing it will not cause unwanted data loss.

The script's syntax was checked. A full restoration test must be recorded as completed only after the restore has been performed and the database and website have been verified.

9. Maintenance Commands

Command| Purpose
"docker compose ps"| Check container status
"docker compose logs wordpress"| Review WordPress logs
"docker compose logs db"| Review MySQL logs
"docker volume ls"| List Docker volumes
"sudo ufw status verbose"| Inspect firewall rules
"sudo crontab -l"| Inspect root Cron schedule
"systemctl is-active cron"| Check Cron service
"df -h"| Check disk space
"sudo ls -lh /mnt/backup"| Inspect backup files
"sudo cat /var/log/wordpress-backup.log"| Review backup log

Safe shutdown

Stop the application without deleting the named volume:

cd ~/ccm101-final-requirements
docker compose down

Start it again with:

docker compose up -d

Avoid "docker compose down -v" unless removing persistent data is intentional.

10. Troubleshooting

Problem| Suggested action
Website does not load| Check VirtualBox port forwarding and run "docker compose ps".
WordPress shows an error| Inspect WordPress and database logs.
MySQL connection fails| Check container status and private environment configuration.
Backup script fails| Check Docker service names, backup disk mount, and log output.
Backup file is empty| Do not treat it as valid; investigate the error and rerun the backup.
Cron backup does not run| Check "sudo crontab -l", Cron service status, and the backup log.
Disk space is low| Run "df -h" and review backup retention.
Restore is needed| Verify the backup file and protect the current database before importing.

11. Verification Status

The following items were verified during project work:

- WordPress and MySQL containers were running.
- The database backup script completed successfully.
- A timestamped SQL backup file was created on "/mnt/backup".
- The Cron schedule was saved for 2:00 AM daily.
- The Cron service reported "active".
- The backup log contained a successful scheduled backup entry.
- The backup SQL file was approximately 935 KB.
- The restoration script passed a Bash syntax check.

A full database restoration test should be performed and documented separately. Firewall default policy and the final GitHub repository contents should also be checked before submission.

12. Conclusion

This project demonstrates the deployment and management of a multi-tier WordPress and MySQL application using Docker Compose on Ubuntu Server hosted by Oracle VirtualBox.

The project includes persistent database storage, firewall configuration, and a Bash script that backs up the database to a separate disk. Cron is configured to run the backup automatically every day at 2:00 AM.

The documented verification results distinguish completed tests from tasks that still require confirmation. This provides a practical operational reference for deployment, security, maintenance, and recovery.

Appendix: Required Screenshots

Insert actual screenshots from the project environment:

1. VirtualBox network and port-forwarding configuration.
2. Docker Compose services running.
3. Working WordPress website.
4. Database connectivity or volume verification.
5. UFW firewall status.
6. Successful backup command and SQL file.
7. Root Cron schedule and active Cron service.
8. Backup log showing a successful scheduled run.
9. Restore script syntax-check result.
10. Containers running after a reboot.

Do not include passwords, private keys, or other sensitive information in screenshots or public files.
