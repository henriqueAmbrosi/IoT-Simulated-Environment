#!/bin/bash
set -e

TB_CONTAINER="thingsboard-ce"

echo "==========================================="
echo "Iniciando o ambiente Docker Compose..."
echo "==========================================="
docker compose up -d

# -----------------------------
# Espera o ThingsBoard iniciar
# -----------------------------
echo "Aguardando ThingsBoard iniciar..."
until [ "$(docker inspect -f '{{.State.Running}}' $TB_CONTAINER 2>/dev/null)" == "true" ]; do
    sleep 5
    echo "ThingsBoard ainda não está pronto..."
done

# -----------------------------
# Popula o banco de dados se necessário
# -----------------------------

ATTEMPT=1
MAX_ATTEMPTS=10

until docker exec kafka kafka-topics.sh --bootstrap-server kafka:9092 --list 2>/dev/null | grep -q "tb_rule_engine.hp.0"; do
    echo "Executando inicialização do ThingsBoard (Tentativa $ATTEMPT/$MAX_ATTEMPTS)"
    docker compose run --rm -e INSTALL_TB=true -e LOAD_DEMO=true "$TB_CONTAINER" >/dev/null 2>&1 || true 
    docker compose restart "$TB_CONTAINER" >/dev/null 2>&1

    sleep 10
    ATTEMPT=$((ATTEMPT + 1))

    if [ $ATTEMPT -gt $MAX_ATTEMPTS ]; then
        echo "Não foi possível inicializar o ThingsBoard após $MAX_ATTEMPTS tentativas."
        exit 1
    fi

    
done

echo "==========================================="
echo "Ambiente IoT pronto para uso!"
echo "UI ThingsBoard: http://localhost:8080"
echo "MQTT: localhost:1883"
echo "Node-RED: http://localhost:1880"
echo "PgAdmin: http://localhost:5050"
echo "==========================================="
