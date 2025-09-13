# FMS Offseason Companion (BETA)

The TBA/FMS Offseaon Companion is a Docker container that runs on the FTA Toughbook, integrates with FMS, and performs data sync to TBA.

**Note:** For 2025 Offseason Events, the Companion is in a limited beta. If you are interested in using this, reach out in FTA Slack for more.

## Container Installation


### With Internet

 1. Download and extract the latest release source code 
 2. Open a Powershell terminal and navigate to that directory
 3. Run `docker-compose up` to launch the Companion

### Without Internet

**Before the Event**
 1. Download and extract the latest release source code
 2. Download the `tba-offseason-companion-image.tar` artifact from the release
 3. Copy these files onto a flash drive and bring it with you to the event

**At the Event**
 1. Copy the files from above onto the Toughbook
 2. Open a Powershell terminal and navigate to the new files
 3. Run `docker load --input .\tba-offseason-companion-image.tar`
 4. Run `docker-compose up` to launch the Companion

## Setup

The web UI will be available on the Toughbook at http://localhost:6001

*Protip: You can get the IP Address of the Toughbook by running `ipconfig` in PowerShell. Then, you can navigate to `http:///${TOUGHBOOK_IP}:6001` from the field server, if you'd like the Scorekeeper to operate the Companion*

## Authentication

On the main page, you will need to enter:
 - your TBA Trusted API Key & Secret
 - your FTA API Username & Secret (these are the same credentials used for the FTA Notepad App)
