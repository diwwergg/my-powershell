#!/bin/bash

# --- Script Start ---

echo "Starting initial setup for WSL Ubuntu 24.04..."

# --- 1. System Update ---
echo -e "\n--- Updating system packages ---"
sudo apt update -y
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt clean
echo "System update complete."

# --- 2. Set Google DNS ---
echo -e "\n--- Setting Google DNS (8.8.8.8, 8.8.4.4) ---"
# Back up the original resolv.conf
sudo cp /etc/resolv.conf /etc/resolv.conf.bak

# Create a new resolv.conf with Google DNS
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf > /dev/null
echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf > /dev/null

# Make resolv.conf immutable to prevent overwrites (might break some network changes from Windows)
# If you face network issues, uncomment the next line to revert this change:
# sudo chattr -i /etc/resolv.conf
sudo chattr +i /etc/resolv.conf

echo "DNS set to Google DNS (8.8.8.8, 8.8.4.4)."

# --- 3. Install Docker Engine (if not using Docker Desktop) ---
# IMPORTANT: If you are using Docker Desktop for Windows, it handles Docker Engine.
# Only proceed with this section if you want to install Docker Engine directly in WSL Ubuntu.

echo -e "\n--- Installing Docker Engine ---"
# Add Docker's official GPG key:
sudo apt update
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the Docker repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the apt package index:
sudo apt update

# Install Docker Engine, containerd, and Docker Compose plugin:
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# --- 4. Post-installation steps for Docker ---
echo -e "\n--- Configuring Docker permissions ---"
# Create the 'docker' group if it doesn't exist (usually created by installer)
sudo groupadd docker 2>/dev/null || true

# Add the current user to the 'docker' group
sudo usermod -aG docker $USER

echo "Docker group configured for user '$USER'. You will need to log out and log back in (or restart WSL) for changes to take effect."

# --- 5. Verify Docker and Docker Compose ---
echo -e "\n--- Verifying Docker and Docker Compose installations ---"

# Test Docker installation
echo "Testing Docker installation..."
docker run hello-world || echo "Docker test failed. Please check installation. You might need to restart WSL."

# Verify Docker Compose plugin
echo -e "\nVerifying Docker Compose (docker compose):"
docker compose version

# Create a symbolic link for 'docker-compose' (for backward compatibility)
echo -e "\nCreating symbolic link for 'docker-compose' (legacy command compatibility)..."
# Check if docker-compose-plugin is installed and where docker compose binary is located
if command -v docker > /dev/null && docker compose version > /dev/null; then
    DOCKER_COMPOSE_PATH=$(which docker)
    if [ -f "${DOCKER_COMPOSE_PATH%/*}/docker-compose" ]; then
        echo "Legacy 'docker-compose' symlink already exists or is handled."
    else
        sudo ln -s "$(which docker)" /usr/local/bin/docker-compose
        echo "Symbolic link 'docker-compose' created."
    fi
else
    echo "Docker or Docker Compose plugin not found, skipping 'docker-compose' symlink."
fi

echo -e "\nVerifying legacy Docker Compose (docker-compose):"
docker-compose version

echo -e "\n--- Setup Complete ---"
echo "Please restart your WSL Ubuntu terminal (or run 'wsl --terminate Ubuntu-24.04' in PowerShell and then relaunch) for Docker group changes to take full effect."
echo "You can check your DNS settings by running 'cat /etc/resolv.conf'."
echo "To check Docker status, run 'systemctl status docker' (requires systemctl emulation) or 'docker info'."
echo "Enjoy your WSL Ubuntu 24.04 environment!"

# --- Script End ---
