# 🚀 VM Deployment Guide - People Operations & Workforce Management System

## 📋 Architecture Overview

### VM Configuration
- **VM 1 (10.20.13.76)**: Application Server (Backend, Frontend, NGINX)
- **VM 2 (10.20.13.77)**: Database Server (PostgreSQL, Redis, MinIO)

### Network Access
- **From Your Windows Machine**: Access services via VM IP addresses
- **VM-to-VM Communication**: Internal Docker networking
- **External Access**: Through VM public IPs

## 🖥️ VM 1 (10.20.13.76) - Application Server Setup

### 1. Initial Setup
```bash
# Update system
sudo dnf update -y

# Install Git
sudo dnf install git -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Vim
sudo dnf install vim -y

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Logout and login again
exit
ssh username@10.20.13.76
```

### 2. Git Setup and Clone
```bash
# Configure Git
git config --global user.name "tamerWagih"
git config --global user.email "mrtamerwagih@gmail.com"

# Clone repository
git clone https://github.com/tamerWagih/people-ops-system.git
cd people-ops-system
```

### 3. Create Environment File
```bash
# Copy template
cp env.app.template .env.app

# Edit with Vim
vim .env.app
```

**Vim Commands for .env.app:**
```
# Press 'i' to enter insert mode
# Edit the file with your values:

NODE_ENV=production
PORT=4000
HOST=0.0.0.0

# Database Configuration (VM 2 - Database Server)
DATABASE_URL=postgresql://people_ops:ops@1234@10.20.13.77:5432/people_ops_dev
POSTGRES_DB=people_ops_dev
POSTGRES_USER=people_ops
POSTGRES_PASSWORD=ops@1234
POSTGRES_HOST=10.20.13.77
POSTGRES_PORT=5432

# Redis Configuration (VM 2 - Database Server)
REDIS_URL=redis://10.20.13.77:6379
REDIS_HOST=10.20.13.77
REDIS_PORT=6379

# JWT Configuration
JWT_SECRET=your_production_jwt_secret_here
JWT_EXPIRES_IN=24h
JWT_REFRESH_EXPIRES_IN=7d

# MinIO Configuration (VM 2 - Database Server)
MINIO_ENDPOINT=10.20.13.77
MINIO_PORT=9000
MINIO_ACCESS_KEY=ops@1234
MINIO_SECRET_KEY=ops@1234
MINIO_BUCKET_NAME=people-ops-dev-documents
MINIO_USE_SSL=false

# Frontend Configuration
NEXT_PUBLIC_API_URL=http://10.20.13.76:4000
NEXT_PUBLIC_APP_NAME=People Operation and Management
NEXT_PUBLIC_APP_VERSION=1.0.0

# CORS Configuration
CORS_ORIGIN=http://10.20.13.76:3000
CORS_CREDENTIALS=true

# Logging
LOG_LEVEL=info
DEBUG=false

# Press 'Esc' then type ':wq' and press Enter to save and exit
```

### 4. Build and Start Application Services
```bash
# Build and start app services
docker compose -f docker-compose.app.yml --env-file .env.app up -d

# Check status
docker compose -f docker-compose.app.yml ps

# View logs
docker compose -f docker-compose.app.yml logs -f
```

---

## 🗄️ VM 2 (10.20.13.77) - Database Server Setup

### 1. Initial Setup
```bash
# Update system
sudo dnf update -y

# Install Git
sudo dnf install git -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Vim
sudo dnf install vim -y

# Start Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Logout and login again
exit
ssh username@10.20.13.77
```

### 2. Git Setup and Clone
```bash
# Configure Git
git config --global user.name "tamerWagih"
git config --global user.email "mrtamerwagih@gmail.com"

# Clone repository
git clone https://github.com/tamerWagih/people-ops-system.git
cd people-ops-system
```

### 3. Create Environment File
```bash
# Copy template
cp env.db.template .env.db

# Edit with Vim
vim .env.db
```

**Vim Commands for .env.db:**
```
# Press 'i' to enter insert mode
# Edit the file with your values:

POSTGRES_DB=people_ops_dev
POSTGRES_USER=people_ops
POSTGRES_PASSWORD=ops@1234

REDIS_PASSWORD=ops@1234

MINIO_ROOT_USER=ops@1234
MINIO_ROOT_PASSWORD=ops@1234

# Press 'Esc' then type ':wq' and press Enter to save and exit
```

