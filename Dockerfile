FROM pandoc/latex:latest

# Install additional dependencies
RUN apk add --no-cache \
    make \
    wget \
    unzip

# Install fonts
RUN mkdir -p /usr/share/fonts/truetype
COPY shared/assets/fonts/*.ttf /usr/share/fonts/truetype/
COPY shared/assets/fonts/*.otf /usr/share/fonts/truetype/

# Update font cache
RUN fc-cache -f -v

# Set working directory
WORKDIR /workspace

# Copy project files
COPY . .

# Default command
CMD ["make", "help"]
