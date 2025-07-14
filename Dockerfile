FROM pandoc/latex:latest-ubuntu

# Install Node.js 20.x
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Install additional LaTeX packages for Japanese support
RUN apt-get update && \
    apt-get install -y \
    texlive-lang-japanese \
    texlive-latex-base \
    texlive-luatex \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-xetex \
    texlive-lang-cjk \
    texlive-lang-chinese \
    texlive-latex-recommended && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Mermaid CLI
RUN npm install -g @mermaid-js/mermaid-cli@10.9.1

# Set working directory
WORKDIR /data

# Install and cache fonts
RUN apt-get update && \
    apt-get install -y fonts-noto-cjk fonts-noto-mono && \
    fc-cache -fv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Default command
CMD ["pandoc", "--help"]
