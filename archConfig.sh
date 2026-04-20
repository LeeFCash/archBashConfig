#!/usr/bin/env bash

# "&> /dev/null" redirects BOTH standard output (stdout) and error output (stderr)
# into /dev/null, which is a special file that discards everything (like a black hole).
# This makes the command run silently with no visible output.
# It is commonly used when we only care whether a command succeeds or fails
# (its exit status), not what it prints to the terminal.

set -e # stops the script when error

R=$((RANDOM % 101))
echo "${R}" > /tmp/random.txt
R=$(cat /tmp/random.txt)

update=true
installFirefox=true
installBrave=true
installBaseDevel=true
installGit=true
installYay=true
installSteam=true
installGameMode=true
installMangoHud=true
installVulkan=false
installXwaylandSatellite=true
installVulkanIcdLoader=true # some games need this to run
installLib32VulkanIcdLoader=true # some games need this to run
installOBSstudio=true
installTeamsForLinuxBin=true
installDiscordptb=true
installDolphin=true
installJava=true
installPython=true
installBlueman=true
installBlender=true
installTmux=true
installNeovim=true
installGamescope=true # you may need nvidia-utils(GPU stuff)
installFastfetch=true
installFlatpak=true
installMesa=true
installTtffontawesome=true
installProtonGeCustomBin=true
installNeovimJellybeans=true
installWaybar=true
installTtfJetbrainsMonoNerd=true
installPavucontrol=true
installPythonFlask=true
installGradle=true
installPyinstaller=true
installZip=true

groupInstallNetworkAndStart=true

if $groupInstallNetworkAndStart; then
	installNetworkManager=true
	installNetworkManagerApplet=true
else
	installNetworkManager=false
	installNetworkManagerApplet=false
fi

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

groupInstallvirtVM=true

if $groupInstallvirtVM; then
	installVirtManager=true
	installQemu=true
	installVde2=true
	installIptables=true
	installDnsmasq=true
	installIproute2=true
	installOpenbsdNetcat=true
	installPolkitGnome=false # don't always need it
	installSwtpm=true
#	virshStartDefaultAndAuto=true
else
	installVirtManager=false
	installQemu=false
	installVde2=false
	installIptables=false
	installDnsmasq=false
	installIproute2=false
	installOpenbsdNetcat=false
	installPolkitGnome=false
	installSwtpm=true
#	virshStartDefaultAndAuto=false
fi

# Function to check if a package is installed
is_installed() {
    pacman -Qi "$1" &> /dev/null 
#    pacman -Qi "$1"
}

manage_install_pkg() {
	local flag1="$1"
	local pkg="$2"
	local setUp="$3"

	if [[ "$flag1" == true ]] && ! is_installed "$pkg"; then
		echo "installing $pkg"
		sudo pacman -S "$pkg"
		if [[ "$pkg" == "git" ]] && [[ "$setUp" == true ]]; then
			echo "setting up git LeeFCash"
			git config --global user.email "leecash133@gmail.com"
			git config --global user.name "LeeFCash"
			echo "git is ready LeeFCash"
		fi
		if [[ "$pkg" == "virt-manager" ]] && [[ "$setUp" == true ]]; then
			echo " Add user to libvirt group "
			usermod -aG libvirt "$USER"
			echo "Setting up libvirt default network..."
			virsh net-start default
			virsh net-autostart default
		fi
	elif [[ "$flag1" == false ]] && is_installed "$pkg"; then
		echo "uninstalling $pkg"
		sudo pacman -Rns "$pkg"
	fi
}

manage_install_pkg_with_yay() {
	local flag1="$1"
	local pkg="$2"

	if $installYay && ! command -v yay &> /dev/null; then
		echo "installing yay the AUR helper"
		cd /tmp/
		git clone https://aur.archlinux.org/yay.git
		cd yay
		makepkg -si
		cd ..
		rm -rf yay
	fi

	if [[ "$flag1" == true ]] && [[ "$installYay" == true ]] && ! is_installed "$pkg"; then
		echo "installing $pkg"
		yay -S "$pkg"
	elif [[ "$flag1" == false ]] && is_installed "$pkg"; then
		echo "uninstalling $pkg"
		pacman -Rns "$pkg"
	fi
}


