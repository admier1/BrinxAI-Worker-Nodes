# BrinxAI Worker Nodes Setup

Worker Nodes are the operational units of the BrinxAI network, executing the tasks distributed by Central Nodes. They are crucial for the functionality of the network, handling various AI operations such as image and video generation, text transformation, audio processing, website creation, code generation, and more.

Worker Nodes serve the following key purposes:

Task Execution: They perform the actual computational tasks assigned by Central Nodes.

Resource Utilization: Utilize their hardware resources to process tasks efficiently.

Feedback Loop: Provide performance feedback to Central Nodes to help optimize task distribution.

How Worker Nodes Work? 

Task Reception
Task Assignment: Worker Nodes receive tasks from Central Nodes based on their current capacity and load.

Task Acknowledgement: Once a task is received, the Worker Node acknowledges receipt and begins processing.

Task Execution
Resource Allocation: The Worker Node allocates the necessary resources (CPU, memory, storage) to the task.

Processing: Executes the task using the AI models and algorithms provided by BrinxAI.

Progress Tracking: Continuously monitors the progress of the task, ensuring it stays within operational parameters.

Task Completion
Result Generation: Upon completion, the Worker Node generates the output of the task (e.g., processed image, translated text).

Result Transmission: Sends the results back to the Central Node or directly to the user, depending on the task requirements.

Status Update: Updates its status and resource availability to the Central Node, enabling real-time load balancing.

## System Requirements for Worker Nodes

### Minimum Requirements
To ensure basic functionality of the Worker Node, your system should meet the following minimum specifications:
- **CPU**: 8 VCPU Cores
- **Memory**: 16GB RAM
- **Storage**: 300GB SSD
- **GPU**: Optional (A GPU can significantly boost performance and earnings)
- **Port**: 5011 needs to be open

### Recommended Requirements
For optimal performance and to maximize earnings, we recommend the following system specifications:
- **CPU**: 16+ VCPU Cores
- **Memory**: 64GB+ RAM
- **Storage**: 1TB+ SSD
- **GPU**: NVIDIA RTX 2060 or higher, AMD Radeon RX 5600 XT or higher
- **Port**: 5011 needs to be open

## Installation on Linux

Installation on Linux
Step 1: Install Docker
To install Docker on your Linux system, please follow the instructions provided in the official Docker documentation by visiting Docker Engine Installation.
Step 2: Download & Run the Worker Node
Run the following commands in your terminal:
# Download the install script
curl -O https://raw.githubusercontent.com/admier1/BrinxAI-Worker-Nodes/master/install.sh

# Make the script executable
chmod +x install.sh

# Run the installation script
./install.sh
Step 3: Register Your Worker Node
Go to workers.brinxai.com.
Create an account using your email and password.
Log in to your account.
Find your IP address by visiting What Is My IP Address or using the ifconfig command in the terminal.
Enter your Node Name (Any) and IP address in the Worker Dashboard and click "Add Node".
Installation on Windows
Step 1: Install Docker
To install Docker on your Windows system, please follow the instructions provided in the official Docker documentation by visiting Docker Desktop Installation.
Step 2: Download & Run the Worker Node
Run the following commands in your Command Prompt or Powershell:
# Download the install script
curl -O https://raw.githubusercontent.com/admier1/BrinxAI-Worker-Nodes/master/install.sh

# Make the script executable
chmod +x install.sh

# Run the installation script
./install.sh
Step 3: Register Your Worker Node
Go to workers.brinxai.com.
Create an account using your email and password.
Log in to your account.
Find your IP address by visiting What Is My IP Address or using the ipconfig command in the terminal.
Enter your Node Name (Any) and IP address in the Worker Dashboard and click "Add Node".
Important Notes
Ensure port 5011 is open on your system for the Worker Node to function correctly.
Follow the above steps carefully for a successful installation and setup of your Worker Node on both Linux and Windows platforms.






Worker Nodes (Update Node)
Introduction
This guide will help you update your BrinxAI Worker Nodes from an older version to the latest version.
Update Instructions
Step 1: Stop and Remove Existing Containers
Before updating, you need to stop and remove your existing Docker containers. Run the following commands in your terminal or Command Prompt:
# Stop the existing containers
docker stop brinxai_nodes-worker-1
​
# Remove the existing containers
docker rm brinxai_nodes-worker-1
Step 2: Run the Installation Script
Download and run the installation script to set up the updated services:
# Download the install script
curl -O https://raw.githubusercontent.com/admier1/BrinxAI-Worker-Nodes/master/install.sh
​
# Make the script executable
chmod +x install.sh
​
# Run the installation script
./install.sh
Step 3: Verify the Update
Ensure that all services are running correctly by using the following command:
docker ps
Go to  and verify that your Worker Node is listed and active.
Important Notes
Make sure to backup any important data before performing the update.
Ensure that port 5011 is open on your system for the Worker Node to function correctly.
By following these updated instructions, you can successfully install or update your BrinxAI Worker Nodes on both Linux and Windows platforms.


Stay Connected

-Website:
https://brinxai.com

-Twitter:
https://x.com/BrinxAi_Labs

-Discord:
https://discord.com/invite/JVR2RTtQy8
