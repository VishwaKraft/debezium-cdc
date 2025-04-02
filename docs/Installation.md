# Docker & Docker Desktop Setup Guide

## 1. Installation Steps

### **1. Install Docker Desktop (Windows/macOS)**

#### **Windows**
1. Download Docker Desktop from [Docker's official site](https://www.docker.com/products/docker-desktop/).
2. Run the installer and follow the instructions.
3. During installation, select **"Use WSL 2 instead of Hyper-V"** if available.
4. After installation, restart your system.
5. Open Docker Desktop and ensure it runs without errors.
6. Verify installation by running:
   ```sh
   docker --version
   ```

#### **macOS**
1. Download Docker Desktop for Mac from [Docker's official site](https://www.docker.com/products/docker-desktop/).
2. Open the `.dmg` file and drag Docker into the **Applications** folder.
3. Open Docker Desktop and follow the setup process.
4. Verify installation:
   ```sh
   docker --version
   ```

### **2. Install Docker on Linux**

#### **Ubuntu/Debian**
1. Update the package list:
   ```sh
   sudo apt update
   ```
2. Install required dependencies:
   ```sh
   sudo apt install -y ca-certificates curl gnupg
   ```
3. Add Docker’s official GPG key:
   ```sh
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
   ```
4. Add Docker repository:
   ```sh
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   ```
5. Install Docker Engine:
   ```sh
   sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
   ```
6. Start and enable Docker:
   ```sh
   sudo systemctl start docker
   sudo systemctl enable docker
   ```
7. Verify installation:
   ```sh
   docker --version
   ```

### **3. Post Installation (Optional but Recommended)**

#### **Linux: Run Docker Without Sudo**
```sh
sudo usermod -aG docker $USER
newgrp docker
```

### **4. Verify Docker Installation**
Run the following command to check if Docker is working correctly:
```sh
docker run hello-world
```
If Docker is properly installed, you should see a message confirming that Docker is running.

---

## 2. Uninstall Docker

### **Windows/macOS**
- Open Docker Desktop and navigate to **Settings > Troubleshoot**.
- Click **Uninstall**.

### **Linux (Ubuntu/Debian)**
```sh
sudo apt remove -y docker-ce docker-ce-cli containerd.io
sudo apt autoremove -y
```

---

## 3. Pull and Run MySQL Container in Docker

### **Pull MySQL Image**
To download the latest MySQL image, run:
```sh
docker pull mysql:latest
```

### **Run MySQL Container**
To start a MySQL container, use:
```sh
docker run --name mysql-container -e MYSQL_ROOT_PASSWORD=root -p 3306:3306 -d mysql:latest
```
- `--name mysql-container` → Assigns a name to the container.
- `-e MYSQL_ROOT_PASSWORD=root` → Sets the root password for MySQL.
- `-p 3306:3306` → Maps MySQL's port to the host.
- `-d` → Runs the container in detached mode.

### **Verify Running Container**
```sh
docker ps
```

### **Access MySQL CLI**
```sh
docker exec -it mysql-container mysql -uroot -p
```
Enter the password (`root`) when prompted.
