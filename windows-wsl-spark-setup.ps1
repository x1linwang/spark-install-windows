# Windows WSL Ubuntu Spark Setup Script

# Check if WSL is installed
if (!(Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux).State -eq 'Enabled') {
    Write-Host "Installing WSL..."
    wsl --install -d Ubuntu
    Write-Host "WSL installed. Please restart your computer and run this script again."
    exit
}

# Check if Ubuntu is installed
if (!(wsl -l -v | Select-String "Ubuntu")) {
    Write-Host "Installing Ubuntu..."
    wsl --install -d Ubuntu
    Write-Host "Ubuntu installed. Please set up your Ubuntu username and password, then run this script again."
    exit
}

# Run the rest of the setup in Ubuntu
wsl -d Ubuntu bash -c @'
set -e

# Install Homebrew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    sudo apt-get install build-essential
else
    echo "Homebrew is already installed."
fi

# Install OpenJDK 11
if ! command -v java &> /dev/null; then
    echo "Installing OpenJDK 11..."
    brew install openjdk@11
    echo 'export PATH="/home/linuxbrew/.linuxbrew/opt/openjdk@11/bin:$PATH"' >> ~/.profile
    echo 'export JAVA_HOME="/home/linuxbrew/.linuxbrew/opt/openjdk@11/libexec"' >> ~/.profile
else
    echo "Java is already installed."
fi

# Install Scala
echo "Installing Scala..."
brew install scala

# Install Apache Spark
echo "Installing Apache Spark..."
brew install apache-spark

# Install Anaconda
if ! command -v conda &> /dev/null; then
    echo "Installing Anaconda..."
    curl https://repo.anaconda.com/archive/Anaconda3-2023.07-2-Linux-x86_64.sh --output anaconda.sh
    bash anaconda.sh -b -p $HOME/anaconda3
    rm anaconda.sh
    echo 'export PATH="$HOME/anaconda3/bin:$PATH"' >> ~/.profile
    source ~/.profile
else
    echo "Anaconda is already installed."
fi

# Update .profile
echo 'export SPARK_HOME="/home/linuxbrew/.linuxbrew/Cellar/apache-spark/3.5.2/libexec"' >> ~/.profile
echo 'export PYSPARK_PYTHON="$HOME/anaconda3/bin/python"' >> ~/.profile
echo 'export PYTHONPATH="$SPARK_HOME/python/:$SPARK_HOME/python/lib/py4j-0.10.9.7-src.zip:$PYTHONPATH"' >> ~/.profile
source ~/.profile

# Install spylon-kernel
pip install spylon-kernel
python -m spylon_kernel install --user

echo "Setup complete! Please close this window and open a new Ubuntu terminal to apply the changes."
'@

Write-Host "Script execution completed. Please check the Ubuntu window for any messages or errors."
