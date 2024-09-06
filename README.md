# spark-install-windows
Apache-spark installation script for Windows. This script is customized for IEOR 4526 Analytics on the Cloud offered by Columbia University.

# Windows WSL Ubuntu Spark Setup Instructions

Follow these steps to set up Apache Spark on your Windows machine using Windows Subsystem for Linux (WSL) with Ubuntu. This script is hosted on GitHub for easy access and updates.

## Prerequisites

- Windows 10 version 2004 and higher (Build 19041 and higher) or Windows 11
- Administrator privileges on your Windows machine
- Internet connection

## Installation Steps

1. Download the installation script:
   - Open PowerShell as Administrator:
     - Right-click on the Start button
     - Select "Windows PowerShell (Admin)"
   - Run the following command to download the script directly from GitHub:
     ```powershell
     Invoke-WebRequest -Uri "https://raw.githubusercontent.com/x1linwang/spark-install-windows/main/windows-wsl-spark-setup.ps1" -OutFile "$env:USERPROFILE\Desktop\windows-wsl-spark-setup.ps1"
     ```
2. Navigate to the script location:
   ```powershell
   cd $env:USERPROFILE\Desktop
   ```

3. Run the script:
   ```powershell
   .\windows-wsl-spark-setup.ps1
   ```

4. Follow the on-screen instructions:
   - If WSL or Ubuntu is not installed, the script will install them and prompt you to restart your computer. After restarting, run the script again.
   - When prompted, set up your Ubuntu username and password.
   - The script will then install Homebrew, Java, Scala, Apache Spark, and Anaconda in your Ubuntu environment.

5. After the script completes, close all Ubuntu windows and open a new one.

6. To start using Jupyter Notebook, run:
   ```bash
   jupyter notebook --no-browser
   ```

7. Copy the URL from the terminal and paste it into your web browser to access Jupyter Notebook.

## Verifying the Installation

1. In Jupyter Notebook, create a new notebook using the spylon-kernel.
2. In a cell, type and run:
   ```scala
   val x = 1
   ```
3. If you see `x: Int = 1` in the output, your setup is complete!

## Troubleshooting

- If you encounter any "command not found" errors, try closing and reopening your Ubuntu terminal.
- If you get a py4j error when running a notebook with spylon-kernel, check the version of py4j in `$SPARK_HOME/python/lib` and update the PYTHONPATH in your `~/.profile` accordingly.
- If you have issues downloading the script, ensure you have an active internet connection and that GitHub is accessible from your network.
- If PowerShell blocks the script execution due to security policies, you may need to change the execution policy temporarily:
  ```powershell
  Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
  ```
  Remember to revert this change after running the script:
  ```powershell
  Set-ExecutionPolicy -Scope Process -ExecutionPolicy Default
  ```
- If you run into any other issues, please contact your TA for help.
