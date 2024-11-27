# Use a base image
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y shellinabox wget unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install ngrok
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip && \
    unzip ngrok-stable-linux-amd64.zip && \
    mv ngrok /usr/local/bin/ && \
    rm ngrok-stable-linux-amd64.zip

# Set the root password for shellinabox
RUN echo 'root:root' | chpasswd

# Add a welcome message
RUN echo -e "\
  Welcome to Your VPS! Here’s a quick walkthrough:\n\
  1. Use 'ls' to list files in the current directory.\n\
  2. Use 'cd <directory>' to navigate to a folder.\n\
  3. Use 'nano <filename>' to edit files directly in the terminal.\n\
  4. Run 'top' to view system performance.\n\
  5. Use 'man <command>' for command help.\n\
  6. Use 'apt install <package>' to install programs.\n\
  Enjoy exploring your Linux environment!" > /etc/motd

# Expose Shellinabox web interface port
EXPOSE 4200

# Create the startup script
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
    chmod +x /usr/local/bin/start.sh

# Ensure correct line endings (optional)
RUN apt-get update && apt-get install -y dos2unix && dos2unix /usr/local/bin/start.sh

# Environment variable for ngrok authtoken
ENV NGROK_AUTH_TOKEN=""

# Set the entrypoint to start.sh
CMD ["/usr/local/bin/start.sh"]
