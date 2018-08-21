{ config, lib, pkgs, ... }:

{
  services.mysql.enable = true;
  services.mysql.package = pkgs.mysql;
  services.mysql.dataDir = "/var/db";
  services.mysql.bind = "127.0.0.1";
  services.mysql.initialDatabases = [{ name = "file_upload"; }];

  systemd.services.mysql.serviceConfig.Restart = "on-failure";
  systemd.services.mysql.serviceConfig.RestartSec = "10s";
  
}