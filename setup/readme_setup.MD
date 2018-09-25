## INSTALL
There are  3 options to install app
  - manual with Centos 6/7
  - manual with NixOS
  - Dockerfile
  - docker-compose

### Install with Centos 6/7
=======

requitment:
   - OS          Centos 6.8/7
   - Environment Python2.7
   - Database    MySQL

   
   
1. Install MySQL on this server
    
install mysql

`yum install mysql mysql-devel mysql-server`
   
   
start mysql

`/etc/init.d/mysqld start`

create new password

`/usr/bin/mysqladmin -u root password '123456'`


create database for app

`mysql -u root -p123456 -e 'create database file_upload;'`

2. copy source on server

Your can copy source to server example. will put it in `/data/uploadfile/`


3. Install python2.7

for install python 2.7 on centos6 for fast plz use my source `Python-2.7.11-1.x86_64.rpm` in `container` dir.

`rpm -ivh Python-2.7.11-1.x86_64.rpm`

it will be extra in folder `/build/data/`


after that install all lib dependence

```
yum install gcc -y
```

it will be auto install all lib  for project runtime
```
cd /data/uploadfile/setup/
python2.7 setup.py install
```

4. config app and start


```
cd /data/uploadfile/
```

check config file in `main/settings.py` notice DATABASE SERVER info.

if okie start app


generate table in database
```
cd /data/uploadfile/tool/
bash generate_database_table.sh
```
output will be show
```
[root@localhost tool]# ./generate_database_table.sh 
Migrations for 'main':
  main/migrations/0001_initial.py
    - Create model Files
System check identified some issues:

WARNINGS:
?: (mysql.W002) MySQL Strict Mode is not set for database connection 'default'
	HINT: MySQL's Strict Mode fixes many data integrity problems in MySQL, such as data truncation upon insertion, by escalating warnings into errors. It is strongly recommended you activate it. See: https://docs.djangoproject.com/en/1.11/ref/databases/#mysql-sql-mode
Operations to perform:
  Apply all migrations: contenttypes, main
Running migrations:
  Applying contenttypes.0001_initial... OK
  Applying contenttypes.0002_remove_content_type_name... OK
  Applying main.0001_initial... OK
```

start app
```
./init_web_app.sh start
```
```
[root@localhost tool]# ./init_web_app.sh 
Usage: /data/uploadfile/tool/../tool/start_web_app.sh {start|stop|restart|reload|force-reload|status}
[root@localhost tool]# ./init_web_app.sh start
Starting start_web_app: 
uwsgi_web.
[root@localhost tool]#
```


5. Test server

for test server with basic
```
cd /data/uploadfile/script_test/
python2.7 test_api.py
```

show
```
[root@localhost script_test]# python2.7 test_api.py 
==== upload file sdasdas.csv
=========== header ============
{'sign-client': '598fa467040bd8a80902f638a19a2920', 'authenticate': 'Basic ZG9uZ3Z0OmRvbmd2dA=='}
=========== respone ===========
{
    "response_message": "create success", 
    "respone_code": 0, 
    "response_data": {
        "time_modify": "2018-06-27T14:03:22.953950", 
        "hash": "48291312c2d8cd1ad8bed0dfd3706f21", 
        "id": 1, 
        "time_upload": "2018-06-27T14:03:22.953919", 
        "name": "case7.pdf"
    }
}



==== upload file case1.txt
=========== header ============
{'sign-client': '2ffa7ad4fa14370e2a3fc814dd096415', 'authenticate': 'Basic ZG9uZ3Z0OmRvbmd2dA=='}
=========== respone ===========
{
    "response_message": "create success", 
    "respone_code": 0, 
    "response_data": {
        "time_modify": "2018-06-27T14:03:22.967497", 
        "hash": "e442926f0e6c255e3dd1bcb8c1dc1d26", 
        "id": 2, 
        "time_upload": "2018-06-27T14:03:22.967471", 
        "name": "case9.csv"
    }
}



==== delete file sdasdas.csv
=========== header ============
{'authenticate': 'Basic ZG9uZ3Z0OmRvbmd2dA=='}
=========== respone ===========
{
    "response_message": "file not found ", 
    "respone_code": -404, 
    "response_data": "sdasdas.csv"
}



==== get file case1.txt
=========== header ============
{'authenticate': 'Basic ZG9uZ3Z0OmRvbmd2dA=='}
=========== respone ===========
{"response_message":"file not found ","respone_code":-404,"response_data":"case1.txt"}
```


### Install will NixOS
=====

requitments:
   - OS: NixOS