# without yay
manage_install_pkg $installOBSstudio obs-studio
manage_install_pkg $installDolphin dolphin
manage_install_pkg $installGameMode gamemode
manage_install_pkg $installJava jdk21-openjdk
manage_install_pkg $installPython python
manage_install_pkg $installMangoHud mangohud
manage_install_pkg $installBlueman blueman
manage_install_pkg $installNetworkManagerApplet network-manager-applet
manage_install_pkg $installNetworkManager networkmanager
manage_install_pkg $installBlender blender
manage_install_pkg $installTmux tmux
manage_install_pkg $installNeovim neovim
manage_install_pkg $installGamescope gamescope
manage_install_pkg $installFastfetch fastfetch
manage_install_pkg $installFlatpak flatpak
manage_install_pkg $installMesa mesa
manage_install_pkg $installTtffontawesome ttf-font-awesome
manage_install_pkg $installFirefox firefox
manage_install_pkg $installBadeDevel base-devel
manage_install_pkg $installGit git true
manage_install_pkg $installSteam steam
manage_install_pkg $installVulkanIcdLoader vulkan-icd-loader
manage_install_pkg $installLib32VulkanIcdLoader lib32-vulkan-icd-loader
manage_install_pkg $installQemu qemu
manage_install_pkg $installVde2 vde2
manage_install_pkg $installIptables iptables
manage_install_pkg $installDnsmasq dnsmasq
manage_install_pkg $installIproute2 iproute2
manage_install_pkg $installOpenbsdNetcat openbsd-netcat
manage_install_pkg $installSwtpm swtpm
manage_install_pkg $installVirtManager virt-manager true
manage_install_pkg $installWayland wayland
manage_install_pkg $installNiri niri
manage_install_pkg $installXorgXwayland xorg-xwayland
manage_install_pkg $installWlClipBoard wl-clipboard
manage_install_pkg $installFoot foot
manage_install_pkg $installFuzzel fuzzel
manage_install_pkg $installGrim grim
manage_install_pkg $installSlurp slurp
manage_install_pkg $installSwaybg swaybg
manage_install_pkg $installWaybar waybar
manage_install_pkg $installTtfJetbrainsMonoNerd ttf-jetbrains-mono-nerd
manage_install_pkg $installPavucontrol pavucontrol
manage_install_pkg $installPythonFlask python-flask
manage_install_pkg $installGradle gradle
manage_install_pkg $installZip zip
manage_install_pkg $installZip unzip
# with yay
manage_install_pkg_with_yay $installTeamsForLinuxBin teams-for-linux-bin
manage_install_pkg_with_yay $installDiscordptb discord-ptb
manage_install_pkg_with_yay $installXwaylandSatellite xwayland-satellite
manage_install_pkg_with_yay $installBrave brave-bin
manage_install_pkg_with_yay $installProtonGeCustomBin proton-ge-custom-bin
manage_install_pkg_with_yay $installNeovimJellybeans neovim-jellybeans
manage_install_pkg_with_yay $installPyinstaller pyinstaller
# -----
if [ ! -d "/home/leecash/AppImages" ]; then
	mkdir /home/leecash/AppImages
fi

if $groupInstallNetworkAndStart && is_installed networkmanager && ! systemctl is-active --quiet NetworkManager; then
	echo "Starting NetworkManager..."
	systemctl enable --now NetworkManager
fi

if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
	echo "WARNING: multilib repo may not be enabled!"
fi

if $installVirtManager && ! systemctl is-active --quiet libvirtd; then
	# Enable libvirt service
	systemctl enable --now libvirtd.socket
	systemctl enable --now libvirtd
	#sudo systemctl enable --now libvirtd.service virtlogd.service
fi

echo "Type number to random event to get it to happen or enter nothing to make it random.    also if you put letters that will stop the random events from happening."
read -r rA

if [[ -n "$rA" ]]; then
	R="$rA"
fi

if [[ "$R" == "1" ]]; then
	fastfetch
fi

if [[ "$R" == "2" ]] && [[ "$update" == true ]]; then
	echo "update the system."
	echo "pacman first"
	sudo pacman -Syu
	echo "yay after."
	yay -Syu
fi

if [[ "$R" == "3" ]] && [[ "$installNiri" == true ]]; then
	echo "about to setup niri config."
	sudo mkdir -p "$HOME/.config/niri"
	sudo cp -rf "$HOME/archBashConfig/niri/config.kdl" "$HOME/.config/niri/"
fi

if [[ "$R" == "4" ]] && [[ "$installMako" == true ]]; then
	echo "about to setup mako config."
	sudo mkdir -p "$HOME/.config/mako"
	sudo cp -rf "$HOME/archBashConfig/mako/config" "$HOME/.config/mako/"
fi

if [[ "$R" == "5" ]] && [[ "$installNeovim" == true ]]; then
	echo "about to setup neovim config."
	sudo mkdir -p "$HOME/.config/nvim"
	sudo cp -rf "$HOME/archBashConfig/nvim/init.vim" "$HOME/.config/nvim/"
fi

if [[ "$R" == "6" ]]; then
	echo "Sometimes the script will do something at this point but this time it's just letting you know."
fi

if [[ "$R" == "7" ]]; then
	echo "about to show mem/swap info."
	free -h
fi

if [[ "$R" == "8" ]]; then
	echo "about to show the uptime info."
	uptime
fi

if [[ "$R" == "9" ]] && [[ "$installWaybar" == true ]]; then
	echo "about to setup waybar config."
	sudo mkdir -p "$HOME/.config/waybar"
	sudo cp -rf "$HOME/archBashConfig/waybar/style.css" "$HOME/.config/waybar/"
fi

echo "$R"
echo "script is done"
