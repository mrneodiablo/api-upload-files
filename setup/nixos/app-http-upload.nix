with import <nixpkgs> {};



let
  
  PORT = "8080";
  PROCESS = "4";
  PROJECT_DIR = "/project/http-api-upload";
  pythonapp = import ./python.nix ;
  THREADS = "2";

in {


  systemd.services.app-http-upload = {
    description = "File upload daemon";
    preStart = ''
      #wait for mysql start finish
      ${coreutils}/bin/sleep 10

      export APP_DATABASE_PASS=""
      # generate data base table
      ${pythonapp}/bin/python2.7 ${PROJECT_DIR}/manage.py makemigrations main
      ${pythonapp}/bin/python2.7 ${PROJECT_DIR}/manage.py migrate
    '';
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      WorkingDirectory = "${PROJECT_DIR}";
      ExecStart = "${pythonapp}/bin/uwsgi --http=0.0.0.0:${PORT} --module=main.wsgi:application --processes=${PROCESS}  --threads=${THREADS}  --master  --enable-threads  --logto=${PROJECT_DIR}/logs/uwsgi_deamon.log";
      KillSignal= "SIGINT";
      Type = "simple";
    };
  };

}