To install `http-api-upload` in NixOS very easy:

1. Install git command on NixOS
```
[root@nixos:~]nix-env -i git
warning: there are multiple derivations named 'git-2.16.4'; using the first one
replacing old 'git-2.16.4'
installing 'git-2.16.4'
```


2. clone code from repository:
`[root@nixos:~]mkdir /project/`

```
[root@nixos:~]cd /project
[root@nixos:/project]# git clone https://github.com/dongvothanh/http-api-upload.git
Cloning into 'http-api-upload'...
remote: Counting objects: 114, done.
remote: Compressing objects: 100% (26/26), done.
remote: Total 114 (delta 5), reused 25 (delta 4), pack-reused 81
Receiving objects: 100% (114/114), 56.26 MiB | 3.20 MiB/s, done.
Resolving deltas: 100% (9/9), done.
```

3. Configuration file nixos config to build and start application

```
[root@nixos:/project]# vim /etc/nixos/configuration.nix
```

```
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      /project/http-api-upload/setup/nixos/http-api-upload/app.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda";

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configuration http-api-upload======

  ## Config mysql
  services.mysql.enable = true;
  services.mysql.package = pkgs.mysql;
  services.mysql.dataDir = "/var/db";
  services.mysql.bind = "127.0.0.1";
  services.mysql.initialDatabases = [{ name = "file_upload"; }];
  systemd.services.mysql.serviceConfig.Restart = "on-failure";
  systemd.services.mysql.serviceConfig.RestartSec = "10s";

  ## Config app
  services.http-api-upload.enable = true;
  services.http-api-upload.port = "8080";
  services.http-api-upload.process = "4";
  services.http-api-upload.threads = "2";
  services.http-api-upload.project-dir = "/project/http-api-upload";
  # End configuration app =============


  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     wget vim telnet git
  ];
```

notice:
```
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      /project/http-api-upload/setup/nixos/http-api-upload/app.nix
    ];
```

and
```
nixpkgs.overlays = [ (import /project/http-api-upload/setup/nixos/http-api-upload/python/) ];

 ## Config mysql
services.mysql.enable = true;
services.mysql.package = pkgs.mysql;
services.mysql.dataDir = "/var/db";
services.mysql.bind = "127.0.0.1";
services.mysql.initialDatabases = [{ name = "file_upload"; }];
systemd.services.mysql.serviceConfig.Restart = "on-failure";
systemd.services.mysql.serviceConfig.RestartSec = "10s";

## Config app
services.http-api-upload.enable = true;
services.http-api-upload.port = "8080";
services.http-api-upload.process = "4";
services.http-api-upload.threads = "2";
services.http-api-upload.project_dir = "/project/http-api-upload";
# End configuration app =============
```


These are 2 scripts in project we will put its into `/etc/nixos/configuration.nix` to install and start automatic

4. Build and start app

```
[root@nixos:/project/http-api-upload/setup/nixos]# nixos-rebuild switch
building Nix...
building the system configuration...
updating GRUB 2 menu...
activating the configuration...
setting up /etc...
setting up tmpfile
....
..
```

this command will be build python  and libs with many dependences. start `mysql service` and
`http-api-upload service` with systemd. after that it will update to GRUB many to store snapshot config

5. check again:
```
[root@nixos:/project/http-api-upload/setup/nixos]# netstat -ntpl
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 127.0.0.1:3306          0.0.0.0:*               LISTEN      3210/mysqld
tcp        0      0 0.0.0.0:8080            0.0.0.0:*               LISTEN      3584/uwsgi
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      498/sshd
tcp        0      0 127.0.0.1:33087         0.0.0.0:*               LISTEN      3584/uwsgi
tcp6       0      0 :::22                   :::*                    LISTEN      498/sshd
```

you can see service uwsgi has started with port 8080 and mysql port 3306

==> DONE. install application with NixOS very easy right ?



### Install with Docker File
======

requitment:
   - Docker deamon

1. get code from github

`[root@localhost:~]mkdir /project/`

```
[root@localhost ~]# cd /project/
[root@localhost project]# git clone https://github.com/dongvothanh/http-api-upload.git
Cloning into 'http-api-upload'...
remote: Counting objects: 114, done.
remote: Compressing objects: 100% (26/26), done.
remote: Total 114 (delta 5), reused 25 (delta 4), pack-reused 81
Receiving objects: 100% (114/114), 56.26 MiB | 5.22 MiB/s, done.
Resolving deltas: 100% (9/9), done.
```

2. build docker images from Dockerfile


`cd /project/http-api-upload/setup/`

