#!/bin/bash

# Nome do executável
APP_NAME="SponteStudy"

echo "Iniciando o processo de build para $APP_NAME..."

# Verifica se o Python está instalado
if ! command -v python3 &> /dev/null; then
    echo "Erro: Python3 não encontrado. Por favor, instale o Python."
    exit 1
fi

# Instala as dependências necessárias
echo "Instalando dependências..."
python3 -m pip install customtkinter CTkToolTip pyttsx3 Pillow pygments

# Verifica se o PyInstaller está instalado
if ! command -v pyinstaller &> /dev/null; then
    echo "Instalando PyInstaller..."
    python3 -m pip install pyinstaller
fi

# Limpa builds anteriores
rm -rf build dist

# Executa o PyInstaller
# O sinalizador --add-data inclui a pasta de imagens no executável
# O formato é 'origem:destino'
echo "Gerando executável..."
pyinstaller --noconfirm --onefile --windowed \
    --add-data "imagens_app:imagens_app" \
    --name "$APP_NAME" \
    interface.py

echo "Build concluído! O executável está na pasta 'dist'."