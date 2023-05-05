# Define a imagem base do Ruby
FROM ruby:3.2.2

# Define o diretório de trabalho
WORKDIR /app

# Copia os arquivos da aplicação para o container
COPY . .

# Instala as dependências do projeto
RUN bundle install

# Define a porta de exposição do container
EXPOSE 8080

# Define o comando para iniciar o servidor
CMD ["ruby", "cash_flow", "-o", "0.0.0.0"]
