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
installSteam=true
installGameMode=false
installMangoHud=false
installVulkan=false
installXwaylandSatellite=true
installVulkanIcdLoader=true # some games need this to run
installLib32VulkanIcdLoader=true # some games need this to run

groupInstallNiriAndStuff=true

if $groupInstallNiriAndStuff; then
	installNiri=true
	installWayland=true
	installXorgXwayland=true
	installWlClipBoard=true
	installFoot=true
	installFuzzel=true
	installGrim=true
	installSlurp=true
	installSwaybg=true
	installMako=true
else
	installNiri=false
	installWayland=false
	installXorgXwayland=false
	installWlClipBoard=false
	installFoot=false
	installFuzzel=false
	installGrim=false
	installSlurp=false
	installSwaybg=false
	installMako=false
fi

groupInstallvirtVM=false

if $groupInstallvirtVM; then
	installVirtManager=true
	installQemu=true
	installVde2=true
	installIptables=true
	installDnsmasq=true
	installBridgeUtils=true
	installOpenbsdNetcat=true
	installPolkitGnome=true
else
	installVirtManager=false
	installQemu=false
	installVde2=false
	installEbtables=false
	installDnsmasq=false
	installBridgeUtils=false
	installOpenbsdNetcat=false
	installPolkitGnome=false
fi

# Function to check if a package is installed
is_installed() {
    pacman -Qi "$1" &> /dev/null 
#    pacman -Qi "$1"
}

if [ ! -d "/home/leecash/AppImages" ]; then
	mkdir /home/leecash/AppImages
fi

if $update; then
	echo "update the system..."
	sudo pacman -Syu
fi

if $installFirefox && ! is_installed firefox; then
	echo "installing firefox"
	sudo pacman -S firefox
elif ! $installFirefox && is_installed firefox; then
	echo "uninstalling firefox"
	sudo pacman -Rns firefox
fi

if $installBaseDevel && ! is_installed base-devel; then
	echo "installing base-devel..."
	sudo pacman -S base-devel # dependencies for brave
elif ! $installBaseDevel && is_installed base-devel; then
	echo "uninstalling base-devel..."
	sudo pacman -Rns base-devel
fi

if $installGit && ! is_installed git; then
	echo "installing and seting up git..."
	sudo pacman -S git
	git config --global user.email "leecash133@gmail.com"
	git config --global user.name "LeeFCash"
	echo "git is ready LeeFCash"
elif ! $installGit && is_installed git; then
	echo "uninstalling git"
	sudo pacman -Rns git
fi

if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
	echo "WARNING: multilib repo may not be enabled!"
fi

if $installSteam && ! is_installed steam; then
	echo "installing steam..."
	sudo pacman -S steam
elif ! $installSteam && is_installed steam; then
	echo "uninstalling steam..."
	sudo pacman -Rns steam
fi

if $installGameMode && ! is_installed gamemode; then
	echo "installing gamemode"
	sudo pacman -S gamemode
elif ! $installGameMode && is_installed gamemode; then
	echo "uninstalling gamemode"
	sudo pacman -Rns gamemode
fi

if $installMangoHud && ! is_installed mangohud; then
	echo "installing mangohud..."
	sudo pacman -S mangohud
elif ! $installMangoHud && is_installed mangohud; then
	echo "uninstalling mangohud..."
	sudo pacman -Rns mangohud
fi

if $installVulkanIcdLoader && ! is_installed vulkan-icd-loader; then
		sudo pacman -S vulkan-icd-loader
elif ! $installVulkanIcdLoader && is_installed vulkan-icd-loader; then
		sudo pacman -Rns vulkan-icd-loader
fi

if $installLib32VulkanIcdLoader && ! is_installed lib32-vulkan-icd-loader; then
		sudo pacman -S lib32-vulkan-icd-loader
elif ! $installLib32VulkanIcdLoader && is_installed lib32-vulkan-icd-loader; then
		sudo pacman -Rns lib32-vulkan-icd-loader
fi

if $installVirtManager && ! is_installed virt-manager; then
	echo "Installing Virt-Manager and virtualization stack..."
	# Core virtualization packages
	sudo pacman -S virt-manager

	# Add user to libvirt group
	sudo usermod -aG libvirt "$USER"
