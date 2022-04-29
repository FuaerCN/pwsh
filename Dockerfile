FROM debian:10-slim

RUN apt-get update -y \
    && apt-get install -y curl gnupg apt-transport-https ca-certificates \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/microsoft.list' \
    && curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ bionic main" | tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-get update -y \
    && apt-get install -y powershell azure-cli \
    && wget -qO /usr/bin/ttyd https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64 \
    && chmod +x /usr/bin/ttyd

WORKDIR /home
RUN pwsh -c "Install-Module -Scope AllUsers AzureAD,MSOnline,PnP.PowerShell -Force"

CMD ttyd -p 8080 -t titleFixed=PowerShell pwsh
