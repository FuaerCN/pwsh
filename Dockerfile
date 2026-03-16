FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    ca-certificates \
    apt-transport-https \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /usr/share/keyrings/microsoft.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ bookworm main" > /etc/apt/sources.list.d/azure-cli.list \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/debian/12/prod bookworm main" > /etc/apt/sources.list.d/microsoft-powershell.list

RUN apt-get update && apt-get install -y \
    azure-cli \
    powershell \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L "https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.$(uname -m)" -o /usr/local/bin/ttyd \
    && chmod +x /usr/local/bin/ttyd

RUN pwsh -c "Install-Module -Scope AllUsers AzureAD,PnP.PowerShell -Force"

EXPOSE 7681

ENTRYPOINT ["ttyd", "-t", "titleFixed=PowerShell", "-W", "pwsh"]