`docker build container/ -t http_api_upload:v0.1`

```
[root@localhost project]# cd /project/http-api-upload/setup/
[root@localhost setup]# docker build container/ -t http_api_upload:v0.1
Sending build context to Docker daemon 118.5 MB
Step 1/16 : FROM centos:6.8
 ---> 6704d778b3ba
Step 2/16 : MAINTAINER DongVo<vothanhdong18@gmail.com>
 ---> Using cache
 ---> 6dc993df415a
Step 3/16 : RUN yum install mysql mysql-devel gcc gcc-devel unzip openssl-devel iputils -y
 ---> Running in 2df7404dbde6

Loaded plugins: fastestmirror, ovl
Setting up Install Process
No package gcc-devel available.
Resolving Dependencies
--> Running transaction check
....
....
 ---> 03d10f2659c4
Removing intermediate container 3ff72625bbe5
Step 16/16 : ENTRYPOINT ./upstart.sh
 ---> Running in 509e05dcf0ce
 ---> 37154887a9e6
Removing intermediate container 509e05dcf0ce
Successfully built 37154887a9e6
```


==> Build docker images DONE

check again:

```
[root@localhost setup]# docker images
REPOSITORY                                TAG                 IMAGE ID            CREATED             SIZE
http_api_upload                           v0.1                28940c884192        20 seconds ago      842 MB
```

##list option for change config of app

* host_database         `-e "APP_DATABASE_HOST=172.16.227.149"`
* port_database         `-e "APP_DATABASE_PORT=3306"`
* user_database         `-e "APP_DATABASE_USER=root"`
* pass_database         `-e "APP_DATABASE_PASS=123456"`
* app_user              `-e "APP_USER=dongvt"`
* app_pass              `-e "APP_PASS=dongvt"`
* app_file_size_allow   `-e "APP_FILE_SIZE_ALLOW=1048576"`  (1MB)
* app_scret_key         `-e "APP_SECRET_KEY=sdsadafasf"` 

3. Start container
 a. Start Mysql container
 ```
[root@localhost setup]# docker run -itd -p 3306:3306 -e "MYSQL_ROOT_PASSWORD=root" -e "MYSQL_USER=dongvt" -e "MYSQL_PASSWORD=dongvt" -e "MYSQL_DATABASE=file_upload" --name=mysql  mysql:5.7
6f04cbb5cb13b15902261aea18808c5538db76888ba3dd6262a17f1b29d98b09
 ```

 b. Start application
```
[root@localhost setup]# docker run -itd -p 8080:80 -e "APP_DATABASE_HOST=192.168.243.133" -e "APP_DATABASE_PORT=3306" -e "APP_DATABASE_USER=dongvt" -e "APP_DATABASE_PASS=dongvt" -e "APP_DATABASE_NAME=file_upload" --name=http_api_upload  28940c884192
```

 c. check
```
[root@localhost setup]# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                               NAMES
db9bb1c2e963        28940c884192        "./upstart.sh"           49 seconds ago      Up 48 seconds       0.0.0.0:8080->80/tcp                http_api_upload
6f04cbb5cb13        mysql:5.7           "docker-entrypoint..."   5 minutes ago       Up 5 minutes        0.0.0.0:3306->3306/tcp, 33060/tcp   mysql
```

==> DONE

### Install with docker-compose
=======

we can install with docker-compose so fast

requitment:
   - Docker deamon
   - docker-compose version 1.22.0

1. get code from github

`[root@localhost:~]mkdir /project/`

```
[root@localhost ~]# cd /project/
[root@localhost project]# git clone https://github.com/dongvothanh/http-api-upload.git
Cloning into 'http-api-upload'...
remote: Counting objects: 114, done.
remote: Compressing objects: 100% (26/26), done.
remote: Total 114 (delta 5), reused 25 (delta 4), pack-reused 81
Receiving objects: 100% (114/114), 56.26 MiB | 5.22 MiB/s, done.
Resolving deltas: 100% (9/9), done.
```


2. start container with docker-compose
```
cd /project/http-api-upload/setup/container/
docker-compose up --build -d
```

3. check

```
[root@localhost container]# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                   PORTS                  NAMES
5f571b4169ab        app_api_upload:v1   "./upstart.sh"           8 minutes ago       Up 8 minutes             0.0.0.0:1234->80/tcp   app_v1
4e565976dfd7        mysql:5.7           "docker-entrypoint..."   8 minutes ago       Up 8 minutes (healthy)   3306/tcp, 33060/tcp    mysql
[root@localhost container]#
```

==> DONE INSTALL