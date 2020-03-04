{ config, pkgs, ... }:

{
  services.openssh = {
    enable = true;
    forwardX11 = true;
    permitRootLogin = "no";
    passwordAuthentication = false;

    # Allow local LAN to connect with passwords
    extraConfig = ''
      Match address 192.168.86.0/24
      PasswordAuthentication yes
    '';
  };

  users.users.jboyens.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDECXnI34NJU+L32GB7vwdTv4R9Uv53DElOZ5T/1or7X1VJxEb2+vNjxFQm1WNru1p23Wq8vGKasjIJt20L3B2E+9A2JHuL8MDpXU5Ednk3TgR1ghSdXzqmUTWmEMuqeU7nzYtnFeEyMSpW/FLy8YxO69C3QKsJGlk6+zEMYy17EhcT87K37/Odw326yXqEG2PAyQFQuSUSUIKixjLqYdRyVUTS43PY9kFwny4XqBof+vprkSfpQJi9qbSYPTOlfdadVE4wtb0TBdHRPS9owBk09ouj3okbT4TyEgedG6QrZn5j06nAYZqI4ggAI3sKgvLaec5jwqF+mX0Jo8naV4in jr@irongiant.local"
  ];
}
