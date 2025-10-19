#!/bin/bash
set -e

TB_CONTAINER="thingsboard-ce"

echo "==========================================="
echo "Iniciando o ambiente Docker Compose..."
echo "==========================================="
docker compose up -d

# Espera o ThingsBoard iniciar
echo "Aguardando ThingsBoard iniciar..."
until [ "$(docker inspect -f '{{.State.Running}}' $TB_CONTAINER 2>/dev/null)" == "true" ]; do
    sleep 5
    echo "ThingsBoard ainda não está pronto..."
done

echo "ThingsBoard está rodando."

echo "Verificando necessidade de popular DB do ThingsBoard"
if docker compose run --rm -e INSTALL_TB=true -e LOAD_DEMO=true $TB_CONTAINER >/dev/null 2>&1; then
    echo "DB populado com sucesso!"
else
    echo "População já foi realizada. Continuando..."
fi

echo "==========================================="
echo "Ambiente IoT pronto para uso!"
echo "UI ThingsBoard: http://localhost:8080"
echo "MQTT: localhost:1883"
echo "Node-RED: http://localhost:1880"
echo "PgAdmin: http://localhost:5050"
echo "==========================================="