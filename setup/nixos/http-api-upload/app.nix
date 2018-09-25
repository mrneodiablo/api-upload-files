{ config, lib,  pkgs, ...  }:

with lib;

let
  cfg = config.services.http-api-upload;
in
{
  options = {
    services.http-api-upload = {
      enable = mkOption {
        default = false;
        description = "Whether to enable the http-api-upload server";
      };
      port = mkOption {
        default = "8080";
        description = "Port of http-api-upload";
      };
      process = mkOption {
        default = "4";
        description = "Process to handle http-api-upload";
      };
      threads = mkOption {
        default = "2";
        description = "Threads per process to handle http-api-upload";
      };
      project-dir = mkOption {
        type = types.path;
        default = "/project/http-api-upload";
        description = "Project directory of http-api-upload";
      };
      app-secret-key = mkOption {
        default = "sdfsfFKLJodsg082343223_";
        description = "Secret_key for application verify to client";
      };
      app-file-size-allow = mkOption {
        default = "1048576";
        description = "Maximun file size user can upload";
      };
      app-user = mkOption {
        default = "dongvt";
        description = "User name for app";
      };
      app-pass = mkOption {
        default = "dongvt";
        description = "Pass of user for app";
      };
      app-database-name = mkOption {
        default = "file_upload";
        description = "Database name for app connect";
      };
      app-database-user = mkOption {
        default = "root";
        description = "Database username for app connect";
      };
      app-database-pass = mkOption {
        default = "";
        description = "Database password for app connect";
      };
      app-database-host = mkOption {
        default = "127.0.0.1";
        description = "Database host for app connect";
      };
      app-database-port = mkOption {
        default = "3306";
        description = "Database port for app connect";
      };
      waiting-time = mkOption {
        default = "10";
        description = "Timing waits to mysql available";
      };
    };
  };
  config = mkIf cfg.enable {
    systemd.services.http-api-upload = {
      description = "http-api-upload Server, File upload daemon";
      environment = {
        APP_SECRET_KEY = "${cfg.app-secret-key}";
        APP_FILE_SIZE_ALLOW = "${cfg.app-file-size-allow}";
        APP_USER = "${cfg.app-user}";
        APP_PASS = "${cfg.app-pass}";
        APP_DATABASE_NAME = "${cfg.app-database-name}";
        APP_DATABASE_USER = "${cfg.app-database-user}";
        APP_DATABASE_PASS = "${cfg.app-database-pass}";
        APP_DATABASE_HOST = "${cfg.app-database-host}";
        APP_DATABASE_PORT = "${cfg.app-database-port}";
      };
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        while ${pkgs.coreutils}/bin/sleep ${cfg.waiting-time}; do
          ${pkgs.python4app}/bin/python2.7 ${cfg.project-dir}/manage.py test
          PROCESS_STATUS=$?
          if [ $PROCESS_STATUS -ne 0 ];then
            exit 1
          else
            # generate database tables
            ${pkgs.python4app}/bin/python2.7 ${cfg.project-dir}/manage.py makemigrations main
            ${pkgs.python4app}/bin/python2.7 ${cfg.project-dir}/manage.py migrate
            exit 0
          fi
        done
      '';
      serviceConfig = {
        WorkingDirectory = "${cfg.project-dir}";
        ExecStart = "${pkgs.python4app}/bin/uwsgi --http=0.0.0.0:${cfg.port} --module=main.wsgi:application --processes=${cfg.process}  --threads=${cfg.threads}  --master  --enable-threads  --logto=${cfg.project-dir}/logs/uwsgi_deamon.log --daemonize=${cfg.project-dir}/logs/uwsgi_deamon.log --pidfile=${cfg.project-dir}/run/uwsgi_web.pid";
        KillSignal = "SIGINT";
        PIDFile = "${cfg.project-dir}/run/uwsgi_web.pid";
        Type = "forking";
      };
    };
  };
}






