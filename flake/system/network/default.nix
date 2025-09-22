{pkgs, ...}: {
  # Enable networking
  networking.networkmanager.enable = true;

  # Enables wireless support via wpa_supplicant
  # Second line is necessary to use wpa_supplicant and networkmanager at the same time
  # networking.wireless.enable = true;
  # networking.networkmanager.unmanaged = [ "*" "except:type:wwan" "except:type:gsm" ];

  # Networkmanager applet for desktop enviroments
  programs.nm-applet.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # From https://wiki.archlinux.org/title/Dhcpcd#dhcpcd@.service_causes_slow_startup
  networking.dhcpcd.wait = "background";
  systemd.services.NetworkManager-wait-online.enable = false;
}
