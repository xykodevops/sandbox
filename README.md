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

Esta documentação técnica apresentou uma visão geral da aplicação em Ruby que utiliza o framework Sinatra para gerenciamento de transações financeiras. O programa é capaz de armazenar transações em um arquivo YAML e

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

Agora basta acessar a aplicação via broswer como "http://localhost:8080"

Caso seja necessario parar o container basta digitar:
	```$ docker stop $(docker ps -q --filter ancestor=cash_flow)```

Necessitando limpar todo o ambiente, utilize:
		```$ docker system prune -af --volumes```
