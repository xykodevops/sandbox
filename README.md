# Cash Flow App

A aplicação em questão é um programa em **Ruby** que utiliza o **framework Sinatra** para criar uma aplicação web para gerenciamento de transações financeiras. O objetivo do programa é permitir o registro de transações de crédito e débito, armazenando-as em um arquivo YAML, bem como gerar um resumo das transações registradas.


# Requisitos

Para executar a aplicação, é necessário ter o Ruby 2.0 ou superior instalado no sistema. Além disso, as seguintes bibliotecas também são utilizadas e devem estar disponíveis:*
- Sinatra
- YAML
- PUMA

Para instalar as bibliotecas necessárias, pode-se utilizar o gerenciador de pacotes do Ruby, o gem. Exemplo:
```
			gem install sinatra
			gem install yaml
			gem install puma
```
## Uso

Para executar a aplicação, basta executar o arquivo cash_flow:
```
		      ruby cash_flow
```
O servidor web será iniciado e estará acessível em http://localhost:8080.

``![HomePage](/img/home_page.png)
*Apresentação da home Page da aplicação. Após preencher os campos valor, descrição e opção de crédito/débito, pressionar em "Salvar Transação". O botão "Apresentar Fluxo de Caixa" redirecionará para o sumário de todos os dias registrados.*

``![Summary](/img/summary.png)
*A página que apresenta o "Fluxo de Caixa" mostra a movimentação totalizada diáriamente e o fluxo final (contabilidade do caixa diário). Cada dia têm um link que redicionará para a apresentação do fluxo de caixa no dia específico (botão "Fluxo"). 

``![SummaryDay](/img/summary_day.png)
*A página que apresenta todo o "Fluxo de Caixa" realizado em um dia especifico. 


## Funcionamento

### Classe Transaction
A classe Transaction é a classe base para as classes Credit e Debit. Possui três atributos: amount (valor da transação), date (data da transação) e description (descrição da transação).

### Rotas

**GET '/'**
A rota GET '/' renderiza a página inicial da aplicação, que contém um formulário para adicionar novas transações.

**POST '/cashflow'**
A rota POST '/cashflow' recebe os parâmetros enviados pelo formulário na página inicial e armazena a transação em um arquivo YAML. Os parâmetros são:

amount (valor da transação)
description (descrição da transação)
type (tipo da transação: "C" para crédito e "D" para débito)
date (data da transação)

**GET '/summary'**
A rota GET '/summary' renderiza uma página com um resumo das transações registradas. As transações são agrupadas por data e separadas em transações de crédito e débito. O resumo é apresentado em uma tabela, contendo as datas, o total de créditos e o total de débitos.

**GET '/summary/:date'**
A rota GET '/summary/:date' renderiza uma página com o resumo das transações registradas em uma determinada data. As transações são filtradas pela data e apresentadas em uma tabela, contendo o valor, a descrição e o tipo da transação.

## Arquivo transactions.yml
As transações são armazenadas em um arquivo YAML chamado transactions.yml. Cada transação é armazenada em um hash, contendo os seguintes campos:
```
		amount (valor da transação)
		description (descrição da transação)
		type (tipo da transação: "C" para crédito e "D" para débito)
		date (data da transação)
```
As transações são armazenadas em um array chamado transactions. O arquivo é atualizado a cada nova transação registrada.

## Hospedagem do código.

A aplicação está armazenada no github (perfil público) e pode ser acessada pela seguinte url:
  **https://github.com/xykodevops/act_challenge.git**

## Conclusão

Esta documentação técnica apresentou uma visão geral da aplicação em Ruby que utiliza o framework Sinatra para gerenciamento de transações financeiras. O programa é capaz de armazenar transações em um arquivo YAML.

# Cash Flow in Docker

 **Premissa Docker instalado** no cliet/server que hospedará a aplicação.

***Metodo 1*** - Contruir a imagem diretamente do github:

       ```$ docker build -t cash_flow https://github.com/xykodevops/act_challenge.git#main```

***Método 2*** - Construir a imagem localmente após clonar o repositório:
```
		$ git clone https://github.com/xykodevops/act_challenge.git
		$ cd act_challenge
		$ docker build -t cash_flow .
```
Em ambos o docker environment deverá responder assim:
```
	$ docker images
	REPOSITORY   TAG       IMAGE ID       CREATED              SIZE
	cash_flow    latest    3f05298be882   About a minute ago   915MB
	ruby         3.2.2     5cd2088ddc0d   28 hours ago         892MB
```

O start do container em backgound poderá ser feito da seguite forma:

```$ docker run -p 8080:8080 -d cash_flow```

Verifique se a aplicação subiu sem erro:
```
	$ netstat -an |grep LISTEN |grep 8080
	tcp        0      0 0.0.0.0:8080            0.0.0.0:*               LISTEN     
	tcp6       0      0 :::8080                 :::*                    LISTEN
```
Identificando o container:
```
     $docker ps
	 CONTAINER ID   IMAGE       COMMAND                  CREATED         STATUS         PORTS                                       NAMES
	 0c1de499aa9a   cash_flow   "ruby cash_flow -o 0…"   2 minutes ago   Up 2 minutes   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   eloquent_archimedes
```
```$  docker logs $(docker ps -q --filter ancestor=cash_flow)```

