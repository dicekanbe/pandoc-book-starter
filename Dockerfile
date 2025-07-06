FROM pandoc/latex:latest-ubuntu

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    make \
    wget \
    unzip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm for Mermaid CLI
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Install Mermaid CLI
RUN npm install -g @mermaid-js/mermaid-cli@10.9.1

# Install fonts (if they exist)
RUN mkdir -p /usr/share/fonts/truetype
COPY shared/ /tmp/shared/
RUN if [ -d "/tmp/shared/assets/fonts" ] && [ "$(ls -A /tmp/shared/assets/fonts 2>/dev/null)" ]; then \
      cp -r /tmp/shared/assets/fonts/* /usr/share/fonts/truetype/ && \
      echo "Fonts installed successfully"; \
    else \
      echo "No fonts found, skipping font installation"; \
    fi

# Update font cache
RUN fc-cache -f -v

# Set working directory
WORKDIR /data

# Default command
CMD ["pandoc", "--help"]
