#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to add a line to a file if it doesn't exist
add_to_file() {
    grep -qF "$1" "$2" || echo "$1" >> "$2"
}

# Update and upgrade the package list
sudo apt update && sudo apt upgrade -y

# Install required dependencies for Homebrew (Linuxbrew)
sudo apt-get install build-essential procps curl file git -y

# Install Anaconda from the official link if not already downloaded
if [ ! -f "anaconda3.sh" ]; then
    echo "Downloading Anaconda installer..."
     curl https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh --output anaconda3.sh
fi

# Run the Anaconda installer
if [ ! -d "$HOME/anaconda3" ]; then
    echo "Installing Anaconda... Please use the default installation location and type 'yes' when prompted."
    bash anaconda3.sh
else
    echo "Anaconda is already installed."
fi

# Add Anaconda to the PATH if not already added
if [[ ":$PATH:" != *":$HOME/anaconda3/bin:"* ]]; then
    echo "Adding Anaconda to PATH..."
    add_to_file 'export PATH="$HOME/anaconda3/bin:$PATH"' ~/.bashrc
    source ~/.bashrc
fi

# Ensure the base conda environment uses Python 3.11
echo "Ensuring the base conda environment uses Python 3.11..."
BASE_PYTHON_VERSION=$(conda run -n base python --version | grep "3.11")
if [[ -z "$BASE_PYTHON_VERSION" ]]; then
    echo "Updating base environment to Python 3.11..."
    conda run -n base conda install python=3.11 -y
else
    echo "Base environment is already running Python 3.11."
fi

# Install Homebrew if not already installed
if ! command_exists brew; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    add_to_file 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' ~/.profile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed."
fi

# Install Apache Spark using Homebrew
echo "Installing Apache Spark..."
brew install apache-spark

# Determine the correct version of OpenJDK based on Spark's requirements
echo "Determining which OpenJDK version Spark is using..."
JAVA_VERSION=$(brew info apache-spark | awk '/Required:/ && /openjdk/ {print $2}')

if [[ -z "$JAVA_VERSION" ]]; then
    echo "Error: Could not determine the OpenJDK version required by Spark."
    exit 1
else
    echo "OpenJDK version used by Spark: $JAVA_VERSION"
fi

# Set JAVA_HOME based on the installed OpenJDK version
JAVA_HOME=$(brew info "$JAVA_VERSION" | awk '/Installed/ {getline; print $1}')

if [[ -d "$JAVA_HOME" ]]; then
    echo "JAVA_HOME is set to $JAVA_HOME"
    add_to_file "export PATH=\"$JAVA_HOME/bin:\$PATH\"" ~/.profile
    add_to_file "export JAVA_HOME=$JAVA_HOME/libexec" ~/.profile
else
    echo "Error: Could not determine the installed path of $JAVA_VERSION."
    exit 1
fi

# Set SPARK_HOME dynamically using brew info
echo "Setting SPARK_HOME dynamically..."
SPARK_HOME=$(brew info apache-spark | awk '/Installed/ {getline; print $1}')/libexec

if [[ -d "$SPARK_HOME" ]]; then
    echo "SPARK_HOME is set to $SPARK_HOME"
    add_to_file "export SPARK_HOME=$SPARK_HOME" ~/.profile
else
    echo "Error: Could not determine SPARK_HOME."
    exit 1
fi

# Set PYSPARK_PYTHON to use the Anaconda Python
echo "Setting PYSPARK_PYTHON to Anaconda's Python..."
PYSPARK_PYTHON=$(conda run -n base which python)
add_to_file "export PYSPARK_PYTHON=$PYSPARK_PYTHON" ~/.profile

# Set PYTHONPATH for PySpark
echo "Setting PYTHONPATH for PySpark..."
PY4J_VERSION=$(ls $SPARK_HOME/python/lib | grep py4j | sed 's/py4j-\(.*\)-src.zip/\1/')
add_to_file "export PYTHONPATH=\"$SPARK_HOME/python/:$SPARK_HOME/python/lib/py4j-$PY4J_VERSION-src.zip:\$PYTHONPATH\"" ~/.profile

# Install spylon-kernel
echo "Installing spylon-kernel..."
$PYSPARK_PYTHON -m pip install spylon-kernel
$PYSPARK_PYTHON -m spylon_kernel install --user

echo "Setup complete! Please restart your terminal or run 'source ~/.profile' to apply the changes."
