{ config, pkgs, ... }:

{
  services.ollama = {
    enable = true;
    loadModels = [
      "qwen2.5-coder:1.5b"
      "qwen2.5-coder:7b"
      "qwen2.5-coder:14b"
      "gemma3:12b"
      "deepseek-r1:14b"
      "qwq"
      "llama3.3"
    ];
    acceleration = "rocm";
    rocmOverrideGfx = "10.3.0";
    host = "0.0.0.0";
    openFirewall = true;
  };

  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    #port = 8080;
    openFirewall = true;
  };
  networking.firewall.allowedTCPPorts = [
    6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
  ];
  services.k3s = {
    enable = true;
    role = "server";
  };
}
