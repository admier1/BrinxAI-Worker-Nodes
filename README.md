Worker Nodes (Setup)
System Requirements for Worker Nodes
Minimum Requirements
To ensure basic functionality of the Worker Node, your system should meet the following minimum specifications:

CPU: 8 VCPU Cores

Memory: 16GB RAM

Storage: 300GB SSD

GPU: Optional (A GPU can significantly boost performance and earnings)

Port: 5011 needs to be open

Recommended Requirements
For optimal performance and to maximize earnings, we recommend the following system specifications:

CPU: 16+ VCPU Cores

Memory: 64GB+ RAM

Storage: 1TB+ SSD

GPU: NVIDIA RTX 2060 or higher, AMD Radeon RX 5600 XT or higher

Port: 5011 needs to be open

Installation on Linux
Step 1: Install Docker

To install Docker on your Linux system, please follow the instructions provided in the official Docker documentation by visiting https://docs.docker.com/engine/install/ubuntu

Step 2: Download & Run the Worker Node

Run the following Command in your Terminal:

Copy
# Pull the latest image from Docker Hub
docker pull admier/brinxai_nodes-worker:latest

# Run docker-compose to start the service
docker compose up -d
Step 3: Register Your Worker Node

Go to workers.brinxai.com.

Create an account using your email and password.

Log in to your account.

Find your IP address by visiting https://whatismyipaddress.com or using the ifconfig command in the terminal.

Enter your Node Name (Any) and IP address in the Worker Dashboard and click "Add Node".

Installation on Windows
Step 1: Install Docker

To install Docker on your Windows system, please follow the instructions provided in the official Docker documentation by visiting https://docs.docker.com/desktop/install/windows-install/

Step 2: Download & Run the Worker Node

Run the following Command in your Command Prompt or Powershell:

Copy
# Pull the latest image from Docker Hub
docker pull admier/brinxai_nodes-worker:latest

# Run docker-compose to start the service
docker compose up -d
Step 3: Register Your Worker Node

Go to workers.brinxai.com.

Create an account using your email and password.

Log in to your account.

Find your IP address by visiting https://whatismyipaddress.com or using the ipconfig command in the terminal.

Enter your Node Name (Any) and IP address in the Worker Dashboard and click "Add Node".

Important Notes
Ensure port 5011 is open on your system for the Worker Node to function correctly.

Follow the above steps carefully for a successful installation and setup of your Worker Node on both Linux and Windows platforms.
