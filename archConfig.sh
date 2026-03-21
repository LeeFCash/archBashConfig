#!/usr/bin/env bash

# "&> /dev/null" redirects BOTH standard output (stdout) and error output (stderr)
# into /dev/null, which is a special file that discards everything (like a black hole).
# This makes the command run silently with no visible output.
# It is commonly used when we only care whether a command succeeds or fails
# (its exit status), not what it prints to the terminal.

set -e # stops the script when error

update=false
installFirefox=true
installBrave=true
installBaseDevel=true
installGit=true
installYay=true
installNiri=true
installSteam=true
installGameMode=true
installMangoHud=true
installVulkan=true
installXwaylandSatellite=true
installVirtManager=true

# Function to check if a package is installed
is_installed() {
    pacman -Qi "$1" &> /dev/null 
#    pacman -Qi "$1"
}

if [ ! -d "/home/leecash/AppImages" ]; then
	mkdir /home/leecash/AppImages
fi

if $update; then
	sudo pacman -Syu
fi

if $installFirefox && ! is_installed firefox; then
	sudo pacman -S firefox
fi

if $installBaseDevel && ! is_installed base-devel; then
	sudo pacman -S base-devel # dependencies for brave
fi

if $installGit && ! is_installed git; then
	sudo pacman -S git
fi

if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
	echo "WARNING: multilib repo may not be enabled!"
fi

if $installSteam && ! is_installed steam; then
	sudo pacman -S steam
	if $installGameMode && ! is_installed gamemode; then
		sudo pacman -S gamemode
	fi
	if $installMangoHud && ! is_installed mangohud; then
		sudo pacman -S mangohud
	fi
	if $installVulkan && ! is_installed vulkan-icd-loader; then
		sudo pacman -S vulkan-icd-loader
	fi
	if $installVulkan && ! is_installed lib32-vulkan-icd-loader; then
		sudo pacman -S lib32-vulkan-icd-loader
	fi
fi

if $installVirtManager && ! is_installed virt-manager; then
	echo "Installing Virt-Manager and virtualization stack..."
	# Core virtualization packages
	sudo pacman -S virt-manager
	sudo pacman -S qemu
	sudo pacman -S vde2
	sudo pacman -S ebtables
	sudo pacman -S dnsmasq
	sudo pacman -S bridge-utils
	sudo pacman -S openbsd-netcat
	sudo pacman -S polkit-gnome # I think I should have 

	if ! systemctl is-active --quiet libvirtd; then
		# Enable libvirt service
		sudo systemctl enable --now libvirtd.socket
		sudo systemctl enable --now libvirtd
		#sudo systemctl enable --now libvirtd.service virtlogd.service
	fi

	# Add user to libvirt group
	sudo usermod -aG libvirt "$USER"

	echo "Virt-Manager installed!"
	echo "You may need to log out and back in for group changes to apply."
fi

if $installYay && ! command -v yay &> /dev/null; then
	echo "installing yay the AUR helper"
	cd /tmp/
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si
	cd ..
	rm -rf yay
fi

if $installXwaylandSatellite && $installYay && ! is_installed xwayland-satellite; then
	yay -S xwayland-satellite
fi

if $installBrave && $installYay && ! is_installed brave-bin; then
	echo "installing brave browser..."
	yay -S brave-bin
fi

if $installNiri && $installYay && ! is_installed niri; then
	sudo pacman -S wayland
	sudo pacman -S xorg-xwayland
	sudo pacman -S wl-clipboard
	sudo pacman -S foot
	sudo pacman -S fuzzel
	sudo pacman -S grim
	sudo pacman -S slurp
	sudo pacman -S swaybg
	sudo pacman -S mako
	yay -S niri
fi

echo "script is done"
