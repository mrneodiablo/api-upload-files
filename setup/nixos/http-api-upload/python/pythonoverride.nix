self: pkgs:
{

  packageOverrides = pkgs : rec {

    #nix-shell -p connector-c
    connector-c = pkgs.stdenv.mkDerivation rec {
      buildInputs = [ pkgs.libiconv ];
      cmakeFlags = [
        "-DWITH_EXTERNAL_ZLIB=ON"
        "-DMYSQL_UNIX_ADDR=/run/mysqld/mysqld.sock"];
      enableParallelBuilding = true;
      meta = with pkgs.stdenv.lib; {
        description = "Client library that can be used to connect to MySQL or MariaDB";
        license = licenses.lgpl21;
        maintainers = with maintainers; [ globin ];
        platforms = platforms.all;
      };
      name = "mariadb-connector-c-${version}";
      nativeBuildInputs = [ pkgs.cmake ];
      postFixup = ''
        ln -sv mariadb_config $out/bin/mysql_config
        ln -sv mariadb $out/lib/mysql
        ln -sv mariadb $out/include/mysql
      '';
      # The cmake setup-hook uses $out/lib by default, this is not the case here.
      preConfigure = pkgs.stdenv.lib.optionalString pkgs.stdenv.isDarwin ''
        cmakeFlagsArray+=("-DCMAKE_INSTALL_NAME_DIR=$out/lib/mariadb")
      '';
      propagatedBuildInputs = [ pkgs.openssl pkgs.zlib ];
      src = pkgs.fetchurl {
        name = "mariadb-connector-c-${version}-src.tar.gz";
        sha256 = "15iy5iqp0njbwbn086x2dq8qnbkaci7ydvi84cf5z8fxvljis9vb";
        url = "https://downloads.mariadb.org/interstitial/connector-c-${version}/mariadb-connector-c-${version}-src.tar.gz/from/http%3A//nyc2.mirrors.digitalocean.com/mariadb/";
      };
      version = "2.3.6";
    };

    django = pkgs.python27Packages.buildPythonPackage rec {
      doCheck = false;
      name = "Django-${version}";
      propagatedBuildInputs = [ pkgs.python27Packages.pytz ];
      src = pkgs.fetchurl{
        sha256 = "b6f3b864944276b4fd1d099952112696558f78b77b39188ac92b6c5e80152c30";
        url = "https://files.pythonhosted.org/packages/79/43/ed9ca4d69f35b5e64f2ecad73f75a8529a9c6f0d562e5af9a1f65beda355/Django-${version}.tar.gz";
      };
      version = "1.11";
    };

    django-docs = pkgs.python27Packages.buildPythonPackage rec {
      doCheck = false;
      name = "django-docs-${version}";
      propagatedBuildInputs = [ django ];
      src = pkgs.fetchurl{
        sha256 = "75d875de511be62f8e85f5bd952498b65a9baf1fa912cf6c8e5163b3af1dcc7d";
        url = "https://files.pythonhosted.org/packages/9b/cc/f8f2ff26217e97974f79ac188dbd75e7b194aba64244b9c44d60e38c8c05/django-docs-${version}.tar.gz";
      };
      version = "0.2.1";
    };

    django-filter = pkgs.python27Packages.buildPythonPackage rec {
      doCheck = false;
      name = "django-filter-${version}";
      src = pkgs.fetchurl{
        sha256 = "ec0ef1ba23ef95b1620f5d481334413700fb33f45cd76d56a63f4b0b1d76976a";
        url = "https://files.pythonhosted.org/packages/db/12/491d519f5bee93709083c726b020ff9f09b95f32de36ae9023fbc89a21e4/django-filter-${version}.tar.gz";
      };
      version = "1.1.0";
    };

    djangorestframework = pkgs.python27Packages.buildPythonPackage rec {
      doCheck = false;
      name = "djangorestframework-${version}";
      src = pkgs.fetchurl{
        sha256 = "de8ac68b3cf6dd41b98e01dcc92dc0022a5958f096eafc181a17fa975d18ca42";
        url = "https://files.pythonhosted.org/packages/c4/05/8106de162e94ad30fdd42b4f77dcb76c656fd3f51a9c01fdbbc307fd2447/djangorestframework-${version}.tar.gz";
      };
      version = "3.6.4";
    };

    MySQL-python = pkgs.python27Packages.buildPythonPackage rec {
      buildInputs = [ connector-c ];
      doCheck = false;
      name = "mysql-python-${version}";
      src = pkgs.fetchurl{
        sha256 = "811040b647e5d5686f84db415efd697e6250008b112b6909ba77ac059e140c74";
        url = "https://files.pythonhosted.org/packages/a5/e9/51b544da85a36a68debe7a7091f068d802fc515a3a202652828c73453cad/mysql-python-${version}.zip";
      };
      version = "1.2.5";
    };

    requests = pkgs.python27Packages.buildPythonPackage rec {
      doCheck = false;
      name = "requests-${version}";
      propagatedBuildInputs = [
        pkgs.python27Packages.chardet
        pkgs.python27Packages.urllib3 ];
      src = pkgs.fetchurl{
        url = "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz";
        sha256 = "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e";
      };
      version = "2.18.4";
    };

    SQLAlchemy = pkgs.python27Packages.buildPythonPackage rec {
      doCheck = false;
      name = "SQLAlchemy-${version}";
      src = pkgs.fetchurl{
        sha256 = "7cb00cc9b9f92ef8b4391c8a2051f81eeafefe32d63c6b395fd51401e9a39edb";
        url = "https://files.pythonhosted.org/packages/da/ef/f10a6892f8ff3c1fec1c25699a7379d1f72f291c8fa40b71c31cab3f779e/SQLAlchemy-${version}.tar.gz";
      };
      version = "1.2.6";
    };

    uwsgi = pkgs.python27Packages.buildPythonPackage rec {
      doCheck = false;
      name = "uwsgi-${version}";
      src = pkgs.fetchurl{
        sha256 = "3dc2e9b48db92b67bfec1badec0d3fdcc0771316486c5efa3217569da3528bf2";
        url = "https://files.pythonhosted.org/packages/98/b2/19b34b20662d111f7d2f926cdf10e13381761dd7dbd10666b9076cbdcd22/uwsgi-${version}.tar.gz";
      };
      version = "2.0.17";
    };    

    # nix-shell -p python.pkgs.my_stuff  
    # python27 = pkgs.python27.override {
    #   packageOverrides = self: pkgs: rec {

    #     django = pkgs.python27Packages.buildPythonPackage rec {
    #       doCheck = false;
    #       name = "Django-${version}";
    #       propagatedBuildInputs = [ pkgs.python27Packages.pytz ];
    #       src = pkgs.fetchurl{
    #         sha256 = "b6f3b864944276b4fd1d099952112696558f78b77b39188ac92b6c5e80152c30";
    #         url = "https://files.pythonhosted.org/packages/79/43/ed9ca4d69f35b5e64f2ecad73f75a8529a9c6f0d562e5af9a1f65beda355/Django-${version}.tar.gz";
    #       };
    #       version = "1.11";
    #     };

    #     django-docs = pkgs.python27Packages.buildPythonPackage rec {
    #       doCheck = false;
    #       name = "django-docs-${version}";
    #       propagatedBuildInputs = [ django ];
    #       src = pkgs.fetchurl{
    #         sha256 = "75d875de511be62f8e85f5bd952498b65a9baf1fa912cf6c8e5163b3af1dcc7d";
    #         url = "https://files.pythonhosted.org/packages/9b/cc/f8f2ff26217e97974f79ac188dbd75e7b194aba64244b9c44d60e38c8c05/django-docs-${version}.tar.gz";
    #       };
    #       version = "0.2.1";
    #     };

    #     django-filter = pkgs.python27Packages.buildPythonPackage rec {
    #       doCheck = false;
    #       name = "django-filter-${version}";
    #       src = pkgs.fetchurl{
    #         sha256 = "ec0ef1ba23ef95b1620f5d481334413700fb33f45cd76d56a63f4b0b1d76976a";
    #         url = "https://files.pythonhosted.org/packages/db/12/491d519f5bee93709083c726b020ff9f09b95f32de36ae9023fbc89a21e4/django-filter-${version}.tar.gz";
    #       };
    #       version = "1.1.0";
    #     };

    #     djangorestframework = pkgs.python27Packages.buildPythonPackage rec {
    #       doCheck = false;
    #       name = "djangorestframework-${version}";
    #       src = pkgs.fetchurl{
    #         sha256 = "de8ac68b3cf6dd41b98e01dcc92dc0022a5958f096eafc181a17fa975d18ca42";
    #         url = "https://files.pythonhosted.org/packages/c4/05/8106de162e94ad30fdd42b4f77dcb76c656fd3f51a9c01fdbbc307fd2447/djangorestframework-${version}.tar.gz";
    #       };
    #       version = "3.6.4";
    #     };

    #     MySQL-python = pkgs.python27Packages.buildPythonPackage rec {
    #       buildInputs = [ connector-c ];
    #       doCheck = false;
    #       name = "mysql-python-${version}";
    #       src = pkgs.fetchurl{
    #         sha256 = "811040b647e5d5686f84db415efd697e6250008b112b6909ba77ac059e140c74";
    #         url = "https://files.pythonhosted.org/packages/a5/e9/51b544da85a36a68debe7a7091f068d802fc515a3a202652828c73453cad/mysql-python-${version}.zip";
    #       };
    #       version = "1.2.5";
    #     };

    #     requests = pkgs.python27Packages.buildPythonPackage rec {
    #       doCheck = false;
    #       name = "requests-${version}";
    #       propagatedBuildInputs = [
    #         pkgs.python27Packages.chardet
    #         pkgs.python27Packages.urllib3 ];
    #       src = pkgs.fetchurl{
    #         url = "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz";
    #         sha256 = "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e";
    #       };
    #       version = "2.18.4";
    #     };

    #     SQLAlchemy = pkgs.python27Packages.buildPythonPackage rec {
    #       doCheck = false;
    #       name = "SQLAlchemy-${version}";
    #       src = pkgs.fetchurl{
    #         sha256 = "7cb00cc9b9f92ef8b4391c8a2051f81eeafefe32d63c6b395fd51401e9a39edb";
    #         url = "https://files.pythonhosted.org/packages/da/ef/f10a6892f8ff3c1fec1c25699a7379d1f72f291c8fa40b71c31cab3f779e/SQLAlchemy-${version}.tar.gz";
    #       };
    #       version = "1.2.6";
    #     };

    #     uwsgi = pkgs.python27Packages.buildPythonPackage rec {
    #       doCheck = false;
    #       name = "uwsgi-${version}";
    #       src = pkgs.fetchurl{
    #         sha256 = "3dc2e9b48db92b67bfec1badec0d3fdcc0771316486c5efa3217569da3528bf2";
    #         url = "https://files.pythonhosted.org/packages/98/b2/19b34b20662d111f7d2f926cdf10e13381761dd7dbd10666b9076cbdcd22/uwsgi-${version}.tar.gz";
    #       };
    #       version = "2.0.17";
    #     };
    #   };
    # };

    #nix-shell -p pythonPackages.django 
    # python27Packages = python27.pkgs;

    # nix-shell -p python4app
    python4app = pkgs.python27.withPackages (ps: with ps; [ 
                                                            ps.pip
                                                            ps.requests
                                                            django 
                                                            django-docs
                                                            django-filter
                                                            djangorestframework
                                                            MySQL-python 
                                                            SQLAlchemy
                                                            uwsgi
                                                            flask 
                                                            numpy 
                                                            toolz ]); 
  };
}
