# Use a imagem base do PowerShell
FROM mcr.microsoft.com/powershell:lts-7.4-ubuntu-22.04

# Atualiza o sistema e instala dependências
RUN apt-get update && \
  apt-get install -y curl apt-transport-https ca-certificates gnupg lsb-release software-properties-common

# Instala o kubectl
RUN mkdir -p -m 755 /etc/apt/keyrings && \
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.33/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
  chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
  echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.33/deb/ /" > /etc/apt/sources.list.d/kubernetes.list && \
  apt-get update && \
  apt-get install -y kubectl

# Instala o Azure CLI
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
  install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ && \
  echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ jammy main" > /etc/apt/sources.list.d/azure-cli.list && \
  apt-get update && \
  apt-get install -y azure-cli && \
  rm microsoft.gpg

# Instala o mgc (Magalu Cloud CLI)
RUN gpg --yes --keyserver keyserver.ubuntu.com --recv-keys 0C59E21A5CB00594 && \
  gpg --export --armor 0C59E21A5CB00594 | gpg --dearmor -o /etc/apt/keyrings/magalu-archive-keyring.gpg && \
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/magalu-archive-keyring.gpg] https://packages.magalu.cloud/apt stable main" > /etc/apt/sources.list.d/magalu.list && \
  apt-get update && \
  apt-get install -y mgccli

# Limpa arquivos desnecessários
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Define o shell padrão como PowerShell
CMD ["pwsh"]