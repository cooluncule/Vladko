# Use a base image that supports systemd, for example, Ubuntu
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y shellinabox wget unzip dos2unix && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install ngrok
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip && \
    unzip ngrok-stable-linux-amd64.zip && \
    mv ngrok /usr/local/bin/ && \
    rm ngrok-stable-linux-amd64.zip

# Set the root password (for shellinabox)
RUN echo 'root:root' | chpasswd

# Add a cool ASCII welcome banner and walkthrough with commands
RUN echo -e "\
  _____ _______   ________ _        _    _  ____   _____ _______ \n\
 |  __ \\_   _\\ \\ / /  ____| |      | |  | |/ __ \\ / ____|__   __|\n\
 | |__) || |   \\ V /| |__  | |      | |__| | |  | | (___    | |   \n\
 |  ___/ | |    > < |  __| | |      |  __  | |  | |\\___ \\   | |   \n\
 | |    _| |_  / . \\| |____| |____  | |  | | |__| |____) |  | |   \n\
 |_|   |_____/ /_\\_\\\\______|______| |_|  |_\\____/|_____/   |_|   \n\
                                                                 \n\
***********************************************\n\
***    Welcome to Your VPS!    ***\n\
***********************************************\n\
Here’s a quick walkthrough to get started:\n\
1. Use 'ls' to list files in the current directory.\n\
2. Use 'cd <directory>' to navigate to a folder.\n\
3. Use 'nano <filename>' to edit files directly in the terminal.\n\
4. Run 'top' to view system performance.\n\
5. Use 'man <command>' for command help.\n\
6. Use 'apt install <package>' to download and install programs.\n\
7. Use 'free -h' to see available RAM.\n\
8. Use 'df -h' to check disk space usage.\n\
Enjoy exploring your Linux environment!\n\
***********************************************" > /etc/motd

# Expose the web-based terminal port
EXPOSE 4200

# Add a script to run shellinabox and ngrok
RUN echo -e "\
#!/bin/bash\n\
# Ensure ngrok authtoken is set\n\
if [ -z \"${NGROK_AUTH_TOKEN}\" ]; then\n\
  echo \"Error: NGROK_AUTH_TOKEN is not set. Exiting.\"\n\
  exit 1\n\
fi\n\
# Configure ngrok with the provided authtoken\n\
ngrok config add-authtoken ${NGROK_AUTH_TOKEN}\n\
# Start shellinabox\n\
/usr/bin/shellinaboxd -t -s /:LOGIN &\n\
# Start ngrok to expose port 4200\n\
ngrok http 4200 --log=stdout\n" > /usr/local/bin/start.sh && \
    chmod +x /usr/local/bin/start.sh && \
    dos2unix /usr/local/bin/start.sh

# Environment variable for ngrok authtoken
ENV NGROK_AUTH_TOKEN=""

# Start shellinabox and ngrok
CMD ["/usr/local/bin/start.sh"]
