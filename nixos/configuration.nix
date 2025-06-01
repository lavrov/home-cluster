# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./services.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Support NFS filesystems.
  boot.supportedFilesystems = [ "nfs" ];

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = "mf";

  users.users.vitaly = {
    isNormalUser = true;
    description = "Vitaly";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEA/WwH8LQYvNhN1jQ5wQmQ+cXZ1jTvyPPFeZCChd0+l5PB6HIk5N8aVtYatIL1heVde/96b+Kq571EAp0jPhfqlautM1+GxMsLsEa1nhRhYBNWuyEccQFv25NGhiEEWZJMQwIOg1LXyVOZ70FkAc96ftJuWV2L/TWsQhxHofAQGNtEGGn00z6RjGny4CblWReNmsEiPHHFsleCOGKu7palX8JNNdB3QKWrR+YY/Pon84469JQ/bqfCYNNzJL8wjkCGOqh+Fy9+iLe4wifjtjmiBfpZbOUUcWBHoeMMUrPD4jdD/x7TJdz1GHlWyGB2nFF103DkBHqUIxD0ZlTqYDh cardno:000615499727"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDMHdIEI2GFee6/ZY2Df+3KPpQYVdqY3VUT/WSsfGKp/LxlpbGZVeNRhPcy+f65LMimNIuu5zqPgaCr/iifJbvYw2N6uO261461R6S4J3UGu+ijFAonDG3fy0QcIaeMXuA004ixadfhOPgM1tAKAA7e0QVlT2LWwODN8GhAaFIBkMYiVhf4t7R0Kt5G08oWtDyXM8x02+aQZXc3S1mVRiSxk9Q+x1bPt83nS1cLx7dwq/Af2ShVMG26T49YH5L23szR7F65ukdr6Qj89EF0QfTF7sfjSQ3EeZRyWvgSe5xduyTSd8M9Uqu0DqctKHwtLzqMbXMvJnTDKMX0ttBCVHX cardno:000615499738"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    htop-vim
  ];

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

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
  system.stateVersion = "24.11"; # Did you read the comment?
}
