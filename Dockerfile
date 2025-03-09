# Use a imagem base oficial do Python 3.11 baseada no Debian Bookworm
FROM python:3.11-slim-bookworm

# Defina variáveis de ambiente para segurança e otimização
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1

# Crie um usuário não root para executar a aplicação.  O Debian Bookworm já inclui
# um usuário 'python' por padrão, mas vamos criar o nosso para maior controle.
RUN useradd -ms /bin/bash appuser
USER appuser

# Defina o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copie apenas o necessário para a instalação das dependências (use .dockerignore)
COPY --chown=appuser:appuser requirements.txt .

# Instale as dependências do projeto.  Use --no-cache-dir para evitar
# armazenar cache desnecessário, reduzindo o tamanho da imagem.  O --user
# instala os pacotes no diretório home do usuário, evitando problemas de
# permissão.
RUN pip install --no-cache-dir --user -r requirements.txt

# Copie o restante do código da aplicação (tudo exceto o que estiver no .dockerignore)
COPY --chown=appuser:appuser . .

# Exponha a porta em que a aplicação Flask irá rodar (padrão é 5000)
EXPOSE 5000

# Comando para executar a aplicação.  Como estamos usando um usuário não root,
# não precisamos de 'sudo'.  O 'python' aqui se refere ao executável do Python
# instalado no sistema.
CMD ["python", "app.py"]