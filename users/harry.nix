{ config, pkgs, ... }:
{
	
	programs.zsh.enable = true;
	# Prevent the new user dialog in zsh

	services.xserver.excludePackages = [ pkgs.xterm ];
	services.xserver.desktopManager.xterm.enable = false;
	
	environment.gnome.excludePackages = [ pkgs.gnome-tour ];

	users.users.harry = {
		isNormalUser = true;
		description = "harry";
		extraGroups = [ "networkmanager" "wheel" ];
		shell = pkgs.zsh;
	};
}