#!/bin/bash
# file1.sh - Simple Frontend Deployment Script for EC2

set -e
exec > >(tee /var/log/user-data.log | logger -t user-data ) 2>&1

# ---------------- Step 1: Install dependencies ----------------
echo "🔹 Updating system..."
sudo dnf update -y

echo "🔹 Installing Git..."
sudo yum install -y git

echo "🔹 Installing Apache (httpd)..."
sudo dnf install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

echo "🔹 Installing Node.js 18..."
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs

# ---------------- Step 2: Clone Repo ----------------
cd /home/ec2-user || cd /root
if [ ! -d "2nd10WeeksofCloudOps-main" ]; then
  git clone https://github.com/CloudTechDevOps/2nd10WeeksofCloudOps-main.git
fi

cd 2nd10WeeksofCloudOps-main/client

# ---------------- Step 3: Update config.js ----------------
CONFIG_FILE="src/pages/config.js"

if [ -f "$CONFIG_FILE" ]; then
  echo "🔹 Writing backend URL to config.js..."
  cat > "$CONFIG_FILE" <<EOF
const API_BASE_URL = "http://frontend.sonalrmeshram.xyz";
export default API_BASE_URL;
EOF
else
  echo "⚠️ config.js not found, skipping replacement"
fi

# ---------------- Step 4: Build & Deploy ----------------
echo "🔹 Installing npm dependencies..."
npm install

echo "🔹 Building project..."
npm run build

echo "🔹 Deploying build to Apache web root..."
sudo rm -rf /var/www/html/*
sudo cp -r build/* /var/www/html/

echo "🔹 Restarting Apache..."
sudo systemctl restart httpd
sudo systemctl enable httpd

echo "✅ Frontend setup completed successfully!"