### 4. Build and Start Database Services
```bash
# Build and start database services
docker compose -f docker-compose.db.yml --env-file .env.db up -d

# Check status
docker compose -f docker-compose.db.yml ps

# View logs
docker compose -f docker-compose.db.yml logs -f
```

---

## 🌐 Accessing Services from Your Windows Machine

### Add VM IPs to Windows Hosts File

To make it easier to access your VMs, add their IPs to your Windows hosts file:

#### **Step 1: Open Hosts File as Administrator**
```powershell
# Open PowerShell as Administrator
# Navigate to hosts file location
notepad C:\Windows\System32\drivers\etc\hosts
```

#### **Step 2: Add VM Entries**
Add these lines to the hosts file:
```
# People Operations & Workforce Management System VMs
10.20.13.76    app-server
10.20.13.77    db-server
```

#### **Step 3: Save and Test**
```powershell
# Test connectivity
ping app-server
ping db-server

# Test services
Invoke-WebRequest -Uri "http://app-server:3000" -Method GET
Invoke-WebRequest -Uri "http://app-server:4000/health" -Method GET
```

### Application Server (VM 1 - 10.20.13.76)
| Service | URL | Description |
|---------|-----|-------------|
| **Frontend** | http://app-server:3000 | Next.js application |
| **Backend API** | http://app-server:4000 | NestJS API |
| **Backend Health** | http://app-server:4000/health | API health check |
| **NGINX Proxy** | http://app-server:80 | Reverse proxy |

### Database Server (VM 2 - 10.20.13.77)
| Service | URL | Description |
|---------|-----|-------------|
| **MinIO Console** | http://db-server:9001 | Object storage management |
| **MinIO API** | http://db-server:9000 | Object storage API |

### Database Connections (Internal)
- **PostgreSQL**: 10.20.13.77:5432
- **Redis**: 10.20.13.77:6379

## 🧪 Testing from Your Windows Machine

### Test Application Server (VM 1)
```powershell
# Test Frontend
Invoke-WebRequest -Uri "http://10.20.13.76:3000" -Method GET

# Test Backend API
Invoke-WebRequest -Uri "http://10.20.13.76:4000/health" -Method GET

# Test NGINX
Invoke-WebRequest -Uri "http://10.20.13.76:80" -Method GET
```

### Test Database Server (VM 2)
```powershell
# Test MinIO Console
Invoke-WebRequest -Uri "http://10.20.13.77:9001" -Method GET

# Test MinIO API
Invoke-WebRequest -Uri "http://10.20.13.77:9000" -Method GET
```

### Test Database Connections
```bash
# On VM 2, test database
docker exec people-ops-system-postgres-1 psql -U people_ops -d people_ops_dev -c "SELECT version();"

# Test Redis
docker exec people-ops-system-redis-1 redis-cli ping

# Test MinIO
curl http://10.20.13.77:9000
```

## 🔧 VM Management Commands

### Check Services on VM 1
```bash
# Check Docker status
sudo systemctl status docker

# Check running containers
docker ps

# Check app logs
docker-compose -f docker-compose.app.yml logs -f
```

### Check Services on VM 2
```bash
# Check Docker status
sudo systemctl status docker

# Check running containers
docker ps

# Check database logs
docker-compose -f docker-compose.db.yml logs -f
```

### Network Testing Between VMs
```bash
# From VM 1, test connectivity to VM 2
ping 10.20.13.77

# Test specific ports
telnet 10.20.13.77 5432  # PostgreSQL
telnet 10.20.13.77 6379  # Redis
telnet 10.20.13.77 9000  # MinIO
```

### Restart Services
```bash
# On VM 1 - Restart application services
docker-compose -f docker-compose.app.yml restart

# On VM 2 - Restart database services
docker-compose -f docker-compose.db.yml restart
```

## 🔧 Docker Management Commands

### Stop and Remove Services

#### On VM 1 (App Server):
```bash
# Stop application services
docker compose -f docker-compose.app.yml down

# Stop and remove all containers and images
docker compose -f docker-compose.app.yml down --rmi all

# Clean up remaining containers
docker container prune -f

# Clean up remaining images
docker image prune -f
```