Agora basta acessar a aplicação via browser como "http://localhost:8080"

Caso seja necessario parar o container basta digitar:
	```$ docker stop $(docker ps -q --filter ancestor=cash_flow)```
Necessitando limpar todo o ambiente, utilize:
		```$ docker system prune -af --volumes```


## Code Analysis

# Rspec

Os testes são unitários apra a aplicação cash_flow . Ele usa a biblioteca RSpec para escrever e executar testes e a biblioteca Rack::Test para testar o aplicativo web.
Ele é dividido basicamente em 3 partes:
A primeira seção valida o objeto Transaction e suas instâncias.
A segunda seção testa a criação de objetos Debit e Credit e verifica se eles são instâncias de Transaction foram associadas corretamente.
A terceira seção testa o aplicativo web em si. Ele inclui o módulo Rack::Test::Methods para permitir verificar o acesso as rotas. Cada rota HTTP é testada de forma diferente verificando a funcionalidade do aplicativo e retono esperado.

O primeiro teste acessa a raiz do aplicativo '/' e verifica se a resposta é bem-sucedida (código HTTP 200).
O segundo teste acessa a rota '/summary' e verifica se a resposta é bem-sucedida (código HTTP 200).
O terceiro teste envia uma transação ao aplicativo usando a rota '/cashflow' e verifica se a resposta é um redirecionamento (código HTTP 302). Em seguida, segue o redirecionamento e verifica se a rota atual é a raiz do aplicativo.
O quarto teste envia uma transação ao aplicativo usando a rota '/cashflow' e, em seguida, acessa a rota '/summary/2023-05-05' para ver o resumo do fluxo de caixa para esse dia específico. Ele verifica se a resposta é bem-sucedida (código HTTP 200).
Esses testes ajudam a garantir que o aplicativo de fluxo de caixa esteja funcionando corretamente e possa detectar erros ou regressões à medida que o código é modificado ou atualizado.

Para rodar os testes unitários , basta usar o comando abaixo, na raiz do projeto:
	```
	rspec spec/cash_flow_spec.rb
	```

O resultado esperado é:

![RSpec](/img/rspec.png)

*Resultado do comando rspec aplicado ao projeto.


# Rubocop

Para rodar a verificação do código, basta usar o comando abaixo, na raiz do projeto:
	```
	rrubocop
	```

O resultado esperado é:

![RSpec](/img/rubocop.png)

*Resultado do comando rubocop aplicado ao projeto.



## Arquitetura da Aplicação

A aplicação é composta pelos seguintes componentes:

- `cash_flow.rb`: arquivo principal que define as rotas e o comportamento da aplicação.
- `views/`: diretório que contém os arquivos de visualização (templates) usados pela aplicação.
- `img/`: diretório que contém arquivos estáticos.
- `spec/`: diretório que contém os arquivos de teste da aplicação.
- `Gemfile`: arquivo que define as dependências da aplicação.
- `Dockerfile`: Instruções básicas para subir a aplicação em um container.

A aplicação segue uma arquitetura MVC (Model-View-Controller), em que:

- O `cashPflow.rb` atua como o controlador da aplicação, recebendo solicitações HTTP e lidando com as respostas.
- Os arquivos em `views/` atuam como as visualizações da aplicação, exibindo dados para o usuário e recebendo entrada do usuário.
- Os arquivos YAML em `data/` atuam como o modelo da aplicação, armazenando e recuperando dados.
- Os arquivos em `spec/` atuam como testes automatizados da aplicação.

A aplicação usa as seguintes tecnologias:

- Sinatra: um framework de aplicação web em Ruby.
- YAML: uma linguagem de serialização de dados.
- RSpec: um framework de teste para Ruby.
- Rack: uma interface entre servidores web e aplicativos Ruby.


## Diagrama da Aplicação

A Aplicação consiste básicamente no relacionamento de 3 classes:

	- Transaction
	- Debit
	- Credit

A classe Transaction é a superclasse, e as classes Debit e Credit são subclasses que herdam seus atributos e métodos. Além disso, podemos considerar uma classe Transaction_Store para lidar com o armazenamento das transações em um arquivo YAML.

O diagrama de classes ficaria da seguinte forma:

O resultado esperado é:

![Diagrama de Classes](/img/classes.png)


Neste diagrama, podemos ver que Debit e Credit são subclasses de Transaction, que contém os atributos amount, date e description. A classe Transaction_Store é responsável por lidar com o armazenamento das transações em um arquivo YAML, representado pelo atributo file_path.

Além do diagrama de classes, podemos também criar um diagrama de casos de uso para representar as funcionalidades da aplicação. Para isso, podemos considerar os seguintes casos de uso:

Registrar uma transação
Visualizar o resumo das transações por dia
O diagrama de casos de uso ficaria da seguinte forma:

![Diagrama de Casos](/img/cases.png)


