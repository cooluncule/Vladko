# Use a base image that supports systemd, for example, Ubuntu
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y shellinabox systemd systemd-sysv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set the root password (for shellinabox)
RUN echo 'root:root' | chpasswd

# Expose the web-based terminal port
EXPOSE 4200

# Copy a script to initialize systemd
COPY init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

# Set the default command to initialize systemd and start shellinabox
CMD ["/usr/local/bin/init.sh"]
