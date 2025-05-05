#!/usr/bin/env bash

# shellcheck disable=SC2034
PACKAGES=(
  # Themes, Cursors and Fonts
  arc-darkest-theme-git dracula-cursors-git kvantum-theme-materia
  numix-gtk-theme-git papirus-icon-theme papirus-nord ttf-firacode
  ttf-hack-nerd awesome-terminal-fonts noto-fonts-emoji
  noto-fonts-extra noto-fonts-cjk ttf-firacode-nerd
  # Utils
  #
  a2ln eza fastfetch kitty fd gdu gimp-git jamesdsp sublime-text-4 less
  lazygit luarocks mpv nmap qalculate-gtk qbittorrent ueberzugpp vlc
  whatsdesk-bin xdo shfmt fisher cronie pyright
  blueberry-wayland swappy grim wl-clipboard slurp copyq duf
  gdu bat plocate fuzzel waybar otf-font-awesome
  nwg-look ripgrep fzf imagemagick swaync yt-dlp kdenlive
  telegram-desktop dosfstools luajit-tiktoken-bin lynx
  prettier lolcat jp2a firefox pavucontrol-qt evince network-manager-applet
  net-tools btop ghostty wget 7zip stow
  # zsh
  zsh zoxide the_silver_searcher yazi-git
  # Bluetooth
  bluez bluez-utils
  # Printer
  cups cups-browsed
  # mouse mx master 3s
  solaar
  # btrfs
  snapper-support btrfs-assistant
  # hyprland
  sddm pyprland-git hyprland hyprsysteminfo hyprpolkitagent hyprpicker
  hyprpaper hyprlock hypridle hyprutils hyprpaper xdg-desktop-portal-hyprland
  # meus apps aur
  pypi2aur hyprtiler hyprpwmenu hyprnav
  # nemo filemanager
  nemo nemo-audio-tab nemo-emblems nemo-fileroller nemo-image-converter
  nemo-pastebin nemo-preview nemo-python nemo-seahorse
  nemo-share nemo-compare nemo-media-columns
  nemo-mediainfo-tab nemo-copypath nemo-webp-git
  # Development
  cmake visual-studio-code-bin
  # Drivers
  vulkan-mesa-layers vulkan-radeon
  # Python
  uv python-pynvim python-virtualenv python-rich
  # Android Development
  jdk-openjdk
  # Looking-glass
  cmake gcc libgl libegl fontconfig spice-protocol make nettle pkgconf binutils
  libxi libxinerama libxss libxcursor libxpresent libxkbcommon wayland-protocols
  ttf-dejavu libsamplerate dmidecode dkms looking-glass

)
