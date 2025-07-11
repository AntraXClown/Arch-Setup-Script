#!/usr/bin/env bash

# Function install libvirt and start service virt-manager qemu
installLibvirt() {
  sudo pacman -S libvirt dnsmasq qemu-desktop virt-manager
  sudo usermod -aG libvirt "$USER"
  sudo usermod -aG kvm "$USER"
  sudo sed -i 's/^#unix_sock_group/unix_sock_group/' /etc/libvirt/libvirtd.conf
  sudo sed -i 's/^#unix_sock_ro_perms/unix_sock_ro_perms/' /etc/libvirt/libvirtd.conf
  sudo systemctl enable libvirtd.service
  sudo systemctl start libvirtd.service
}

installCups() {
  sudo systemctl enable --now cups.service
  sudo systemctl enable --now cups-browsed
}

installNextDNS() {
  sudo ln -sf /home/antrax/dotfiles/etc/systemd.resolved.conf /etc/systemd/resolved.conf
  sudo systemctl enable systemd-resolved.service
  sudo systemctl restart systemd-resolved.service
}

installMXMaster3S() {
  sudo ln -sf /home/antrax/dotfiles/etc/logid.cfg /etc/logid.cfg
  sudo systemctl enable --now logid
}

installOhMyPosh() {
  curl -s https://ohmyposh.dev/install.sh | bash -s
}

# Function to install paru
installYay() {
  sudo sed -i 's/^#Color/Color/' /etc/pacman.conf # Enable color in pacman
  sudo pacman -S --needed base-devel              # Install base-devel
  git clone https://aur.archlinux.org/yay.git
  cd yay || exit
  makepkg -si # Install paru
  cd ..
  rm -rf yay            # Remove paru folder
  yay --noconfirm -Syyu # Update system
}

# Function edit /etc/default/grub
editGrub() {
  sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3"/' /etc/default/grub
  sudo grub-mkconfig -o /boot/grub/grub.cfg
}

# Function to install bluetooth and start service
installBluetooth() {
  sudo pacman -S bluez bluez-utils
  ln -sf "$HOME/dotfiles/wireplumber" "$HOME/.config/wireplumber"
  sudo ln -sf "$HOME/dotfiles/etc/etc.systemd.system.bluetooth-disable-before-sleep.service" "/etc/systemd/system/bluetooth-disable-before-sleep.service"
  sudo ln -sf "$HOME/dotfiles/etc/etc.bluetooth.main.conf" "/etc/bluetooth/main.conf"
  # Enable all services
  sudo systemctl enable --now bluetooth.service
  sudo systemctl enable --now bluetooth-disable-before-sleep
}

# Function to install cronie and start service
installCronie() {
  sudo systemctl enable cronie.service
}

# Function to install reflector and start service
installReflector() {
  # /etc/xdg/reflector/reflector.conf
  sudo pacman -S reflector
  sudo sed -i 's/^# --country France,Germany/--country '\''United States,Spain,United Kingdom'\''/' /etc/xdg/reflector/reflector.conf
  sudo sed -i 's/^--sort age/--sort rate/' /etc/xdg/reflector/reflector.conf
  sudo reflector --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
  sudo systemctl enable reflector.service
  sudo systemctl start reflector.service
}

#enable chaotic aur
enableChaoticAur() {
  sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
  sudo pacman-key --lsign-key 3056513887B78AEB
  sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
  sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
  echo -e '\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist' | sudo tee -a /etc/pacman.conf
  sudo pacman -Syyu
}
