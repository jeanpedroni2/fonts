# .devcontainer/Dockerfile

# Usa a imagem oficial Ruby 3.2 como base
FROM ruby:3.2
# ➡️ Define a base do container com Ruby 3.2, garantindo o ambiente para executar apps Rails.

# Atualiza o sistema de pacotes e instala Node.js, Yarn e cliente PostgreSQL
RUN apt-get update -qq && \
    apt-get install -y nodejs yarn postgresql-client
# ➡️ Node.js e Yarn são necessários para o pipeline de assets do Rails (JavaScript e CSS).
# ➡️ postgresql-client é útil para comandos como `rails db` que interagem com o banco.

# Instala o Rails globalmente dentro do container
RUN gem install rails
# ➡️ Torna o comando `rails` disponível no container, para rodar `rails new` e outras tasks Rails.

# Define a pasta de trabalho dentro do container
WORKDIR /workspace
# ➡️ Define a pasta onde o código-fonte do projeto será montado no container.

# Copia o Gemfile e o Gemfile.lock (se existirem) para instalar dependências
COPY Gemfile Gemfile.lock ./
# ➡️ Copia primeiro as dependências para aproveitar cache de builds futuros.
# ➡️ Se o Gemfile.lock não existir ainda, a cópia vai falhar, então pode usar `COPY Gemfile* ./` como fallback.

# Instala o Bundler e as gems definidas no Gemfile
RUN gem install bundler && \
    bundle install || true
# ➡️ Instala a gem bundler para gerenciar dependências Ruby.
# ➡️ bundle install instala todas as gems do projeto.
# ➡️ O `|| true` evita falhas caso o Gemfile.lock ainda não exista.

# Copia o restante do código do projeto (após instalar as gems)
COPY . .
# ➡️ Copia todos os arquivos restantes do projeto para o container.
# ➡️ Deve vir DEPOIS do bundle install para aproveitar o cache (se nada mudou no Gemfile, o bundle não roda de novo).

# Expõe a porta padrão do Rails para acessar a aplicação localmente
EXPOSE 3000
# ➡️ Permite acessar a aplicação Rails via localhost:3000 no navegador.
