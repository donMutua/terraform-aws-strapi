#!/bin/bash

# Navigate to the home directory
cd ~

# Update the package lists
sudo apt-get update

# Install necessary packages
sudo apt-get install -y ca-certificates curl gnupg git

# Create a directory for the apt keyrings
sudo mkdir -p /etc/apt/keyrings

# Download and add the NodeSource signing key
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

# Set the Node.js major version to be installed
NODE_MAJOR=20

# Update the package lists again
sudo apt-get update

# Install Node.js
sudo apt-get install nodejs -y

# Verify the installation of Node.js and npm
node -v && npm -v

# Install PM2 globally
sudo npm install -g pm2

# Clone your Strapi application repository from GitHub
git clone https://github.com/donMutua/portfolio-strapi.git

# Navigate to your cloned Strapi application directory
cd portfolio-strapi

# Install dependencies using yarn or npm (assuming your app uses yarn)
yarn install

# Create PM2 ecosystem configuration file
cat << EOF > ecosystem.config.js
module.exports = {
  apps: [{
    name: "portfolio-strapi",
    script: "yarn",
    args: "start",
    cwd: "/home/ubuntu/portfolio-strapi", // Adjust if necessary
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: "1G",
    env: {
      NODE_ENV: "production"
    },
    env_production: {
      NODE_ENV: "production"
    }
  }]
};
EOF

# Start Strapi application with PM2 using the ecosystem configuration file
pm2 start ecosystem.config.js --env production

pm2 save


# Save the PATH configuration in ~/.profile
echo "# set PATH so global node modules and PM2 install without permission issues" >> ~/.profile
echo "export PATH=~/.npm-global/bin:$PATH" >> ~/.profile

# Update system variables to include the new PATH
source ~/.profile

# Output message indicating completion
echo "PM2 setup and Strapi application deployment completed."

# End of script

