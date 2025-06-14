#!/usr/bin/env bash
PACKAGES=(
  ##########################################################################################
  # Themes, Cursors and Fonts
  ##########################################################################################
  arc-darkest-theme-git numix-gtk-theme-git papirus-icon-theme
  ttf-hack-nerd awesome-terminal-fonts noto-fonts noto-fonts-extra
  noto-fonts-emoji noto-fonts-cjk ttf-firacode-nerd vimix-cursors
  otf-font-awesome ttf-nerd-fonts-symbols-mono ttf-cascadia-code-nerd
  ttf-font-awesome ttf-jetbrains-mono-nerd ttf-meslo-nerd ttf-ubuntu-mono-nerd
  ttf-dejavu ttf-liberation adobe-source-sans-fonts ttf-droid
  ##########################################################################################
  # Utils
  ##########################################################################################
  a2ln eza fastfetch kitty fd gdu gimp-git jamesdsp less mpv nmap
  qalculate-gtk qbittorrent ueberzugpp vlc zapzap cronie
  blueberry-wayland swappy grim wl-clipboard slurp copyq duf
  gdu bat fuzzel waybar nwg-look imagemagick swaync yt-dlp kdenlive
  telegram-desktop dosfstools firefox pavucontrol-qt
  evince network-manager-applet net-tools btop wget 7zip stow
  entr ristretto man-db man-pages tldr cava rsync
  ##########################################################################################
  # zsh
  ##########################################################################################
  zsh zoxide the_silver_searcher yazi-git zsh-autocomplete zellij
  zsh-autosuggestions
  ##########################################################################################
  # Bluetooth
  ##########################################################################################
  bluez bluez-utils
  ##########################################################################################
  # Printer
  ##########################################################################################
  cups cups-browsed
  ##########################################################################################
  # mouse mx master 3s
  ##########################################################################################
  solaar
  ##########################################################################################
  # neovim
  ##########################################################################################
  neovim-git lazygit luarocks shfmt pyright
  ripgrep fzf prettier lolcat jp2a fish lynx tectonic
  composer php github-cli python-pygobject-stubs lua51
  ##########################################################################################
  # btrfs
  ##########################################################################################
  snapper-support btrfs-assistant
  ##########################################################################################
  # hyprland
  ##########################################################################################
  sddm pyprland-git hyprland hyprsysteminfo hyprpolkitagent hyprpicker
  hyprpaper hyprlock hypridle hyprutils hyprpaper xdg-desktop-portal-hyprland
  ##########################################################################################
  # meus apps aur
  ##########################################################################################
  pypi2aur hyprtiler hyprpwmenu hyprnav
  ##########################################################################################
  # nemo filemanager
  ##########################################################################################
  nemo nemo-audio-tab nemo-emblems nemo-fileroller nemo-image-converter
  nemo-pastebin nemo-preview nemo-python nemo-seahorse
  nemo-share nemo-compare nemo-media-columns
  nemo-mediainfo-tab nemo-copypath nemo-webp-git
  ##########################################################################################
  # Development
  ##########################################################################################
  cmake visual-studio-code-bin
  # Drivers
  vulkan-mesa-layers vulkan-radeon
  ##########################################################################################
  # Python
  ##########################################################################################
  uv python-pynvim python-virtualenv python-rich python-inquirerpy
  python-black python-pip python-pyfiglet python-pynvml
  ##########################################################################################
  # Android Development
  ##########################################################################################
  jdk-openjdk
  ##########################################################################################
  # Looking-glass
  ##########################################################################################
  cmake gcc libgl libegl fontconfig spice-protocol make nettle pkgconf binutils
  libxi libxinerama libxss libxcursor libxpresent libxkbcommon wayland-protocols
  libsamplerate dmidecode dkms looking-glass
)
