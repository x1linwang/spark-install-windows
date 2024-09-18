
#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.

# Update and upgrade the package list
sudo apt update && sudo apt upgrade -y

# Install Anaconda from the official link
if [ ! -f "Anaconda3-2024.06-1-Linux-x86_64.sh" ]; then
    echo "Downloading Anaconda installer..."
    wget https://repo.anaconda.com/archive/Anaconda3-2024.06-1-Linux-x86_64.sh
fi

# Run the Anaconda installer
echo "Installing Anaconda... Please type 'yes' when prompted."
bash Anaconda3-2024.06-1-Linux-x86_64.sh

# Add Anaconda to the PATH
echo "Adding Anaconda to PATH..."
echo 'export PATH="$HOME/anaconda3/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Ensure Anaconda uses Python 3.11 by default in the base environment
echo "Ensuring Anaconda uses Python 3.11..."
conda install python=3.11 -y

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>~/.profile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed."
fi

# Install Apache Spark using Homebrew
echo "Installing Apache Spark..."
brew install apache-spark

# Dynamically set JAVA_HOME based on the installed version
if brew list --versions | grep -q "openjdk@17"; then
    JAVA_HOME=$(brew --prefix openjdk@17)/libexec/openjdk.jdk/Contents/Home
elif brew list --versions | grep -q "openjdk@11"; then
    JAVA_HOME=$(brew --prefix openjdk@11)/libexec/openjdk.jdk/Contents/Home
else
    JAVA_HOME=$(brew --prefix openjdk)/libexec/openjdk.jdk/Contents/Home
fi

echo "export JAVA_HOME=$JAVA_HOME" >> ~/.profile
echo "export PATH=$JAVA_HOME/bin:$PATH" >>~/.profile

# Set SPARK_HOME
SPARK_VERSION=$(brew info apache-spark --json | jq -r '.[0].installed[0].version')
SPARK_HOME="$(brew --prefix apache-spark)/${SPARK_VERSION}/libexec"
echo "Setting SPARK_HOME..."
echo "export SPARK_HOME=$SPARK_HOME" >>~/.profile

# Install spylon-kernel
echo "Installing spylon-kernel..."
pip3 install spylon-kernel
python3 -m spylon_kernel install --user

echo "Setup complete! Please restart your terminal or run 'source ~/.profile' to apply the changes."
