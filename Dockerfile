FROM tecolicom/texlive-pandoc-ja:latest

RUN tlmgr option repository http://mirror.ctan.org/systems/texlive/tlnet

RUN set -eux; \
  tlmgr update --self; \
  tlmgr install \
    luatexja \
    lualatex-math unicode-math \
    selnolig \
    collection-latexextra collection-fontsrecommended; \
  mktexlsr

RUN apt-get update && \
  apt-get install -y --no-install-recommends fonts-noto-cjk fonts-noto-mono && \
  fc-cache -fv && \
  rm -rf /var/lib/apt/lists/*

# Install Node.js 22.x
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs

# Install Mermaid CLI
RUN npm install -g @mermaid-js/mermaid-cli@10.9.1

WORKDIR /data
CMD ["pandoc", "--help"]

