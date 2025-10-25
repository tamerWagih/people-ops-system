# 🚀 Deployment Commands

## 📋 Quick Setup Commands

### 1. GitHub Setup (Local Machine)
```bash
# Create GitHub repo first at https://github.com/new
git remote add origin https://github.com/yourusername/people-ops-system.git
git push -u origin master
```

### 2. VM 1 Setup (10.20.13.76) - App Server
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Git
sudo apt update && sudo apt install git -y

# Clone repo
git clone https://github.com/yourusername/people-ops-system.git
cd people-ops-system

# Create environment file
cp env.app.template .env.app
# Edit .env.app with your values

# Start services
docker-compose -f docker-compose.app.yml --env-file .env.app up -d
```

### 3. VM 2 Setup (10.20.13.77) - Database Server
```bash
# Install Docker (same as VM 1)
curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose (same as VM 1)
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Git
sudo apt update && sudo apt install git -y

# Clone repo
git clone https://github.com/yourusername/people-ops-system.git
cd people-ops-system

# Create environment file
cp env.db.template .env.db
# Edit .env.db with your values

# Start services
docker-compose -f docker-compose.db.yml --env-file .env.db up -d
```

### 4. Test Connections
```bash
# On VM 1 - Test app
curl http://localhost:3000
curl http://localhost:4000

# On VM 2 - Test database
docker exec people-ops-postgres psql -U people_ops -d people_ops_dev -c "SELECT version();"
docker exec people-ops-redis redis-cli ping
```

### 5. Daily Development
```bash
# Pull latest changes
git pull origin master

# Restart services
docker-compose -f docker-compose.app.yml restart  # VM 1
docker-compose -f docker-compose.db.yml restart   # VM 2
```
