with import <nixpkgs> {};

let

     	pythonapp = import ./pythonenv.nix ;
      PROJECT_DIR = "/http_api_upload-master";
      PORT = "8080";
      PROCESS = "4";
      THREADS = "2";

in
{
    systemd.services.app = {
      description = "File uploadd daemon";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        export APP_DATABASE_PASS=""
        # generate data base table
        ${pythonapp}/bin/python2.7 ${PROJECT_DIR}/manage.py makemigrations main
        ${pythonapp}/bin/python2.7 ${PROJECT_DIR}/manage.py migrate

      '';
   

      serviceConfig = {
        WorkingDirectory = "${PROJECT_DIR}";
        ExecStart = "${pythonapp}/bin/uwsgi --http=0.0.0.0:${PORT} --module=main.wsgi:application --processes=${PROCESS}  --threads=${THREADS}  --master  --enable-threads --pidfile=${PROJECT_DIR}/run/uwsgi_web.pid --logto=${PROJECT_DIR}/logs/uwsgi_deamon.log --daemonize=${PROJECT_DIR}/logs/uwsgi_web.log";
        ExecStartPost = "${pythonapp}/bin/python2.7 ${PROJECT_DIR}/script_test/test_api.py";
        KillSignal= SIGQUIT;
        Type = "simple";
      };
    };

}