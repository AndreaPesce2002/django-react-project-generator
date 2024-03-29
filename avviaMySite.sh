#!/bin/bash
# Funzione per terminare un processo che utilizza una determinata porta
terminate_process_on_port() {
    local port=$1
    local pid=$(lsof -t -i :$port)
    
    if [ -n "$pid" ]; then
        echo "Terminating process on port $port (PID: $pid)"
        kill -9 $pid
    fi
}

git fetch
git pull origin main

python backend/manage.py makemigrations
python backend/manage.py migrate7

pip freeze > requirements.txt

# libera le porte
terminate_process_on_port 8000
terminate_process_on_port 3000

# 11. Esegui il server Django in un nuovo terminale
gnome-terminal -- /bin/sh -c 'python backend/manage.py runserver; exec bash'

# 12. Naviga nella cartella del frontend e avvia il server npm in un altro nuovo terminale
gnome-terminal -- /bin/sh -c 'cd frontend; npm start; exec bash'
