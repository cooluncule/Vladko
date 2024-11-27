# Base image
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y shellinabox wget unzip dos2unix && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install ngrok
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip && \
    unzip ngrok-stable-linux-amd64.zip && \
    mv ngrok /usr/local/bin/ && \
    rm ngrok-stable-linux-amd64.zip

# Set root password for shellinabox
RUN echo 'root:root' | chpasswd

# Add a startup script
RUN echo -e "\
#!/bin/bash\n\
if [ -z \"${NGROK_AUTH_TOKEN}\" ]; then\n\
  echo \"Error: NGROK_AUTH_TOKEN is not set. Exiting.\"\n\
  exit 1\n\
fi\n\
# Configure ngrok with the auth token\n\
ngrok config add-authtoken ${NGROK_AUTH_TOKEN}\n\
# Start shellinabox in the background\n\
/usr/bin/shellinaboxd -t -s /:LOGIN &\n\
# Start ngrok to expose port 4200\n\
exec ngrok http 4200 --log=stdout\n" > /usr/local/bin/start.sh && \
    dos2unix /usr/local/bin/start.sh && chmod +x /usr/local/bin/start.sh

# Environment variable for ngrok
ENV NGROK_AUTH_TOKEN=""

# Expose shellinabox port
EXPOSE 4200

# Start the combined process
CMD ["/usr/local/bin/start.sh"]
