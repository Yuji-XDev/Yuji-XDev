#!/bin/bash

# ====== COLORES ======
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
RESET="\033[0m"

# ====== FUNCIONES ======
loading() {
    msg=$1
    echo -ne "${YELLOW}${msg}"
    for i in {1..3}; do
        echo -ne "."
        sleep 0.5
    done
    echo -e "${RESET}"
}

typewriter() {
    text=$1
    for (( i=0; i<${#text}; i++ )); do
        echo -ne "${CYAN}${text:$i:1}${RESET}"
        sleep 0.02
    done
    echo ""
}

progress_bar() {
    msg=$1
    echo -ne "${MAGENTA}${msg}${RESET}\n"
    bar="████████████████████"
    for i in $(seq 1 20); do
        echo -ne "${CYAN}[${bar:0:i}${WHITE}${bar:i}] $((i*5))% \r"
        sleep 0.1
    done
    echo -e "\n${GREEN}✔ Completado${RESET}\n"
    sleep 0.3
}

progress_gitpush() {
    echo -e "${MAGENTA}🚀 Subiendo archivos a GitHub...${RESET}"
    total_steps=6
    step=0
    git push -u origin main 2>&1 | while read -r line; do
        if [[ "$line" =~ (Counting|Compressing|Writing|Delta|Total|Receiving) ]]; then
            step=$((step + 1))
            percent=$(( step * 100 / total_steps ))
            filled=$(( percent / 5 ))
            empty=$(( 20 - filled ))
            bar=$(printf "%${filled}s" | tr ' ' '█')$(printf "%${empty}s")
            printf "${CYAN}[%-20s] %3d%%${RESET} ${WHITE}%s${RESET}\r" "$bar" "$percent" "$line"
        fi
    done
    echo -e "\n${GREEN}✔ Push completado con éxito${RESET}"
}

banner() {
    clear
    echo -e "${MAGENTA}"
    echo "╔════════════════════════════════════════╗"
    echo "║                                        ║"
    echo "║   ██████╗ ██╗████████╗██╗  ██╗██████╗   ║"
    echo "║  ██╔═══██╗██║╚══██╔══╝██║  ██║██╔══██╗  ║"
    echo "║  ██║   ██║██║   ██║   ███████║██████╔╝  ║"
    echo "║  ██║▄▄ ██║██║   ██║   ██╔══██║██╔═══╝   ║"
    echo "║  ╚██████╔╝██║   ██║   ██║  ██║██║       ║"
    echo "║   ╚══▀▀═╝ ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝       ║"
    echo "║                                        ║"
    echo "║            POWERED BY SHADOW.XYZ                  ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${RESET}"
}

# ====== INICIO ======
banner
typewriter "✨ Bienvenido al instalador mágico de Shadow.xyz ✨"
echo ""
sleep 0.5

read -p "🍂 Ruta de la carpeta: " folder_path
read -p "🌱 URL del repositorio (https://github.com/...): " repo_url

if [ ! -d "$folder_path" ]; then
  echo -e "${RED}❌ Error: Carpeta no encontrada.${RESET}"
  exit 1
fi

cd "$folder_path" || exit

progress_bar "⚙️ Añadiendo directorio seguro"
git config --global --add safe.directory "$folder_path"

if [ ! -d ".git" ]; then
  progress_bar "📂 Inicializando repositorio"
  git init &>/dev/null
fi

progress_bar "📦 Agregando archivos"
git add . &>/dev/null

read -p "☘️ Mensaje del commit: " commit_message
progress_bar "📝 Realizando commit"
git commit -m "$commit_message" &>/dev/null

progress_bar "🌱 Configurando rama main"
git branch -M main &>/dev/null

progress_bar "🔗 Configurando remoto"
git remote add origin "$repo_url" &>/dev/null

progress_gitpush

echo -e "${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"