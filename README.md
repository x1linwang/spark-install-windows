# spark-install-windows
Apache-spark installation script for Windows. This script is customized for IEOR 4526 Analytics on the Cloud offered by Columbia University.

# Windows WSL Ubuntu Spark Setup Instructions

This guide will help you install Apache Spark on Ubuntu (running on WSL for Windows users) using Homebrew, and install Anaconda with Python 3.11 for compatibility with spylon-kernel.

## Prerequisites
- Windows 10 version 2004 and higher (Build 19041 and higher) or Windows 11
- WSL and Ubuntu installed. Follow the [official Microsoft guide](https://learn.microsoft.com/en-us/windows/wsl/install) to set up WSL and Ubuntu.
- Administrator privileges on your Windows machine.

## Step-by-Step Guide

### 0. Install WSL and Ubuntu
Follow the [Microsoft official WSL guide](https://learn.microsoft.com/en-us/windows/wsl/install) to install WSL and Ubuntu on your Windows machine.

**Note**: 

i. To install Ubuntu as your default linux distribution, please open **PowerShell** in **administrator mode** by right-clicking and selecting "Run as administrator" and enter:
```bash
wsl --install -d Ubuntu-22.04
```
Then restart your machine.

ii. If you have trouble installing WSL, please check the [official troubleshooting guide](https://learn.microsoft.com/en-us/windows/wsl/troubleshooting#installation-issues).

### 1. Download the Setup Script
Open a **Ubuntu** terminal from the start menu and enter the following command:

```bash
wget https://raw.githubusercontent.com/x1linwang/spark-install-windows/main/ubuntu_setup.sh
```

### 2. Run the Setup Script
Make the script executable and run the script:

```bash
chmod +x ubuntu_setup.sh
./ubuntu_setup.sh
```

### 3. Complete Anaconda Installation
During the script execution, you will be prompted to confirm the installation of Anaconda. Type `yes` when prompted.

### 4. Final Steps
Once the script completes, restart your terminal or run:

```bash
source ~/.profile
```

### 5. Start Jupyter Notebook
Again, open a **Ubuntu** terminal from the start menu and enter the following command:
```bash
jupyter notebook --no-browser
```

Copy the URL from the terminal and paste it into your web browser to access Jupyter Notebook.

### 6. Create a New Notebook with Spylon Kernel

i. In the Jupyter interface, click on "New" in the top right corner.

ii. Select "spylon-kernel" from the dropdown menu.

### 7. Test the Spylon Kernel

In the new notebook, you can test if everything is working correctly by running the following cells:

i. Test Scala:

   In the current spylon kernel, run the following command:
   ```
   val x = 1
   println(s"This is Scala. x = $x")
   ```

ii. Test PySpark:

   Change to a python kernel and run the below command:
   ```
   %%python
   from pyspark.sql import SparkSession

   spark = SparkSession.builder.appName("test").getOrCreate()
   print(f"Spark version: {spark.version}")

   # Create a sample DataFrame
   df = spark.createDataFrame([(1, "a"), (2, "b"), (3, "c")], ["id", "letter"])
   df.show()
   ```

If both cells run without errors, congratulations! Your Spark environment with spylon kernel is set up correctly.

## Troubleshooting

- If you encounter any "command not found" errors, try closing and reopening your Ubuntu terminal.
- If you get a py4j error when running a notebook with spylon-kernel, check the version of py4j in `$SPARK_HOME/python/lib` and update the PYTHONPATH in your `~/.profile` accordingly.
- If you have issues downloading the script, ensure you have an active internet connection and that GitHub is accessible from your network.
- If you run into any other issues, please contact your TA for help.
