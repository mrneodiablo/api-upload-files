## INSTALL
There are  3 options to install app
  - manual
  - docker
  - docker-compose

### Install manual
   
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

### Install with docker file

for build docker images from Dockerfile and run it 

folder  `container`

`docker build /container/ -t http_api_upload:v0.1`

```
[root@localhost ~]# docker build /container/ -t test_app_api:vv
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
---> Package gcc.x86_64 0:4.4.7-18.el6_9.2 will be installed
--> Processing Dependency: libgomp = 4.4.7-18.el6_9.2 for package: gcc-4.4.7-18.el6_9.2.x86_64
--> Processing Dependency: cpp = 4.4.7-18.el6_9.2 for package: gcc-4.4.7-18.el6_9.2.x86_64
--> Processing Dependency: libgcc >= 4.4.7-18.el6_9.2 for package: gcc-4.4.7-18.el6_9.2.x86_64
--> Processing Dependency: glibc-devel >= 2.2.90-12 for package: gcc-4.4.7-18.el6_9.2.x86_64
--> Processing Dependency: cloog-ppl >= 0.15 for package: gcc-4.4.7-18.el6_9.2.x86_64
--> Processing Dependency: libgomp.so.1()(64bit) for package: gcc-4.4.7-18.el6_9.2.x86_64
---> Package iputils.x86_64 0:20071127-24.el6 will be installed
--> Processing Dependency: /sbin/service for package: iputils-20071127-24.el6.x86_64
---> Package mysql.x86_64 0:5.1.73-8.el6_8 will be installed
--> Processing Dependency: mysql-libs = 5.1.73-8.el6_8 for package: mysql-5.1.73-8.el6_8.x86_64
--> Processing Dependency: perl(Sys::Hostname) for package: mysql-5.1.73-8.el6_8.x86_64
--> Processing Dependency: perl(IPC::Open3) for package: mysql-5.1.73-8.el6_8.x86_64
--> Processing Dependency: perl(Getopt::Long) for package: mysql-5.1.73-8.el6_8.x86_64
--> Processing Dependency: perl(File::Temp) for package: mysql-5.1.73-8.el6_8.x86_64
--> Processing Dependency: perl(Fcntl) for package: mysql-5.1.73-8.el6_8.x86_64
--> Processing Dependency: perl(Exporter) for package: mysql-5.1.73-8.el6_8.x86_64
--> Processing Dependency: libmysqlclient_r.so.16(libmysqlclient_16)(64bit) for package: mysql-5.1.73-8.el6_8.x86_64
--> Processing Dependency: libmysqlclient.so.16(libmysqlclient_16)(64bit) for package: mysql-5.1.73-8.el6_8.x86_64
--> Processing Dependency: /usr/bin/perl for package: mysql-5.1.73-8.el6_8.x86_64
--> Processing Dependency: libmysqlclient_r.so.16()(64bit) for package: mysql-5.1.73-8.el6_8.x86_64
--> Processing Dependency: libmysqlclient.so.16()(64bit) for package: mysql-5.1.73-8.el6_8.x86_64
---> Package mysql-devel.x86_64 0:5.1.73-8.el6_8 will be installed
---> Package openssl-devel.x86_64 0:1.0.1e-57.el6 will be installed
--> Processing Dependency: openssl = 1.0.1e-57.el6 for package: openssl-devel-1.0.1e-57.el6.x86_64
--> Processing Dependency: zlib-devel for package: openssl-devel-1.0.1e-57.el6.x86_64
--> Processing Dependency: krb5-devel for package: openssl-devel-1.0.1e-57.el6.x86_64
---> Package unzip.x86_64 0:6.0-5.el6 will be installed
--> Running transaction check
---> Package cloog-ppl.x86_64 0:0.15.7-1.2.el6 will be installed
--> Processing Dependency: libppl_c.so.2()(64bit) for package: cloog-ppl-0.15.7-1.2.el6.x86_64
--> Processing Dependency: libppl.so.7()(64bit) for package: cloog-ppl-0.15.7-1.2.el6.x86_64
---> Package cpp.x86_64 0:4.4.7-18.el6_9.2 will be installed
--> Processing Dependency: libmpfr.so.1()(64bit) for package: cpp-4.4.7-18.el6_9.2.x86_64
---> Package glibc-devel.x86_64 0:2.12-1.209.el6_9.2 will be installed
--> Processing Dependency: glibc-headers = 2.12-1.209.el6_9.2 for package: glibc-devel-2.12-1.209.el6_9.2.x86_64
--> Processing Dependency: glibc = 2.12-1.209.el6_9.2 for package: glibc-devel-2.12-1.209.el6_9.2.x86_64
--> Processing Dependency: glibc-headers for package: glibc-devel-2.12-1.209.el6_9.2.x86_64
---> Package initscripts.x86_64 0:9.03.58-1.el6.centos.2 will be installed
--> Processing Dependency: util-linux-ng >= 2.16 for package: initscripts-9.03.58-1.el6.centos.2.x86_64
--> Processing Dependency: udev >= 125-1 for package: initscripts-9.03.58-1.el6.centos.2.x86_64
--> Processing Dependency: sysvinit-tools >= 2.87-6 for package: initscripts-9.03.58-1.el6.centos.2.x86_64
--> Processing Dependency: plymouth for package: initscripts-9.03.58-1.el6.centos.2.x86_64
--> Processing Dependency: /sbin/pidof for package: initscripts-9.03.58-1.el6.centos.2.x86_64
--> Processing Dependency: /sbin/ip for package: initscripts-9.03.58-1.el6.centos.2.x86_64
--> Processing Dependency: /sbin/blkid for package: initscripts-9.03.58-1.el6.centos.2.x86_64
---> Package krb5-devel.x86_64 0:1.10.3-65.el6 will be installed
--> Processing Dependency: libkadm5(x86-64) = 1.10.3-65.el6 for package: krb5-devel-1.10.3-65.el6.x86_64
--> Processing Dependency: krb5-libs = 1.10.3-65.el6 for package: krb5-devel-1.10.3-65.el6.x86_64
--> Processing Dependency: libselinux-devel for package: krb5-devel-1.10.3-65.el6.x86_64
--> Processing Dependency: libcom_err-devel for package: krb5-devel-1.10.3-65.el6.x86_64
--> Processing Dependency: keyutils-libs-devel for package: krb5-devel-1.10.3-65.el6.x86_64
---> Package libgcc.x86_64 0:4.4.7-17.el6 will be updated
---> Package libgcc.x86_64 0:4.4.7-18.el6_9.2 will be an update
---> Package libgomp.x86_64 0:4.4.7-18.el6_9.2 will be installed
---> Package mysql-libs.x86_64 0:5.1.73-8.el6_8 will be installed
---> Package openssl.x86_64 0:1.0.1e-48.el6 will be updated
---> Package openssl.x86_64 0:1.0.1e-57.el6 will be an update
---> Package perl.x86_64 4:5.10.1-144.el6 will be installed
--> Processing Dependency: perl-libs = 4:5.10.1-144.el6 for package: 4:perl-5.10.1-144.el6.x86_64
--> Processing Dependency: perl-libs for package: 4:perl-5.10.1-144.el6.x86_64
--> Processing Dependency: perl(version) for package: 4:perl-5.10.1-144.el6.x86_64
--> Processing Dependency: perl(Pod::Simple) for package: 4:perl-5.10.1-144.el6.x86_64
--> Processing Dependency: perl(Module::Pluggable) for package: 4:perl-5.10.1-144.el6.x86_64
--> Processing Dependency: libperl.so()(64bit) for package: 4:perl-5.10.1-144.el6.x86_64
---> Package zlib-devel.x86_64 0:1.2.3-29.el6 will be installed
--> Running transaction check
---> Package glibc.x86_64 0:2.12-1.192.el6 will be updated
--> Processing Dependency: glibc = 2.12-1.192.el6 for package: glibc-common-2.12-1.192.el6.x86_64
---> Package glibc.x86_64 0:2.12-1.209.el6_9.2 will be an update
---> Package glibc-headers.x86_64 0:2.12-1.209.el6_9.2 will be installed
--> Processing Dependency: kernel-headers >= 2.2.1 for package: glibc-headers-2.12-1.209.el6_9.2.x86_64
--> Processing Dependency: kernel-headers for package: glibc-headers-2.12-1.209.el6_9.2.x86_64
---> Package iproute.x86_64 0:2.6.32-54.el6 will be installed
--> Processing Dependency: iptables >= 1.4.5 for package: iproute-2.6.32-54.el6.x86_64
--> Processing Dependency: libxtables.so.4()(64bit) for package: iproute-2.6.32-54.el6.x86_64
---> Package keyutils-libs-devel.x86_64 0:1.4-5.el6 will be installed
---> Package krb5-libs.x86_64 0:1.10.3-57.el6 will be updated
---> Package krb5-libs.x86_64 0:1.10.3-65.el6 will be an update
---> Package libcom_err-devel.x86_64 0:1.41.12-23.el6 will be installed
--> Processing Dependency: libcom_err = 1.41.12-23.el6 for package: libcom_err-devel-1.41.12-23.el6.x86_64
---> Package libkadm5.x86_64 0:1.10.3-65.el6 will be installed
---> Package libselinux-devel.x86_64 0:2.0.94-7.el6 will be installed
--> Processing Dependency: libsepol-devel >= 2.0.32-1 for package: libselinux-devel-2.0.94-7.el6.x86_64
--> Processing Dependency: pkgconfig(libsepol) for package: libselinux-devel-2.0.94-7.el6.x86_64
---> Package mpfr.x86_64 0:2.4.1-6.el6 will be installed
---> Package perl-Module-Pluggable.x86_64 1:3.90-144.el6 will be installed
---> Package perl-Pod-Simple.x86_64 1:3.13-144.el6 will be installed
--> Processing Dependency: perl(Pod::Escapes) >= 1.04 for package: 1:perl-Pod-Simple-3.13-144.el6.x86_64
---> Package perl-libs.x86_64 4:5.10.1-144.el6 will be installed
---> Package perl-version.x86_64 3:0.77-144.el6 will be installed
---> Package plymouth.x86_64 0:0.8.3-29.el6.centos will be installed
--> Processing Dependency: plymouth-core-libs = 0.8.3-29.el6.centos for package: plymouth-0.8.3-29.el6.centos.x86_64
--> Processing Dependency: system-logos for package: plymouth-0.8.3-29.el6.centos.x86_64
--> Processing Dependency: libdrm_radeon.so.1()(64bit) for package: plymouth-0.8.3-29.el6.centos.x86_64
--> Processing Dependency: libdrm_nouveau.so.1()(64bit) for package: plymouth-0.8.3-29.el6.centos.x86_64
--> Processing Dependency: libdrm_intel.so.1()(64bit) for package: plymouth-0.8.3-29.el6.centos.x86_64
--> Processing Dependency: libdrm.so.2()(64bit) for package: plymouth-0.8.3-29.el6.centos.x86_64
---> Package ppl.x86_64 0:0.10.2-11.el6 will be installed
---> Package sysvinit-tools.x86_64 0:2.87-6.dsf.el6 will be installed
---> Package udev.x86_64 0:147-2.73.el6_8.2 will be installed
--> Processing Dependency: hwdata for package: udev-147-2.73.el6_8.2.x86_64
---> Package util-linux-ng.x86_64 0:2.17.2-12.28.el6_9.2 will be installed
--> Processing Dependency: libuuid = 2.17.2-12.28.el6_9.2 for package: util-linux-ng-2.17.2-12.28.el6_9.2.x86_64
--> Processing Dependency: libblkid = 2.17.2-12.28.el6_9.2 for package: util-linux-ng-2.17.2-12.28.el6_9.2.x86_64
--> Running transaction check
---> Package glibc-common.x86_64 0:2.12-1.192.el6 will be updated
---> Package glibc-common.x86_64 0:2.12-1.209.el6_9.2 will be an update
---> Package hwdata.noarch 0:0.233-18.1.el6 will be installed
---> Package iptables.x86_64 0:1.4.7-16.el6 will be installed
--> Processing Dependency: policycoreutils for package: iptables-1.4.7-16.el6.x86_64
---> Package kernel-headers.x86_64 0:2.6.32-696.30.1.el6 will be installed
---> Package libblkid.x86_64 0:2.17.2-12.24.el6 will be updated
---> Package libblkid.x86_64 0:2.17.2-12.28.el6_9.2 will be an update
---> Package libcom_err.x86_64 0:1.41.12-22.el6 will be updated
--> Processing Dependency: libcom_err = 1.41.12-22.el6 for package: libss-1.41.12-22.el6.x86_64
---> Package libcom_err.x86_64 0:1.41.12-23.el6 will be an update
---> Package libdrm.x86_64 0:2.4.65-2.el6 will be installed
--> Processing Dependency: libpciaccess.so.0()(64bit) for package: libdrm-2.4.65-2.el6.x86_64
---> Package libsepol-devel.x86_64 0:2.0.41-4.el6 will be installed
---> Package libuuid.x86_64 0:2.17.2-12.24.el6 will be updated
---> Package libuuid.x86_64 0:2.17.2-12.28.el6_9.2 will be an update
---> Package perl-Pod-Escapes.x86_64 1:1.04-144.el6 will be installed
---> Package plymouth-core-libs.x86_64 0:0.8.3-27.el6.centos.1 will be updated
---> Package plymouth-core-libs.x86_64 0:0.8.3-29.el6.centos will be an update
---> Package redhat-logos.noarch 0:60.0.14-12.el6.centos will be installed
--> Running transaction check
---> Package libpciaccess.x86_64 0:0.13.4-1.el6 will be installed
---> Package libss.x86_64 0:1.41.12-22.el6 will be updated
---> Package libss.x86_64 0:1.41.12-23.el6 will be an update
---> Package policycoreutils.x86_64 0:2.0.83-30.1.el6_8 will be installed
--> Processing Dependency: libdbus-glib-1.so.2()(64bit) for package: policycoreutils-2.0.83-30.1.el6_8.x86_64
--> Running transaction check
---> Package dbus-glib.x86_64 0:0.86-6.el6 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

================================================================================
 Package                  Arch      Version                    Repository  Size
================================================================================
Installing:
 gcc                      x86_64    4.4.7-18.el6_9.2           updates     10 M
 iputils                  x86_64    20071127-24.el6            base       121 k
 mysql                    x86_64    5.1.73-8.el6_8             base       895 k
 mysql-devel              x86_64    5.1.73-8.el6_8             base       130 k
 openssl-devel            x86_64    1.0.1e-57.el6              base       1.2 M
 unzip                    x86_64    6.0-5.el6                  base       152 k
Installing for dependencies:
 cloog-ppl                x86_64    0.15.7-1.2.el6             base        93 k
 cpp                      x86_64    4.4.7-18.el6_9.2           updates    3.7 M
 dbus-glib                x86_64    0.86-6.el6                 base       170 k
 glibc-devel              x86_64    2.12-1.209.el6_9.2         updates    991 k
 glibc-headers            x86_64    2.12-1.209.el6_9.2         updates    620 k
 hwdata                   noarch    0.233-18.1.el6             base       1.3 M
 initscripts              x86_64    9.03.58-1.el6.centos.2     updates    949 k
 iproute                  x86_64    2.6.32-54.el6              base       389 k
 iptables                 x86_64    1.4.7-16.el6               base       254 k
 kernel-headers           x86_64    2.6.32-696.30.1.el6        updates    4.5 M
 keyutils-libs-devel      x86_64    1.4-5.el6                  base        29 k
 krb5-devel               x86_64    1.10.3-65.el6              base       504 k
 libcom_err-devel         x86_64    1.41.12-23.el6             base        33 k
 libdrm                   x86_64    2.4.65-2.el6               base       136 k
 libgomp                  x86_64    4.4.7-18.el6_9.2           updates    134 k
 libkadm5                 x86_64    1.10.3-65.el6              base       143 k
 libpciaccess             x86_64    0.13.4-1.el6               base        24 k
 libselinux-devel         x86_64    2.0.94-7.el6               base       137 k
 libsepol-devel           x86_64    2.0.41-4.el6               base        64 k
 mpfr                     x86_64    2.4.1-6.el6                base       157 k
 mysql-libs               x86_64    5.1.73-8.el6_8             base       1.2 M
 perl                     x86_64    4:5.10.1-144.el6           base        10 M
 perl-Module-Pluggable    x86_64    1:3.90-144.el6             base        41 k
 perl-Pod-Escapes         x86_64    1:1.04-144.el6             base        33 k
 perl-Pod-Simple          x86_64    1:3.13-144.el6             base       213 k
 perl-libs                x86_64    4:5.10.1-144.el6           base       579 k
 perl-version             x86_64    3:0.77-144.el6             base        52 k
 plymouth                 x86_64    0.8.3-29.el6.centos        base        89 k
 policycoreutils          x86_64    2.0.83-30.1.el6_8          base       663 k
 ppl                      x86_64    0.10.2-11.el6              base       1.3 M
 redhat-logos             noarch    60.0.14-12.el6.centos      base        15 M
 sysvinit-tools           x86_64    2.87-6.dsf.el6             base        60 k
 udev                     x86_64    147-2.73.el6_8.2           base       358 k
 util-linux-ng            x86_64    2.17.2-12.28.el6_9.2       updates    1.6 M
 zlib-devel               x86_64    1.2.3-29.el6               base        44 k
Updating for dependencies:
 glibc                    x86_64    2.12-1.209.el6_9.2         updates    3.8 M
 glibc-common             x86_64    2.12-1.209.el6_9.2         updates     14 M
 krb5-libs                x86_64    1.10.3-65.el6              base       675 k
 libblkid                 x86_64    2.17.2-12.28.el6_9.2       updates    119 k
 libcom_err               x86_64    1.41.12-23.el6             base        38 k
 libgcc                   x86_64    4.4.7-18.el6_9.2           updates    103 k
 libss                    x86_64    1.41.12-23.el6             base        42 k
 libuuid                  x86_64    2.17.2-12.28.el6_9.2       updates     72 k
 openssl                  x86_64    1.0.1e-57.el6              base       1.5 M
 plymouth-core-libs       x86_64    0.8.3-29.el6.centos        base        88 k

Transaction Summary
================================================================================
Install      41 Package(s)
Upgrade      10 Package(s)

Total download size: 78 M
Downloading Packages:

--------------------------------------------------------------------------------
Total                                           479 kB/s |  78 MB     02:47     
Retrieving key from file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
warning: rpmts_HdrFromFdno: Header V3 RSA/SHA1 Signature, key ID c105b9de: NOKEY
Importing GPG key 0xC105B9DE:
 Userid : CentOS-6 Key (CentOS 6 Official Signing Key) <centos-6-key@centos.org>
 Package: centos-release-6-8.el6.centos.12.3.x86_64 (@CentOS/6.8)
 From   : /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
Running rpm_check_debug
Running Transaction Test
Transaction Test Succeeded
Running Transaction
  Updating   : libgcc-4.4.7-18.el6_9.2.x86_64                              1/61 
  Updating   : glibc-2.12-1.209.el6_9.2.x86_64                             2/61 
  Updating   : glibc-common-2.12-1.209.el6_9.2.x86_64                      3/61 
  Installing : 1:perl-Pod-Escapes-1.04-144.el6.x86_64                      4/61 
  Installing : 1:perl-Module-Pluggable-3.90-144.el6.x86_64                 5/61 
  Installing : 4:perl-libs-5.10.1-144.el6.x86_64                           6/61 
  Installing : 1:perl-Pod-Simple-3.13-144.el6.x86_64                       7/61 
  Installing : 3:perl-version-0.77-144.el6.x86_64                          8/61 
  Installing : 4:perl-5.10.1-144.el6.x86_64                                9/61 
  Updating   : libcom_err-1.41.12-23.el6.x86_64                           10/61 
  Updating   : krb5-libs-1.10.3-65.el6.x86_64                             11/61 
  Updating   : openssl-1.0.1e-57.el6.x86_64                               12/61 
  Installing : mysql-libs-5.1.73-8.el6_8.x86_64                           13/61 
  Installing : sysvinit-tools-2.87-6.dsf.el6.x86_64                       14/61 
  Updating   : libuuid-2.17.2-12.28.el6_9.2.x86_64                        15/61 
  Installing : hwdata-0.233-18.1.el6.noarch                               16/61 
  Installing : libpciaccess-0.13.4-1.el6.x86_64                           17/61 
  Updating   : libblkid-2.17.2-12.28.el6_9.2.x86_64                       18/61 
  Installing : mysql-5.1.73-8.el6_8.x86_64                                19/61 
  Installing : libkadm5-1.10.3-65.el6.x86_64                              20/61 
  Installing : libcom_err-devel-1.41.12-23.el6.x86_64                     21/61 
  Installing : libgomp-4.4.7-18.el6_9.2.x86_64                            22/61 
  Installing : mpfr-2.4.1-6.el6.x86_64                                    23/61 
  Installing : cpp-4.4.7-18.el6_9.2.x86_64                                24/61 
  Updating   : plymouth-core-libs-0.8.3-29.el6.centos.x86_64              25/61 
  Installing : dbus-glib-0.86-6.el6.x86_64                                26/61 
  Installing : ppl-0.10.2-11.el6.x86_64                                   27/61 
  Installing : cloog-ppl-0.15.7-1.2.el6.x86_64                            28/61 
  Installing : redhat-logos-60.0.14-12.el6.centos.noarch                  29/61 
  Installing : policycoreutils-2.0.83-30.1.el6_8.x86_64                   30/61 
  Installing : iptables-1.4.7-16.el6.x86_64                               31/61 
  Installing : iproute-2.6.32-54.el6.x86_64                               32/61 
  Installing : libdrm-2.4.65-2.el6.x86_64                                 33/61 
  Installing : iputils-20071127-24.el6.x86_64                             34/61 
  Installing : plymouth-0.8.3-29.el6.centos.x86_64                        35/61 
  Installing : util-linux-ng-2.17.2-12.28.el6_9.2.x86_64                  36/61 
install-info: No such file or directory for /usr/share/info/ipc.info
  Installing : initscripts-9.03.58-1.el6.centos.2.x86_64                  37/61 
  Installing : udev-147-2.73.el6_8.2.x86_64                               38/61 
  Installing : libsepol-devel-2.0.41-4.el6.x86_64                         39/61 
  Installing : libselinux-devel-2.0.94-7.el6.x86_64                       40/61 
  Installing : zlib-devel-1.2.3-29.el6.x86_64                             41/61 
  Installing : kernel-headers-2.6.32-696.30.1.el6.x86_64                  42/61 
  Installing : glibc-headers-2.12-1.209.el6_9.2.x86_64                    43/61 
  Installing : glibc-devel-2.12-1.209.el6_9.2.x86_64                      44/61 
  Installing : keyutils-libs-devel-1.4-5.el6.x86_64                       45/61 
  Installing : krb5-devel-1.10.3-65.el6.x86_64                            46/61 
  Installing : openssl-devel-1.0.1e-57.el6.x86_64                         47/61 
  Installing : mysql-devel-5.1.73-8.el6_8.x86_64                          48/61 
  Installing : gcc-4.4.7-18.el6_9.2.x86_64                                49/61 
  Updating   : libss-1.41.12-23.el6.x86_64                                50/61 
  Installing : unzip-6.0-5.el6.x86_64                                     51/61 
  Cleanup    : openssl-1.0.1e-48.el6.x86_64                               52/61 
  Cleanup    : krb5-libs-1.10.3-57.el6.x86_64                             53/61 
  Cleanup    : libss-1.41.12-22.el6.x86_64                                54/61 
  Cleanup    : libblkid-2.17.2-12.24.el6.x86_64                           55/61 
  Cleanup    : libuuid-2.17.2-12.24.el6.x86_64                            56/61 
  Cleanup    : libcom_err-1.41.12-22.el6.x86_64                           57/61 
  Cleanup    : plymouth-core-libs-0.8.3-27.el6.centos.1.x86_64            58/61 
  Cleanup    : glibc-common-2.12-1.192.el6.x86_64                         59/61 
  Cleanup    : glibc-2.12-1.192.el6.x86_64                                60/61 
  Cleanup    : libgcc-4.4.7-17.el6.x86_64                                 61/61 
  Verifying  : libgomp-4.4.7-18.el6_9.2.x86_64                             1/61 
  Verifying  : 3:perl-version-0.77-144.el6.x86_64                          2/61 
  Verifying  : glibc-headers-2.12-1.209.el6_9.2.x86_64                     3/61 
  Verifying  : 4:perl-5.10.1-144.el6.x86_64                                4/61 
  Verifying  : udev-147-2.73.el6_8.2.x86_64                                5/61 
  Verifying  : libblkid-2.17.2-12.28.el6_9.2.x86_64                        6/61 
  Verifying  : krb5-devel-1.10.3-65.el6.x86_64                             7/61 
  Verifying  : libcom_err-1.41.12-23.el6.x86_64                            8/61 
  Verifying  : krb5-libs-1.10.3-65.el6.x86_64                              9/61 
  Verifying  : 1:perl-Module-Pluggable-3.90-144.el6.x86_64                10/61 
  Verifying  : plymouth-0.8.3-29.el6.centos.x86_64                        11/61 
  Verifying  : iptables-1.4.7-16.el6.x86_64                               12/61 
  Verifying  : keyutils-libs-devel-1.4-5.el6.x86_64                       13/61 
  Verifying  : 4:perl-libs-5.10.1-144.el6.x86_64                          14/61 
  Verifying  : sysvinit-tools-2.87-6.dsf.el6.x86_64                       15/61 
  Verifying  : iproute-2.6.32-54.el6.x86_64                               16/61 
  Verifying  : libuuid-2.17.2-12.28.el6_9.2.x86_64                        17/61 
  Verifying  : kernel-headers-2.6.32-696.30.1.el6.x86_64                  18/61 
  Verifying  : mpfr-2.4.1-6.el6.x86_64                                    19/61 
  Verifying  : initscripts-9.03.58-1.el6.centos.2.x86_64                  20/61 
  Verifying  : glibc-devel-2.12-1.209.el6_9.2.x86_64                      21/61 
  Verifying  : zlib-devel-1.2.3-29.el6.x86_64                             22/61 
  Verifying  : libss-1.41.12-23.el6.x86_64                                23/61 
  Verifying  : 1:perl-Pod-Simple-3.13-144.el6.x86_64                      24/61 
  Verifying  : unzip-6.0-5.el6.x86_64                                     25/61 
  Verifying  : cloog-ppl-0.15.7-1.2.el6.x86_64                            26/61 
  Verifying  : mysql-libs-5.1.73-8.el6_8.x86_64                           27/61 
  Verifying  : gcc-4.4.7-18.el6_9.2.x86_64                                28/61 
  Verifying  : openssl-devel-1.0.1e-57.el6.x86_64                         29/61 
  Verifying  : plymouth-core-libs-0.8.3-29.el6.centos.x86_64              30/61 
  Verifying  : hwdata-0.233-18.1.el6.noarch                               31/61 
  Verifying  : glibc-common-2.12-1.209.el6_9.2.x86_64                     32/61 
  Verifying  : libpciaccess-0.13.4-1.el6.x86_64                           33/61 
  Verifying  : util-linux-ng-2.17.2-12.28.el6_9.2.x86_64                  34/61 
  Verifying  : iputils-20071127-24.el6.x86_64                             35/61 
  Verifying  : dbus-glib-0.86-6.el6.x86_64                                36/61 
  Verifying  : glibc-2.12-1.209.el6_9.2.x86_64                            37/61 
  Verifying  : cpp-4.4.7-18.el6_9.2.x86_64                                38/61 
  Verifying  : ppl-0.10.2-11.el6.x86_64                                   39/61 
  Verifying  : mysql-5.1.73-8.el6_8.x86_64                                40/61 
  Verifying  : libsepol-devel-2.0.41-4.el6.x86_64                         41/61 
  Verifying  : redhat-logos-60.0.14-12.el6.centos.noarch                  42/61 
  Verifying  : 1:perl-Pod-Escapes-1.04-144.el6.x86_64                     43/61 
  Verifying  : libdrm-2.4.65-2.el6.x86_64                                 44/61 
  Verifying  : policycoreutils-2.0.83-30.1.el6_8.x86_64                   45/61 
  Verifying  : openssl-1.0.1e-57.el6.x86_64                               46/61 
  Verifying  : libkadm5-1.10.3-65.el6.x86_64                              47/61 
  Verifying  : libcom_err-devel-1.41.12-23.el6.x86_64                     48/61 
  Verifying  : libselinux-devel-2.0.94-7.el6.x86_64                       49/61 
  Verifying  : mysql-devel-5.1.73-8.el6_8.x86_64                          50/61 
  Verifying  : libgcc-4.4.7-18.el6_9.2.x86_64                             51/61 
  Verifying  : libuuid-2.17.2-12.24.el6.x86_64                            52/61 
  Verifying  : openssl-1.0.1e-48.el6.x86_64                               53/61 
  Verifying  : glibc-2.12-1.192.el6.x86_64                                54/61 
  Verifying  : libgcc-4.4.7-17.el6.x86_64                                 55/61 
  Verifying  : glibc-common-2.12-1.192.el6.x86_64                         56/61 
  Verifying  : libss-1.41.12-22.el6.x86_64                                57/61 
  Verifying  : libblkid-2.17.2-12.24.el6.x86_64                           58/61 
  Verifying  : krb5-libs-1.10.3-57.el6.x86_64                             59/61 
  Verifying  : libcom_err-1.41.12-22.el6.x86_64                           60/61 
  Verifying  : plymouth-core-libs-0.8.3-27.el6.centos.1.x86_64            61/61 

Installed:
  gcc.x86_64 0:4.4.7-18.el6_9.2           iputils.x86_64 0:20071127-24.el6      
  mysql.x86_64 0:5.1.73-8.el6_8           mysql-devel.x86_64 0:5.1.73-8.el6_8   
  openssl-devel.x86_64 0:1.0.1e-57.el6    unzip.x86_64 0:6.0-5.el6              

Dependency Installed:
  cloog-ppl.x86_64 0:0.15.7-1.2.el6                                             
  cpp.x86_64 0:4.4.7-18.el6_9.2                                                 
  dbus-glib.x86_64 0:0.86-6.el6                                                 
  glibc-devel.x86_64 0:2.12-1.209.el6_9.2                                       
  glibc-headers.x86_64 0:2.12-1.209.el6_9.2                                     
  hwdata.noarch 0:0.233-18.1.el6                                                
  initscripts.x86_64 0:9.03.58-1.el6.centos.2                                   
  iproute.x86_64 0:2.6.32-54.el6                                                
  iptables.x86_64 0:1.4.7-16.el6                                                
  kernel-headers.x86_64 0:2.6.32-696.30.1.el6                                   
  keyutils-libs-devel.x86_64 0:1.4-5.el6                                        
  krb5-devel.x86_64 0:1.10.3-65.el6                                             
  libcom_err-devel.x86_64 0:1.41.12-23.el6                                      
  libdrm.x86_64 0:2.4.65-2.el6                                                  
  libgomp.x86_64 0:4.4.7-18.el6_9.2                                             
  libkadm5.x86_64 0:1.10.3-65.el6                                               
  libpciaccess.x86_64 0:0.13.4-1.el6                                            
  libselinux-devel.x86_64 0:2.0.94-7.el6                                        
  libsepol-devel.x86_64 0:2.0.41-4.el6                                          
  mpfr.x86_64 0:2.4.1-6.el6                                                     
  mysql-libs.x86_64 0:5.1.73-8.el6_8                                            
  perl.x86_64 4:5.10.1-144.el6                                                  
  perl-Module-Pluggable.x86_64 1:3.90-144.el6                                   
  perl-Pod-Escapes.x86_64 1:1.04-144.el6                                        
  perl-Pod-Simple.x86_64 1:3.13-144.el6                                         
  perl-libs.x86_64 4:5.10.1-144.el6                                             
  perl-version.x86_64 3:0.77-144.el6                                            
  plymouth.x86_64 0:0.8.3-29.el6.centos                                         
  policycoreutils.x86_64 0:2.0.83-30.1.el6_8                                    
  ppl.x86_64 0:0.10.2-11.el6                                                    
  redhat-logos.noarch 0:60.0.14-12.el6.centos                                   
  sysvinit-tools.x86_64 0:2.87-6.dsf.el6                                        
  udev.x86_64 0:147-2.73.el6_8.2                                                
  util-linux-ng.x86_64 0:2.17.2-12.28.el6_9.2                                   
  zlib-devel.x86_64 0:1.2.3-29.el6                                              

Dependency Updated:
  glibc.x86_64 0:2.12-1.209.el6_9.2                                             
  glibc-common.x86_64 0:2.12-1.209.el6_9.2                                      
  krb5-libs.x86_64 0:1.10.3-65.el6                                              
  libblkid.x86_64 0:2.17.2-12.28.el6_9.2                                        
  libcom_err.x86_64 0:1.41.12-23.el6                                            
  libgcc.x86_64 0:4.4.7-18.el6_9.2                                              
  libss.x86_64 0:1.41.12-23.el6                                                 
  libuuid.x86_64 0:2.17.2-12.28.el6_9.2                                         
  openssl.x86_64 0:1.0.1e-57.el6                                                
  plymouth-core-libs.x86_64 0:0.8.3-29.el6.centos                               

Complete!
 ---> d37d0f3968ec
Removing intermediate container 2df7404dbde6
Step 4/16 : RUN mkdir /data/ -p
 ---> Running in 518d7dee1aef

 ---> 69bbace8e9db
Removing intermediate container 518d7dee1aef
Step 5/16 : COPY Python-2.7.11-1.x86_64.rpm /data/Python-2.7.11-1.x86_64.rpm
 ---> a494cfe60864
Removing intermediate container 3813b733123a
Step 6/16 : COPY uploadfile.zip /data/uploadfile.zip
 ---> ee2cf7863a4e
Removing intermediate container bbb5d20794ae
Step 7/16 : RUN rpm -ivh /data/Python-2.7.11-1.x86_64.rpm && rm -rf /data/Python-2.7.11-1.x86_64.rpm
 ---> Running in 273d8f956ae0

Preparing...                ##################################################
python                      ##################################################
 ---> a328e5ff6e3c
Removing intermediate container 273d8f956ae0
Step 8/16 : RUN cd /data/ && unzip uploadfile.zip && rm -rf uploadfile.zip
 ---> Running in 863c2d5dd809

Archive:  uploadfile.zip
   creating: uploadfile/
  inflating: uploadfile/.DS_Store    
   creating: __MACOSX/
   creating: __MACOSX/uploadfile/
  inflating: __MACOSX/uploadfile/._.DS_Store  
   creating: uploadfile/.idea/
  inflating: uploadfile/.idea/ansible_backend_api.iml  
  inflating: uploadfile/.idea/deployment.xml  
   creating: uploadfile/.idea/inspectionProfiles/
  inflating: uploadfile/.idea/inspectionProfiles/profiles_settings.xml  
  inflating: uploadfile/.idea/misc.xml  
  inflating: uploadfile/.idea/modules.xml  
  inflating: uploadfile/.idea/remote-mappings.xml  
  inflating: uploadfile/.idea/webServers.xml  
  inflating: uploadfile/.idea/workspace.xml  
   creating: uploadfile/api/
 extracting: uploadfile/api/__init__.py  
  inflating: uploadfile/api/authentication.py  
  inflating: uploadfile/api/base.py  
  inflating: uploadfile/api/exceptions.py  
  inflating: uploadfile/api/handlers.py  
  inflating: uploadfile/api/respone_status.py  
  inflating: uploadfile/api/urls.py  
  inflating: uploadfile/api/utils.py  
   creating: uploadfile/api/v1/
  inflating: uploadfile/api/v1/__init__.py  
  inflating: uploadfile/api/v1/views.py  
  inflating: uploadfile/feature_api.txt  
   creating: uploadfile/logs/
   creating: uploadfile/main/
  inflating: uploadfile/main/__init__.py  
  inflating: uploadfile/main/__init__.pyo  
  inflating: uploadfile/main/environment.py  
   creating: uploadfile/main/models/
  inflating: uploadfile/main/models/__init__.py  
  inflating: uploadfile/main/models/files.py  
   creating: uploadfile/main/serializers/
  inflating: uploadfile/main/serializers/__init__.py  
  inflating: uploadfile/main/serializers/fileserializer.py  
  inflating: uploadfile/main/settings.py  
  inflating: uploadfile/main/settings.pyo  
  inflating: uploadfile/main/urls.py  
  inflating: uploadfile/main/views.py  
  inflating: uploadfile/main/wsgi.py  
  inflating: uploadfile/manage.py    
   creating: uploadfile/resource_upload/
 extracting: uploadfile/resource_upload/image.jpeg  
   creating: uploadfile/run/
   creating: uploadfile/script_test/
   creating: uploadfile/script_test/datatest/
  inflating: uploadfile/script_test/datatest/case1.txt  
  inflating: uploadfile/script_test/datatest/case10.sjjsaf  
  inflating: uploadfile/script_test/datatest/case11.txt  
  inflating: uploadfile/script_test/datatest/case12.dfds.dsfsd  
  inflating: uploadfile/script_test/datatest/case2.txt  
  inflating: uploadfile/script_test/datatest/case3. ??  
  inflating: uploadfile/script_test/datatest/case4.11.txt  
  inflating: uploadfile/script_test/datatest/case5.a??dasdasd  
  inflating: uploadfile/script_test/datatest/case6.txt  
  inflating: uploadfile/script_test/datatest/case7.abcd  
  inflating: uploadfile/script_test/datatest/case7.pdf  
  inflating: uploadfile/script_test/datatest/case8.pdf  
  inflating: uploadfile/script_test/datatest/case9.csv  
  inflating: uploadfile/script_test/datatest/output.dat  
  inflating: uploadfile/script_test/datatest/sdasdas.csv  
  inflating: uploadfile/script_test/readme_test.md  
  inflating: uploadfile/script_test/test_api.py  
   creating: uploadfile/setup/
  inflating: uploadfile/setup/.DS_Store  
   creating: __MACOSX/uploadfile/setup/
  inflating: __MACOSX/uploadfile/setup/._.DS_Store  
   creating: uploadfile/setup/container/
  inflating: uploadfile/setup/container/Dockerfile  
  inflating: uploadfile/setup/container/Python-2.7.11-1.x86_64.rpm  
  inflating: uploadfile/setup/container/uploadfile.zip  
  inflating: uploadfile/setup/container/upstart.sh  
  inflating: uploadfile/setup/install_requires.txt  
  inflating: uploadfile/setup/readme_setup.MD  
  inflating: uploadfile/setup/setup.py  
   creating: uploadfile/setup/sources/
  inflating: uploadfile/setup/sources/Python-2.7.11-1.x86_64.rpm  
   creating: uploadfile/tool/
  inflating: uploadfile/tool/generate_database_table.sh  
  inflating: uploadfile/tool/init_service_mysql.sh  
  inflating: uploadfile/tool/init_web_app.sh  
  inflating: uploadfile/tool/upstart.sh  
 ---> 8246963f87d7
Removing intermediate container 863c2d5dd809
Step 9/16 : RUN cd /data/uploadfile/setup/ && /build/python2.7/bin/pip2.7 install --trusted-host pypi.python.org --trusted-host files.pythonhosted.org -r install_requires.txt
 ---> Running in 4c6611257d47

Collecting Django==1.11 (from -r install_requires.txt (line 1))
  Downloading https://files.pythonhosted.org/packages/47/a6/078ebcbd49b19e22fd560a2348cfc5cec9e5dcfe3c4fad8e64c9865135bb/Django-1.11-py2.py3-none-any.whl (6.9MB)
Collecting django-docs==0.2.1 (from -r install_requires.txt (line 2))
  Downloading https://files.pythonhosted.org/packages/9b/cc/f8f2ff26217e97974f79ac188dbd75e7b194aba64244b9c44d60e38c8c05/django-docs-0.2.1.tar.gz
Collecting django-filter==1.1.0 (from -r install_requires.txt (line 3))
  Downloading https://files.pythonhosted.org/packages/ee/99/eb6f20b0ca4e2800279963599971e70c71767b9d151f44fcbcd1caa19f32/django_filter-1.1.0-py2.py3-none-any.whl (45kB)
Collecting djangorestframework==3.6.4 (from -r install_requires.txt (line 4))
  Downloading https://files.pythonhosted.org/packages/12/22/98d2ea3089384b88f1ed86fb2799d8c57b59ce430c3972ec0f18986cd449/djangorestframework-3.6.4-py2.py3-none-any.whl (1.5MB)
Collecting MySQL-python==1.2.5 (from -r install_requires.txt (line 5))
  Downloading https://files.pythonhosted.org/packages/a5/e9/51b544da85a36a68debe7a7091f068d802fc515a3a202652828c73453cad/MySQL-python-1.2.5.zip (108kB)
Collecting requests==2.18.4 (from -r install_requires.txt (line 6))
  Downloading https://files.pythonhosted.org/packages/49/df/50aa1999ab9bde74656c2919d9c0c085fd2b3775fd3eca826012bef76d8c/requests-2.18.4-py2.py3-none-any.whl (88kB)
Collecting SQLAlchemy==1.2.6 (from -r install_requires.txt (line 7))
  Downloading https://files.pythonhosted.org/packages/da/ef/f10a6892f8ff3c1fec1c25699a7379d1f72f291c8fa40b71c31cab3f779e/SQLAlchemy-1.2.6.tar.gz (5.6MB)
Collecting uWSGI==2.0.1 (from -r install_requires.txt (line 8))
  Downloading https://files.pythonhosted.org/packages/38/ae/0c4c7befd5872194b399caed9a957819810bcc4a666d699c88c2c2c3dbda/uwsgi-2.0.1.tar.gz (750kB)
Collecting pytz (from Django==1.11->-r install_requires.txt (line 1))
  Downloading https://files.pythonhosted.org/packages/dc/83/15f7833b70d3e067ca91467ca245bae0f6fe56ddc7451aa0dc5606b120f2/pytz-2018.4-py2.py3-none-any.whl (510kB)
Collecting idna<2.7,>=2.5 (from requests==2.18.4->-r install_requires.txt (line 6))
  Downloading https://files.pythonhosted.org/packages/27/cc/6dd9a3869f15c2edfab863b992838277279ce92663d334df9ecf5106f5c6/idna-2.6-py2.py3-none-any.whl (56kB)
Collecting urllib3<1.23,>=1.21.1 (from requests==2.18.4->-r install_requires.txt (line 6))
  Downloading https://files.pythonhosted.org/packages/63/cb/6965947c13a94236f6d4b8223e21beb4d576dc72e8130bd7880f600839b8/urllib3-1.22-py2.py3-none-any.whl (132kB)
Collecting certifi>=2017.4.17 (from requests==2.18.4->-r install_requires.txt (line 6))
  Downloading https://files.pythonhosted.org/packages/7c/e6/92ad559b7192d846975fc916b65f667c7b8c3a32bea7372340bfe9a15fa5/certifi-2018.4.16-py2.py3-none-any.whl (150kB)
Collecting chardet<3.1.0,>=3.0.2 (from requests==2.18.4->-r install_requires.txt (line 6))
  Downloading https://files.pythonhosted.org/packages/bc/a9/01ffebfb562e4274b6487b4bb1ddec7ca55ec7510b22e4c51f14098443b8/chardet-3.0.4-py2.py3-none-any.whl (133kB)
Installing collected packages: pytz, Django, django-docs, django-filter, djangorestframework, MySQL-python, idna, urllib3, certifi, chardet, requests, SQLAlchemy, uWSGI
  Running setup.py install for django-docs: started
    Running setup.py install for django-docs: finished with status 'done'
  Running setup.py install for MySQL-python: started
    Running setup.py install for MySQL-python: finished with status 'done'
  Found existing installation: idna 2.1
    Uninstalling idna-2.1:
      Successfully uninstalled idna-2.1
  Running setup.py install for SQLAlchemy: started
    Running setup.py install for SQLAlchemy: finished with status 'done'
  Running setup.py install for uWSGI: started
    Running setup.py install for uWSGI: finished with status 'done'
Successfully installed Django-1.11 MySQL-python-1.2.5 SQLAlchemy-1.2.6 certifi-2018.4.16 chardet-3.0.4 django-docs-0.2.1 django-filter-1.1.0 djangorestframework-3.6.4 idna-2.6 pytz-2018.4 requests-2.18.4 uWSGI-2.0.1 urllib3-1.22
You are using pip version 8.1.2, however version 10.0.1 is available.
You should consider upgrading via the 'pip install --upgrade pip' command.
 ---> 452fc656c77a
Removing intermediate container 4c6611257d47
Step 10/16 : RUN cd /data/uploadfile/ && rm -rf setup feature_api.txt docs Readme.MD
 ---> Running in 371dc0b077fb

 ---> cea1f776fcc6
Removing intermediate container 371dc0b077fb
Step 11/16 : ENV PYTHONBUFFERED 1
 ---> Running in 2bc4244ed749
 ---> 2616856e4daf
Removing intermediate container 2bc4244ed749
Step 12/16 : ENV PATH /build/python2.7/bin:${PATH}
 ---> Running in 2431983567f2
 ---> 811dfa2bb27f
Removing intermediate container 2431983567f2
Step 13/16 : EXPOSE 80
 ---> Running in 59402c61456e
 ---> a9febb6a93cd
Removing intermediate container 59402c61456e
Step 14/16 : COPY upstart.sh /upstart.sh
 ---> 7cfc04d7425d
Removing intermediate container fb63b21c1649
Step 15/16 : RUN chmod +x /upstart.sh
 ---> Running in 3ff72625bbe5

 ---> 03d10f2659c4
Removing intermediate container 3ff72625bbe5
Step 16/16 : ENTRYPOINT ./upstart.sh
 ---> Running in 509e05dcf0ce
 ---> 37154887a9e6
Removing intermediate container 509e05dcf0ce
Successfully built 37154887a9e6
```


list option for change config of app

* host_database         `-e "APP_DATABASE_HOST=172.16.227.149"`
* port_database         `-e "APP_DATABASE_PORT=3306"`
* user_database         `-e "APP_DATABASE_USER=root"`
* pass_database         `-e "APP_DATABASE_PASS=123456"`
* app_user              `-e "APP_USER=dongvt"`
* app_pass              `-e "APP_PASS=dongvt"`
* app_file_size_allow   `-e "APP_FILE_SIZE_ALLOW=1048576"`  (1MB)
* app_scret_key         `-e "APP_SECRET_KEY=sdsadafasf"` 


start container
 
`docker run -itd  -p 9111:80 -e "APP_DATABASE_HOST=172.16.227.149" 37154887a9e6`


### Install with Docker-compose

we can install with docker-compose so fast

`cd container`

`docker-compose up --build -d`

use script test in folder script for test api

==> DONE INSTALL