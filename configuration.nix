# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hosts/harry-tp/hardware-configuration.nix
      ./users/all.nix
      ./modules/virtualisation.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-tp"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  services.gnome.core-apps.enable = false;
  services.udev.packages = [ pkgs.gnome-settings-daemon ];


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "se";
    variant = "nodeadkeys";
  };

  # Configure console keymap
  console.keyMap = "sv-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  

  # Allow unfree packages
  nixpkgs.config = {
  	allowUnfree = true;
	nixpkgs.config.allowUnfreePredicate = _: true;
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Trust me BRO
  nix.extraOptions = ''
	trusted-users = root harry
  '';

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
  	#
  	# Terminal
  	#
    wget
    neovim
    neofetch
    ghostty
    curl
    zellij
    git
    lolcat
    unzip
    zip
    yq
    jq
    gnumake
    gcc
    ripgrep
    psmisc
    lsof
    eza
    yazi
    fzf
    bat
    dig
  ]) ++ ( with pkgs; [
  	# Development stuff
    devenv
  ]) ++ ( with pkgs; [
    #
    # Browsers
    #
    firefox
  ]) ++ ( with pkgs; [
    #
    # Virtualization
    #
    podman
    podman-tui
    podman-compose
    qemu
    qemu_kvm
    quickemu
    virt-manager
  ]) ++ ( with pkgs; [
    #
    # Misc
    #
    home-manager
  ]) ++ (with pkgs; [
    #
    # Python
    #
    micromamba
  ]) ++ (with pkgs; [
    # x11 stuff
    xwayland
    xorg.libX11
    xorg.libXrandr
    xorg.libXcursor
    xorg.xhost
  ]) ++ (with pkgs; [
    # Sound stuff
    portaudio
    pipewire
  ]);

  nix.settings.auto-optimise-store = true;

  nix.gc.automatic = true;

  nix.gc.dates = "daily";

  nix.gc.options = "--delete-older-than 7d"; 

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
