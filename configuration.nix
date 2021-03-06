{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware.nix
      ./users.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  # for detecting dual boot windows
  boot.loader.grub.useOSProber = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.cleanTmpDir = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/539800f0-426f-435b-9382-76ee7df92efd";
      preLVM = true;
      allowDiscards = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  nix.allowedUsers = [ "root" "felix" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  networking.hostName = "rocky"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  networking.useDHCP = false;
  networking.interfaces.wlp7s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  
  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;


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
  system.stateVersion = "20.09"; # Did you read the comment?

  # user stuff
  sound.enable = true;
  #hardware.pulseaudio = {
    #enable = true;
    #package = pkgs.pulseaudioFull;
    #extraModules = [ pkgs.pulseaudio-modules-bt ];
  #};
  #hardware.bluetooth = {
  #enable = true;
  #};
  #services.blueman.enable = true;
  
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    layout = "eu";

    # used to let home-manager handle xsession
    desktopManager = {
      xterm.enable = false;
      session = [{
        name = "home-manager";
	start = ''
	  ${pkgs.runtimeShell} $HOME/.hm-xsession &
	  waitPID=$!
	'';
      }];
    };

    # automatically logs in my user
    # enables logging out manually
    displayManager = {
      autoLogin = {
        enable = true;
	user = "felix";
      };

      lightdm.enable = true;
    };
  };
}
