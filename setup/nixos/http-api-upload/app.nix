{ config, lib,  pkgs, ...  }:

let
  cfg = config.services.http-api-upload;
  python4app = pkgs.callPackage ./python {};
in

with lib;

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
        description = "process to handle http-api-upload";
      };
      threads = mkOption {
        default = "2";
        description = "threads per process to handle http-api-upload";
      };
      project-dir = mkOption {
        type = types.path;
        default = "/project/http-api-upload";
        description = "project directory of http-api-upload";
      };
      app-secret-key = mkOption {
        type = types.str;
        default = "sdfsfFKLJodsg082343223_";
        description = "secret key for application verify to client";
      };
      app-file-size-allow = mkOption {
        type = types.str;
        default = "1048576";
        description = "maximun file size user can upload";
      };
      app-user = mkOption {
        type = types.str;
        default = "dongvt";
        description = "user name for app";
      };
      app-pass = mkOption {
        type = types.str;
        default = "dongvt";
        description = "pass of user for app";
      };
      app-database-name = mkOption {
        type = types.str;
        default = "file_upload";
        description = "database name for app connect";
      };
      app-database-user = mkOption {
        type = types.str;
        default = "root";
        description = "database username for app connect";
      };
      app-database-pass = mkOption {
        type = types.str;
        default = "";
        description = "database password for app connect";
      };
      app-database-host = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "database host for app connect";
      };
      app-database-port = mkOption {
        type = types.str;
        default = "3306";
        description = "database port for app connect";
      };
      waiting-time = mkOption {
        type = types.str;
        default = "10";
        description = "timing waits to mysql available";
      }; 
    };
  };  
  config = mkIf cfg.enable {
    systemd.services.http-api-upload = { 
        description = "http-api-upload Server, File upload daemon";
        environment = {
            APP_SECRET_KEY="${cfg.app-secret-key}";
            APP_FILE_SIZE_ALLOW="${cfg.app-file-size-allow}";
            APP_USER="${cfg.app-user}";
            APP_PASS="${cfg.app-pass}";
            APP_DATABASE_NAME="${cfg.app-database-name}";
            APP_DATABASE_USER="${cfg.app-database-user}";
            APP_DATABASE_PASS="${cfg.app-database-pass}";
            APP_DATABASE_HOST="${cfg.app-database-host}";
            APP_DATABASE_PORT="${cfg.app-database-port}";
        };
        wantedBy = [ "multi-user.target" ];
        preStart =
          ''
            while ${pkgs.coreutils}/bin/sleep ${cfg.waiting-time}; do
              ${python4app}/bin/python2.7 ${cfg.project-dir}/manage.py test
              PROCESS_STATUS=$?
              if [ $PROCESS_STATUS -ne 0 ];then
                exit 1
              else
                # generate database tables
                ${python4app}/bin/python2.7 ${cfg.project-dir}/manage.py makemigrations main
                ${python4app}/bin/python2.7 ${cfg.project-dir}/manage.py migrate
                exit 0
              fi
            done
          '';
        serviceConfig = {
          WorkingDirectory = "${cfg.project-dir}";
          ExecStart = "${python4app}/bin/uwsgi --http=0.0.0.0:${cfg.port} --module=main.wsgi:application --processes=${cfg.process}  --threads=${cfg.threads}  --master  --enable-threads  --logto=${cfg.project-dir}/logs/uwsgi_deamon.log --daemonize=${cfg.project-dir}/logs/uwsgi_deamon.log --pidfile=${cfg.project-dir}/run/uwsgi_web.pid";
          KillSignal= "SIGINT";
          PIDFile = "${cfg.project-dir}/run/uwsgi_web.pid";
          Type = "forking";
        };
      };
  };
}


 


  
