#!/bin/bash
set -e

# --- Step 1: Install dependencies ---
sudo dnf update -y
sudo yum install -y git

# Enable Node.js 18 from NodeSource
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs

# Install PM2 globally
sudo npm install -g pm2

# --- Step 2: Clone repo ---
cd /home/ec2-user || cd /root
if [ ! -d "2nd10WeeksofCloudOps-main" ]; then
  git clone https://github.com/CloudTechDevOps/2nd10WeeksofCloudOps-main.git
fi

cd 2nd10WeeksofCloudOps-main/backend

# --- Step 3: Configure environment variables ---
# Create .env if not exists
cat > .env <<EOF
DB_HOST=book.rds.com
DB_USERNAME=admin
DB_PASSWORD=veera
PORT=3306
EOF

# --- Step 4: Install dependencies ---
npm install
npm install dotenv

# --- Step 5: Start backend with PM2 ---
sudo pm2 start index.js --name "backendApi"
sudo pm2 startup systemd -u ec2-user --hp /home/ec2-user
sudo pm2 save
