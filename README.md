#TechCore Infrastructure Monitor

## Overview
 
 TechCore Infrastructure Monitor is a Linux-based server monitoring platform built on Ubuntu server 24.04 LTS.

 The project collects important system health information suxh as CPU usage, memory usage, dish usage, uptime, network information, and serverstatus, 
 then displays the collected data through a web dashboard served using Nginx.

 This project was built to practise Linux System administration, Bash scripting, automation, networking concepts, and sever monitoring fundamentals.

## Features

- CPU usage monitoring
- Memory usage monitoring
- Disk space monitoring
- Server uptime tracking
- IP address and network information display
- SSH service health monitoring
- Nginx service health monitoring
- Automated dashboard updates using cron jobs
- Bash-based system information collection
- Web-based server health dashboard

## Technologies Used
 
 |    Component	     |	 Technology	             |
 |-------------------|--------------------------|
 | Operating System  |  Ubuntu Server 24.04 LTS |
 | Scripting	        |	 Bash		                  | 		
 | Web Server	       |	Nginx	       	           |
 | Wed technologies  |	HTML,CSS       	         |	
 | Automation  	     | 	Cron Jobs      	        |
 | Version Control   |	Git & Github	            |	
 | Virtualization    | 	VirtualBox	             |

## Project Structure
```
TechCore-monitor/
│
├── css/
│   └── style.css
│
├── scripts/
│   └── server_health.sh
│
└── templates/
    └── dashboard.html
```

## Directory Description

**scripts/**  
Contains the Bash script responsible for collecting server health information such as CPU usage, memory usage, disk usage, uptime, network details, and service status.

**templates/**  
Contains the HTML dashboard used to display the collected server information.

**css/**  
Contains the styling file used to improve the dashboard presentation.

## How It Works

```
Ubuntu Server VM
        |
        |
server_health.sh
        |
        |
Collect System Information
        |
        |
Generate Dashboard Output
        |
        |
Nginx Web Server
        |
        |
Web Browser
```

The Bash monitoring script collects system metrics from the Linux server and generates the dashboard information.

Nginx serves the dashboard webpage, allowing users to view the current health status of the server.

## Automation

The project uses cron jobs to automatically execute the monitoring script at scheduled intervals.

Example:

```
*/5 * * * * /path/to/server_health.sh
```

This allows the dashboard information to update automatically without manually running the script.

## Setup Instructions

Clone the repository:

```
git clone git@github.com:sasidhar4711/TechCore-Infrastructure-Monitor.git
```

Navigate to the project directory:

```
cd TechCore-monitor
```

Give script execution permission:

```
chmod +x scripts/server_health.sh
```

Run monitoring script:

```
./scripts/server_health.sh
```

## Skills Demonstrated

- Linux Server Administration
- Bash Scripting
- File and Permission Management
- Process and Service Management
- Networking Fundamentals
- Nginx Configuration
- Cron Automation
- Git Version Control
- SSH Authentication

## Future Improvements

- Add historical monitoring data storage
- Add CPU and memory graphs
- Add alert notifications
- Add authentication for dashboard access
- Integrate advanced monitoring tools such as Prometheus and Grafana









