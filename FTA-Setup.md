# FTA Setup

## Container Installation

### With Internet

 1. Download and extract the latest release source code from the [releases page](https://github.com/the-blue-alliance/fms-companion-dist/releases) (under the "Assets" drop down)
 2. Open the Docker Desktop application to initialize Docker
 3. Open a Powershell terminal and navigate to that directory
 4. Run `docker-compose up` to launch the Companion and navigate to http://localhost:6001

### Without Internet

**Before the Event**
 1. Download and extract the latest release source code from the [releases page](https://github.com/the-blue-alliance/fms-companion-dist/releases) (under the "Assets" drop down)
 2. Download the `tba-offseason-companion-image-linux-amd64.tar` release artifact, as well. (If you have an Apple Silicone Mac, download  `tba-offseason-companion-image-linux-arm64.tar` instead)
 3. Copy these files onto a flash drive and bring it with you to the event

**At the Event**
 1. Copy the files from above onto the Toughbook
 2. Open the Docker Desktop application to initialize Docker
 3. Open a Powershell terminal and navigate to the new files
 4. Run `docker load --input .\tba-offseason-companion-image.tar`
 5. Run `docker-compose up` to launch the Companion and navigate to http://localhost:6001

## Setup

The web UI will be available on the Toughbook at http://localhost:6001

*Protip: You can get the IP Address of the Toughbook by running `ipconfig` in PowerShell. Then, you can navigate to `http:///${TOUGHBOOK_IP}:6001` from the field server, if you'd like the Scorekeeper to operate the Companion*

## Authentication

On the main page, you will need to enter:
 - your TBA Trusted API Key & Secret
 - your FTA API Username & Secret (these are the same credentials used for the FTA Notepad App)
