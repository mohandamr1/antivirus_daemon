# Antivirus Daemon

Basic antivirus daemon that scans a specified directory for a list of keywords/extensions and quarantines them in a malicious directory from which they 
can be restored or deleted. Can either be ran periodically by running the cron version as a cronjob or running the default version directly from the makefile.

## Folder structure

```
antivirus_daemon/
|─ antivirusd.sh      (main script)
├── antivirus-cron.sh  (main script, cron version)
├── restore.sh         (restore script)
├── Makefile           
├── README.md
├── whitelist.txt      (whitelisted files)
└── malicious_dir/     (quarantine folder)
```


## Prerequisites

- bash (preinstalled on Ubuntu)
- make: `sudo apt install make`
- cron: `sudo apt install cron`

## Running it

1. Clone the repo and `cd` into it.
2. Make the scripts executable: `chmod +x *.sh`
3. Start the antivirus: `make run DIR= (Absolute path of directory)`
4. Restore quarantined files: `make restore`
5. To change the interval between each scans: `make run DIR=... INTERVAL=...`

## Flagged extensions and keywords

These are defined in `antivirusd.sh` on lines 15 to 16, in the variables
`virusExtensions` and `virusWord` and lines 8 to 9 in `antivirus-cron.sh`.

## Whitelist functionality

Files restored by running `make restore` are placed in `whitelist.txt` and are skipped each scan before being quarantined.

## Cron Job

### Prerequisites
- cron installed and running: `sudo apt install cron`, then `sudo systemctl enable --now cron`
- `chmod +x antivirus-cron.sh`
- `dir/` and `malicious_dir/` exist

### Setup
1. Run `crontab -e` (choose nano).
2. Add this line at the bottom:
```
   * * * * * sleep 23; /home/ubuntu/antivirus_daemon/antivirus-cron.sh
```
3. Save and exit, then check with `crontab -l`.

Cron runs it every minute, and `sleep 23` makes the scan start at second 23. 

### 3rd Friday of the month at 12:31 a.m.
```
31 12 * * 5 [ "$(date +\%d)" -ge 15 ] && [ "$(date +\%d)" -le 21 ] && /home/ubuntu/antivirus_daemon/antivirus-cron.sh
```
Cron treats day-of-month and day-of-week as "either one", so the job fires every Friday and the command only continues if the date is 15 to 21, which is always the third Friday.
