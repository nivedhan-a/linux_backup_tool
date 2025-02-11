#!/bin/bash

BACKUP_DIR="$HOME/backup_$(date +%Y%m%d)"
BACKUP_FILE="$HOME/backup.tar.gz"
PACKAGES=(git neofetch htop bash btop vim nano micro firefox wget curl tmux unzip tar zsh alacritty)

dialog --title "Backup and Restore Tool" --menu "Choose an option:" 15 50 4 \
1 "Backup System Files" \
2 "Restore Backup" \
3 "Install Essential Applications" \
2>temp_choice.txt

CHOICE=$(<temp_choice.txt)
rm temp_choice.txt

backup() {
    mkdir -p "$BACKUP_DIR"
    echo "Backing up system files..."
    tar -czvf "$BACKUP_FILE" \
        /home/nive/.AppImages/ \
        /home/nive/.config/zsh/ \
        /etc/fstab \
        /home/nive/.ssh/ \
        /home/nive/.local/share/ \
        /home/nive/.bashrc \
        /home/nive/.zshrc \
        /home/nive/.config/alacritty/ \
        /home/nive/.config/nvim/
    echo "Backup completed: $BACKUP_FILE"
}

restore() {
    if [ -f "$BACKUP_FILE" ]; then
        echo "Restoring backup..."
        tar -xzvf "$BACKUP_FILE" -C /
        echo "Restore completed."
    else
        echo "No backup file found!"
    fi
}

install_apps() {
    echo "Installing essential applications..."
    sudo pacman -S --needed "${PACKAGES[@]}"
    echo "Installation complete!"
}

case $CHOICE in
    1) backup ;;
    2) restore ;;
    3) install_apps ;;
    *) echo "Invalid option!" ;;
esac
