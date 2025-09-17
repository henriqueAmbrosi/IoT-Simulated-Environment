# Ambiente Simulado de IoT

O seguinte repositório simula um ambiente de IoT utilizando ThingsBoard como broker MQTT/dashboard e o node-red como dispositivo IoT transmitindo telemtria. Além disso, as instruções abaixo permitem configurar um android como dispositivo IoT, sendo essa, uma etapa opcional.

## Configurando o ambiente

Para iniciar o ambiente, use o comando `docker compose up`, o qual iniciará todos os containers. 

### Broker

A primeira coisa para configurar o broker é criar o banco de dados e fazer o seeding dos usuários para o login. Para isso, rode o comando `docker compose run --rm -e INSTALL_TB=true -e LOAD_DEMO=true thingsboard-ce`. O comando, além de adicionar os usuários iniciais, adicionará alguns dispositivos entre outras configurações padrão da demo do ThingsBoard, os quais podem ser ignoradas.

Para configurar os dispositivos e dashboards no Thingsboard, abra no navegador `http://localhost:8080`, em seguida acesse o sistema com as seguintes credenciais
```
Email: tenant@thingsboard.org
Senha: tenant
```
Após, vá para `Advanced Features > Version control

Será necessário adicionar o repositório que controla o versionamento da aplicação. O repositório é público e pode ser encontrado nesse [link](https://github.com/henriqueAmbrosi/Thingsboard-Config). Para puxar as configurações do broker, também será necessário uma conta no Github.

Após configurar o repositório de backup, selecione o backup com a versão mais recente. Isso puxará todos os dados necessários finalizando a configuração do ThingsBoard

### Devices 

## Serviços

ThingsBoard 
- UI - http://localhost:8080
- MQTT - localhost:1883

Node-Red
- UI - http://localhost:1880

PgAdmin
- UI - http://localhost:5050