#### On VM 2 (Database Server):
```bash
# Stop database services
docker compose -f docker-compose.db.yml down

# Stop and remove all containers and images
docker compose -f docker-compose.db.yml down --rmi all

# Clean up remaining containers
docker container prune -f

# Clean up remaining images
docker image prune -f
```

### Complete Rebuild Process

#### On VM 2 (Database Server):
```bash
# 1. Stop and remove all database services
docker compose -f docker-compose.db.yml down --rmi all

# 2. Clean up any remaining containers
docker container prune -f

# 3. Clean up any remaining images
docker image prune -f

# 4. Rebuild and start database services
docker compose -f docker-compose.db.yml --env-file .env.db up -d --build
```

#### On VM 1 (App Server):
```bash
# 1. Stop and remove all application services
docker compose -f docker-compose.app.yml down --rmi all

# 2. Clean up any remaining containers
docker container prune -f

# 3. Clean up any remaining images
docker image prune -f

# 4. Rebuild and start application services
docker compose -f docker-compose.app.yml --env-file .env.app up -d --build
```

### Nuclear Cleanup (Complete Reset)

```bash
# Stop all containers
docker stop $(docker ps -aq)

# Remove all containers
docker rm $(docker ps -aq)

# Remove all images
docker rmi $(docker images -q)

# Remove all volumes
docker volume prune -f

# Remove all networks
docker network prune -f

# Then rebuild from scratch
docker compose -f docker-compose.db.yml --env-file .env.db up -d --build
```

### Check Running Services

```bash
# Check running containers
docker ps

# Check all containers (including stopped)
docker ps -a

# Check images
docker images

# Check volumes
docker volume ls

# Check networks
docker network ls
```

## 🚨 Troubleshooting

### Common Issues

#### Services Not Accessible from Windows
```bash
# Check firewall on VMs
sudo firewall-cmd --list-all
sudo firewall-cmd --permanent --add-port=3000/tcp
sudo firewall-cmd --permanent --add-port=4000/tcp
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=5432/tcp
sudo firewall-cmd --permanent --add-port=6379/tcp
sudo firewall-cmd --permanent --add-port=9000/tcp
sudo firewall-cmd --permanent --add-port=9001/tcp
sudo firewall-cmd --reload
```

#### Database Connection Issues
```bash
# Check if database is accepting connections
docker exec people-ops-system-postgres-1 pg_isready -U people_ops

# Check database logs
docker logs people-ops-system-postgres-1
```

#### Network Connectivity Issues
```bash
# Test connectivity between VMs
ping 10.20.13.77  # From VM 1
ping 10.20.13.76  # From VM 2

# Check if ports are open
netstat -tulpn | grep :5432
netstat -tulpn | grep :6379
netstat -tulpn | grep :9000
```

## 🎯 Expected Results

### ✅ Successful Deployment
- **VM 1**: Frontend (port 3000), Backend (port 4000), NGINX (port 80)
- **VM 2**: PostgreSQL (port 5432), Redis (port 6379), MinIO (ports 9000, 9001)
- **Browser Access**: All services accessible from your Windows machine
- **Database**: Full HR and WFM schemas loaded and ready

### 🔍 Verification Steps
1. Open http://10.20.13.76:3000 in browser → Should see frontend
2. Open http://10.20.13.76:4000/health in browser → Should see API health
3. Open http://10.20.13.77:9001 in browser → Should see MinIO console
4. Test database connection from VM 1 to VM 2
5. Verify all services are healthy

## 🔄 Deployment Workflow

### Initial Deployment
1. **Setup VM 1**: Install Docker, clone repo, configure .env.app
2. **Setup VM 2**: Install Docker, clone repo, configure .env.db
3. **Start VM 2**: Database services first
4. **Start VM 1**: Application services
5. **Test**: Access from Windows machine

### Updates and Maintenance
1. **Update Code**: `git pull` on both VMs
2. **Rebuild**: `docker-compose --env-file .env.app up -d --build`
3. **Test**: Verify all services are working
4. **Monitor**: Check logs for any issues

This guide ensures successful deployment of the People Operations & Workforce Management System across your 2-VM architecture! 🚀