elif ! $installVirtManager && is_installed virt-manager; then
	sudo pacman -Rns virt-manager
fi

if $installVirtManager && ! systemctl is-active --quiet libvirtd; then
	# Enable libvirt service
	sudo systemctl enable --now libvirtd.socket
	sudo systemctl enable --now libvirtd
	#sudo systemctl enable --now libvirtd.service virtlogd.service
fi

if $installQemu && ! is_installed qemu; then
	sudo pacman -S qemu
elif ! $installQemu && is_installed qemu; then
	sudo pacman -Rns qemu
fi

if $installVde2 && ! is_installed vde2; then
	sudo pacman -S vde2
elif ! $installVde2 && is_installed vde2; then
	sudo pacman -Rns vde2
fi

if $installIptables && ! is_installed iptables; then
	sudo pacman -S iptables
elif ! $installIptables && is_installed iptables; then
	sudo pacman -Rns iptables
fi

if $installDnsmasq && ! is_installed dnsmasq; then
	sudo pacman -S dnsmasq
elif ! $installDnsmasq && is_installed dnsmasq; then
	sudo pacman -Rns dnsmasq
fi

if $installBridgeUtils && ! is_installed bridge-utils; then
	sudo pacman -S bridge-utils
elif ! $installBridgeUtils &&  is_installed bridge-utils; then
	sudo pacman -Rns bridge-utils
fi

if $installOpenbsdNetcat && ! is_installed openbsd-netcat; then
	sudo pacman -S openbsd-netcat
elif ! $installOpenbsdNetcat && is_installed openbsd-netcat; then
	sudo pacman -Rns openbsd-netcat
fi

if $installPolkitGnome && ! is_installed polkit-gnome; then
	echo "just here for later"
	#sudo pacman -S polkit-gnome # I think I should have 
elif ! $installPolkitGnome && is_installed polkit-gnome; then
	echo "just here for later2"
	#sudo pacman -S polkit-gnome # I think I should have 
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
elif ! $installXwaylandSatellite &&  is_installed xwayland-satellite; then
	sudo pacman -Rns xwayland-satellite
fi

if $installBrave && $installYay && ! is_installed brave-bin; then
	echo "installing brave browser..."
	yay -S brave-bin
elif ! $installBrave && is_installed brave-bin; then
	echo "uninstalling brave browser..."
	sudo pacman -Rns brave-bin
fi

if $installNiri && $installYay && ! is_installed niri; then
	yay -S niri
elif ! $installNiri && is_installed niri; then
	sudo pacman -Rns niri
fi

if $installWayland && ! is_installed wayland; then
	sudo pacman -S wayland
elif ! $installWayland && is_installed wayland; then
	sudo pacman -Rns wayland
fi

if $installXorgXwayland && ! is_installed xorg-xwayland; then
	sudo pacman -S xorg-xwayland
elif ! $installXorgXwayland && is_installed xorg-xwayland; then
	sudo pacman -Rns xorg-xwayland
fi

if $installWlClipBoard && ! is_installed wl-clipboard; then
	sudo pacman -S wl-clipboard
elif ! $installWlClipBoard && is_installed wl-clipboard; then
	sudo pacman -Rns wl-clipboard
fi

if $installFoot && ! is_installed foot; then
	sudo pacman -S foot
elif ! $installFoot && is_installed foot; then
	sudo pacman -Rns foot
fi

if $installFuzzel && ! is_installed fuzzel; then
	sudo pacman -S fuzzel
elif ! $installFuzzel && is_installed fuzzel; then
	sudo pacman -Rns fuzzel
fi

if $installGrim && ! is_installed grim; then
	sudo pacman -S grim
elif ! $installGrim && is_installed grim; then
	sudo pacman -Rns grim
fi

if $installSlurp && ! is_installed slurp; then
	sudo pacman -S slurp
elif ! $installSlurp && is_installed slurp; then
	sudo pacman -Rns slurp
fi

if $installSwaybg && ! is_installed swaybg; then
	sudo pacman -S swaybg
elif ! $installSwaybg && is_installed swaybg; then
	sudo pacman -Rns swaybg
fi

if $installMako && ! is_installed mako; then
	sudo pacman -S mako
elif ! $installMako && is_installed mako; then
	sudo pacman -Rns mako
fi

echo "script is done"
