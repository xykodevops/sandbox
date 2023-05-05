Dependências
Para executar a aplicação, é necessário ter instalado no sistema as seguintes dependências:

Ruby: linguagem de programação utilizada na aplicação.
Sinatra: framework web utilizado para criar a aplicação.
YAML: biblioteca de serialização/deserialização utilizada para armazenar as transações em um arquivo.
Executando a aplicação
Para executar a aplicação, execute o comando ruby nome_do_arquivo.rb no terminal, substituindo "nome_do_arquivo" pelo nome do arquivo da aplicação.

Por padrão, a aplicação será executada na porta 8080. Para acessá-la, basta abrir um navegador e digitar http://localhost:8080 na barra de endereços.

Funcionamento
A aplicação possui três rotas:

/: rota principal da aplicação, que exibe um formulário para adicionar uma nova transação.
/cashflow: rota que processa o formulário enviado pela rota principal e armazena a transação em um arquivo YAML.
/summary: rota que exibe um resumo das transações agrupadas por dia.
Classes
Transaction
Representa uma transação financeira. Possui os seguintes atributos:

amount: valor da transação.
date: data da transação.
description: descrição da transação.
Debit
Representa uma transação de débito. Herda os atributos e métodos da classe Transaction.

Credit
Representa uma transação de crédito. Herda os atributos e métodos da classe Transaction.

Constantes
Transaction_Type
Hash que mapeia os códigos de tipo de transação (D para débito e C para crédito) para uma descrição mais amigável ao usuário.

Rotas
Rota /
Rota principal da aplicação, que exibe um formulário para adicionar uma nova transação.

Métodos HTTP
GET: exibe o formulário para adicionar uma nova transação.
Parâmetros
Não há parâmetros nesta rota.

Respostas
200 OK: exibe o formulário para adicionar uma nova transação.
Template
A rota / utiliza o template index.erb, que contém o formulário para adicionar uma nova transação.

Rota /cashflow
Rota que processa o formulário enviado pela rota principal e armazena a transação em um arquivo YAML.

Métodos HTTP
POST: processa o formulário enviado pela rota principal.
Parâmetros
A rota /cashflow espera os seguintes parâmetros no corpo da requisição:

amount: valor da transação.
description: descrição da transação.
type: tipo da transação (D para débito e C para crédito).
date: data da transação.
Respostas
302 Found: redireciona para a rota principal após armazenar a transação.
400 Bad Request: exibe uma mensagem de erro caso algum dos parâmetros esteja ausente ou inválido.
Rota /summary
Rota que exibe um resumo das transações agrupadas por dia.





