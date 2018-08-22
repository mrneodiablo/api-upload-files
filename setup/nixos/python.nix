with import <nixpkgs> {};

let
  pythonlib = import ./lib.nix { pkgs = pkgs;  buildPythonPackage = pkgs.python27Packages.buildPythonPackage; };

in 

pkgs.python27.buildEnv.override rec {

  extraLibs = with pkgs.python27Packages; [
    pkgs.python27Packages.pip
    pythonlib.django
    pythonlib.django-docs
    pythonlib.django-filter
    pythonlib.djangorestframework
    pythonlib.MySQL-python
    pythonlib.requests
    pythonlib.SQLAlchemy
    pythonlib.uwsgi
  ];
}
