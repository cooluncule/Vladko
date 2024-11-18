FROM ubuntu:22.04
LABEL maintainer="Pixel Host <wingnut0310@gmail.com>"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV GOTTY_TAG_VER v1.0.1

# Install necessary tools and download gotty
RUN apt-get update && \
    apt-get install -y curl && \
    curl -sL https://github.com/yudai/gotty/releases/download/${GOTTY_TAG_VER}/gotty_linux_amd64.tar.gz \
    | tar xz -C /usr/local/bin && \
    apt-get purge --auto-remove -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the custom script
COPY run_gotty.sh /run_gotty.sh
RUN chmod +x /run_gotty.sh

# Expose the necessary port
EXPOSE 8080

# Default command to run gotty
CMD ["/bin/bash", "/run_gotty.sh"]
