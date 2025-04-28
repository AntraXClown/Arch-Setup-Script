#!/usr/bin/env bash

# shellcheck disable=SC2034
PACKAGES=(
  # Themes, Cursors and Fonts
  arc-darkest-theme-git dracula-cursors-git kvantum-theme-materia
  numix-gtk-theme-git papirus-icon-theme papirus-nord ttf-firacode
  ttf-hack-nerd awesome-terminal-fonts noto-fonts-emoji
  noto-fonts-extra noto-fonts-cjk ttf-firacode-nerd

  # Utils
  a2ln eza fastfetch kitty fd gdu gimp-git jamesdsp sublime-text-4 less
  lazygit luarocks mpv nmap qalculate-gtk qbittorrent ueberzugpp vlc
  whatsdesk-bin xdo shfmt fisher cronie pyright ast-grep
  blueberry-wayland swappy grim wl-clipboard slurp copyq duf
  gdu bat plocate alacritty fuzzel waybar otf-font-awesome
  nwg-look ripgrep fzf imagemagick swaync yt-dlp kdenlive
  telegram-desktop dosfstools luajit-tiktoken-bin lynx
  prettier lolcat jp2a

  # Bluetooth
  bluez bluez-utils

  # Printer
  #
  cups cups-browsed

  # mouse mx master 3s
  solaar

  # btrfs
  snapper-support

  # hyprland
  hyprland-meta-git greetd-regreet

  # meus apps aur
  pypi2aur hyprtiler hyprpwmenu hyprnav

  # nemo filemanager
  nemo nemo-audio-tab nemo-emblems nemo-fileroller nemo-image-converter
  nemo-pastebin nemo-preview nemo-python nemo-seahorse
  nemo-share nemo-compare nemo-media-columns
  nemo-mediainfo-tab nemo-copypath nemo-webp-git

  # Development
  cmake visual-studio-code-bin

  # nvidia
  # nvidia-container-toolkit nvidia-settings

  # Python
  uv python-pynvim python-virtualenv python-rich

  # Android Development
  jdk-openjdk

)
