# Install CHOCOLATEY
Set-ExecutionPolicy AllSigned; iex ((New-Object System.Net.WebClient).DownloadString('https://ch
ocolatey.org/install.ps1'))

# Install chocolateygui
choco install -y chocolateygui

# Test Package
choco search --by-id-only firefox

# Install Chrome
choco install -y googlechrome

# Install notepadplusplus
choco install -y notepadplusplus.install

# Install GIT
choco install -y git.install

# Install autohotkey
choco install -y autohotkey.portable

# Install visualstudio2015buildtoolsCHO
choco install -y visualstudio2015buildtools

# Install Process Explorer
choco install -y procexp

# Install eclipse
choco install -y eclipse

# Install sourcetree
choco install -y sourcetree

# Install wsl
choco install -y wsl

# Install conemu
choco install -y conemu

# Install meld
choco install -y meld

