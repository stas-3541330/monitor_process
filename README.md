# Process Monitor

A Linux bash script that monitors a specified process and interacts with a monitoring API. The script checks if the process is running, reports to a monitoring server via HTTPS, and logs important events.

## Features

- Monitors a specific process on Linux systems
- Automatically starts at system boot (via systemd)
- Runs every minute
- Reports to a monitoring API when the process is running
- Logs process restarts and monitoring server unavailability
- Configurable through a .conf file

## Installation Requirements

- Linux system with systemd
- curl utility for HTTP requests
- make utility for installation

## Configuration

Before installation, you need to set up the configuration file:

1. Copy the example configuration file to create your own:
   cp monitor_process.conf.example monitor_process.conf

2. Edit the configuration file to match your requirements:
   nano monitor_process.conf

### Configuration Options

| Parameter | Description | Example |
|-----------|-------------|---------|
| DEBUG | Debug mode flag (1=enabled, 0=disabled) | DEBUG=0 |
| API_URL_DEBUG | API URL for debug mode | API_URL_DEBUG="http://127.0.0.1:8080/monitoring/test/api" |
| API_URL_PROD | API URL for production mode | API_URL_PROD="https://test.com/monitoring/test/api" |
| PROCESS_NAME | Name of the process to monitor | PROCESS_NAME="test" |
| LOG_FILE | Log file path | LOG_FILE="/var/log/monitoring.log" |

## Installation

All commands should be run as root or with sudo:

### Install the script and systemd files. Start the service.
```bash
sudo make install
sudo make start
```

## Usage

Once installed and started, the script will run automatically:

- Every minute, it checks if the monitored process is running
- If the process is running, it sends a request to the configured API
- If the process was restarted, it logs the event
- If the monitoring server is unavailable, it logs the error

### Management Commands

| Parameter | Description                                            | Example              |
|-----------|--------------------------------------------------------|----------------------|
| install   | install the script and systemd files                   | `sudo make install`  |
| start     | start the monitoring service                           | `sudo make start`    |
| stop      | stop the monitoring service                            | `sudo make stop`     |
| clear     | completely remove the monitoring service and its files | `sudo make clear`    |

## Log Monitoring

You can monitor the logs at any time:

Example:
```bash
tail -f /var/log/monitoring.log  # Default log file location
```
