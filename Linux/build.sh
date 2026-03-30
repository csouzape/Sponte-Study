#!/bin/bash
APP_NAME="SponteStudy"
echo "Iniciando o processo de build para $APP_NAME..."

if ! command -v python3 &> /dev/null; then
    echo "Erro: Python3 não encontrado. Por favor, instale o Python."
    exit 1
fi

echo "Instalando dependências..."
python3 -m pip install --upgrade pip
python3 -m pip install customtkinter CTkToolTip pyttsx3 Pillow pygments

echo "Verificando dependências de sistema para pyttsx3..."
if command -v apt-get &> /dev/null; then
    sudo apt-get install -y espeak espeak-data libespeak-dev python3-dbus
elif command -v dnf &> /dev/null; then
    sudo dnf install -y espeak python3-dbus
elif command -v pacman &> /dev/null; then
    sudo pacman -S --noconfirm espeak python-dbus
fi

if ! command -v pyinstaller &> /dev/null; then
    echo "Instalando PyInstaller..."
    python3 -m pip install pyinstaller
fi


rm -rf build dist __pycache__ *.spec


CTK_PATH=$(python3 -c "import customtkinter; import os; print(os.path.dirname(customtkinter.__file__))")
echo "CustomTkinter encontrado em: $CTK_PATH"


CTKCODEBOX_PATH="./CTkCodeBox"


echo "Gerando executável..."
pyinstaller --noconfirm --onefile --windowed \
    --add-data "imagens_app:imagens_app" \
    --add-data "$CTK_PATH:customtkinter" \
    --add-data "$CTKCODEBOX_PATH:CTkCodeBox" \
    --hidden-import "customtkinter" \
    --hidden-import "CTkToolTip" \
    --hidden-import "pyttsx3" \
    --hidden-import "pyttsx3.drivers" \
    --hidden-import "pyttsx3.drivers.espeak" \
    --hidden-import "pygments" \
    --hidden-import "pygments.lexers" \
    --hidden-import "pygments.formatters" \
    --hidden-import "PIL" \
    --hidden-import "PIL._tkinter_finder" \
    --collect-all customtkinter \
    --name "$APP_NAME" \
    interface.py


if [ -f "dist/$APP_NAME" ]; then
    chmod +x "dist/$APP_NAME"
    echo ""
    echo " Build concluído! Executável em: dist/$APP_NAME"
else
    echo ""
    echo " Falha no build. Verifique os erros acima."
    exit 1
fi