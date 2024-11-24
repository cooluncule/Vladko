# Use a base image that supports systemd, for example, Ubuntu
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y shellinabox && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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

# Start shellinabox
CMD ["/usr/bin/shellinaboxd", "-t", "-s", "/:LOGIN"]
