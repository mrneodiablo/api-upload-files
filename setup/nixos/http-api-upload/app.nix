{ config, lib,  pkgs, ...  }:


with lib;

let

  cfg = config.services.http-api-upload;

  python4app = import ../python {};


in
{

  options.services.http-api-upload = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable the http-api-upload server.
        ";
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

      project_dir = mkOption {
        default = project + "/uploadfile";
        description = "project directory of http-api-upload";
      };

    };

  ###### implementation

  config = mkIf (cfg.enable) {

    systemd.services.http-api-upload = { 

        description = "http-api-upload Server, File upload daemon";

        wantedBy = [ "multi-user.target" ];  

        preStart =
          ''
            #wait for mysql start finish
            ${pkgs.coreutils}/bin/sleep 10

            export APP_DATABASE_PASS=""
            # generate data base table
            ${python4app}/bin/python2.7 ${cfg.project_dir}/manage.py makemigrations main
            ${python4app}/bin/python2.7 ${cfg.project_dir}/manage.py migrate
          '';


        serviceConfig = {
          WorkingDirectory = "${cfg.project_dir}";
          ExecStart = "${python4app}/bin/uwsgi --http=0.0.0.0:${cfg.port} --module=main.wsgi:application --processes=${cfg.process}  --threads=${cfg.threads}  --master  --enable-threads  --logto=${cfg.project_dir}/logs/uwsgi_deamon.log";
          KillSignal= "SIGINT";
          Type = "simple";
        };
      };

  };

}

 


  
