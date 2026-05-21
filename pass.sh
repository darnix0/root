#!/bin/bash

# Colores
R='\033[1;31m'
G='\033[1;32m'
C='\033[1;36m'
W='\033[1;37m'
N='\033[0m'

while true; do
clear

echo -e "${C}"
echo "╔══════════════════════════════════════╗"
echo "║          VPS DARNIX PANEL           ║"
echo "║         Configuración rápida        ║"
echo "╠══════════════════════════════════════╣"
echo -e "${W}║ ${G}[1]${W} Cambiar contraseña root      ║"
echo -e "║ ${G}[2]${W} Activar acceso con contraseña║"
echo -e "║ ${R}[0]${W} Salir                         ║"
echo -e "${C}╚══════════════════════════════════════╝${N}"
echo

read -p "Selecciona una opción: " op

case $op in

1)
    clear
    echo -e "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"
    echo -e "${W}        Cambiar contraseña Root"
    echo -e "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"
    echo
    echo "Ingresa tu nueva contraseña:"
    echo

    passwd root >/dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo
        echo -e "${G}✓ Contraseña actualizada correctamente${N}"
    else
        echo
        echo -e "${R}✗ No se pudo actualizar${N}"
    fi

    echo
    read -p "Presiona Enter para continuar..."
    ;;

2)
    clear
    echo -e "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"
    echo -e "${W}      Activar acceso por contraseña"
    echo -e "${C}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${N}"
    echo
    echo "Primero crea una nueva contraseña:"
    echo

    passwd root >/dev/null 2>&1

    if [ $? -ne 0 ]; then
        echo
        echo -e "${R}✗ Operación cancelada${N}"
        read -p "Presiona Enter..."
        continue
    fi

    echo
    echo "Configurando acceso..."
    sleep 1

    sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config >/dev/null 2>&1
    sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config >/dev/null 2>&1

    systemctl restart ssh >/dev/null 2>&1 || systemctl restart sshd >/dev/null 2>&1

    echo
    echo -e "${G}✓ Acceso configurado correctamente${N}"
    echo -e "${G}✓ Ya puedes ingresar usando contraseña${N}"

    echo
    read -p "Presiona Enter para continuar..."
    ;;

0)
    clear
    echo -e "${G}Hasta luego${N}"
    sleep 1
    exit
    ;;

*)
    echo
    echo -e "${R}Opción inválida${N}"
    sleep 1
    ;;
esac

done
