# Ambiente Simulado de IoT

O seguinte repositório simula um ambiente de IoT utilizando ThingsBoard como broker MQTT/dashboard e o node-red como dispositivo IoT transmitindo telemtria. Além disso, as instruções abaixo permitem configurar um aparelho android como dispositivo IoT, sendo essa, uma etapa opcional.

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

Para os devices, simularemos um dispositivo no próprio PC que mandará dados de telemetria gerados aleatoriamente. Para isso, abra o [node-red](http://localhost:1880), clique no menu do canto superior direito (três barrinhas) e selecione import. Copie e cole o conteúdo do arquivo /iot-device/PC_Devices.json e clique em import.

Tendo importado os dispositivos, basta clicar e deploy para iniciar a simulação dos dispositivos IOT.

#### Configurando o Android como dispositivo IOT

Também é possível configurar seu Android como dispositivo e utilizar os sensores reais dele. Para isso, é necessário instalar o Termux e Termux:API os quais vão simular um terminal linux e fornecer os comandos para acessar os sensores respectivamente. Para baixá-los, é recomendado utilizar a loja de aplicativos F-droid, a qual detem as versões mais atualizadas. Para os testes foram utilizadas as versões 0.118.3 do Termux e 0.53.0 do Termux:API. Após instalado, você pode testar o acesso aos sensores com os seguintes comandos:

```
termux-sensor -l // Lista todos os sensores disponíveis
termux-sensor -s "Sensor name" // Mostra informações do sensor em questão
                               // Caso informe um -n 1, lê apenas uma vez o sensor
termux-battery-status // Status da bateria
termux-location -p network -r once // Sensor de localização
```

OBS.: Para o sensor de localização utilizou-se a localização fornecida pela rede. Caso queira utilizar o próprio GPS do Android mude a flag `-p` para `gps`. Porém, a partir dos testes realizados, constatou-se que utilizando o GPS, muitas vezes o sensor não retorna nada por necessitar de visão para o céu, funcionando melhor em ambientes ao ar livre

Tendo os sensores funcionando, agora é hora de instalar o node-red no dispositivo. Para isso, rode os seguintes comandos:

```
pkg update && pkg upgrade
pkg install nodejs
npm install -g --unsafe-perm node-red
```

Esses comandos instalarão tanto o node como node-red e para iniciar o node-red, basta rodar o comando `node-red` e abrir o navegador em http://localhost:1880.

A importação do código para o node-red é bem similar com a dos dispositivos simulados no PC, porém ao invés de usar o /iot-device/PC_Devices.json, use /iot-device/Android.json. É importante validar que os comandos do sensor que estão pré configurados funcionem no seu dispositivo e caso não funcionem é necessário atualizá-los nos blocos de `exec` Light, Battery Telemetry e Location. Para referência, o dispositivo utilizado é um Galaxy A55 com o android 15.

Outra parte importante da configuração é apontar o nodo `mqtt out` para o thingsboard. Para isso, utilizou-se o Ngrok, um serviço de túnel com versões gratuita e paga. O Ngrok já está configurado no docker-compose, mas está comentado. Para habilitá-lo, crie uma conta gratuita do Ngrok a fim de obter um token de autenticação que deve ser passado no arquivo docker-compose. Depois disso, descomente a configuração do Ngrok e reinicie o docker-compose. Por fim, basta verificar nos logs qual o host gerado e substituí-lo no servidor configurado no node-red (você pode utilizar o comando `docker logs ngrok` para ver os logs). É importante ressaltar que toda vez que o Ngrok reiniciar, o host disponibilizado será diferente, o que exigirá mudar as configurações da conexão novamente.

## Serviços

ThingsBoard 
- UI - http://localhost:8080
- MQTT - localhost:1883

Node-Red
- UI - http://localhost:1880

PgAdmin
- UI - http://localhost:5050
