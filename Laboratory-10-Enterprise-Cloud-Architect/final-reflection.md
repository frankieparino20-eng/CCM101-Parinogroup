CCM101 – Cloud Computing

Laboratory 10: The Enterprise Cloud Architect

Final Reflection

Prepared by: Parino, Frankie M.
Section: BSIT 4 K
Instructor: Jenkielyn C. Torres

Reflection

Through this project, I learned how to deploy and manage a multi-tier web application using Docker and Docker Compose on Ubuntu Server. I gained practical experience running WordPress and MySQL in separate containers and connecting them through a Docker service network.

I also learned the importance of persistent database storage, firewall configuration, and protecting sensitive credentials. Using a separate backup disk, I created a Bash script that exports the WordPress database into timestamped SQL files. I configured Cron to run the backup automatically every day at 2:00 AM and verified that a scheduled backup file was generated successfully.

One challenge was troubleshooting the database backup process and ensuring that the script used the correct database configuration. Checking the script output, backup file size, and log helped me verify that the backup completed successfully.

This project taught me that deploying an application is not only about making the website work. It is also important to secure the server, preserve data, automate maintenance, and document the procedures clearly.

The restoration script passed a syntax check, but a complete database restoration test still needs to be performed. This reminded me that recovery procedures should be tested before they are considered fully reliable.

Overall, this activity improved my understanding of cloud infrastructure, containerization, database administration, security, automation, and technical documentation. These skills will help me maintain applications more safely and efficiently in future projects.
