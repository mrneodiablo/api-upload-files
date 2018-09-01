{ pkgs ? import <nixpkgs> {} }:
let
  
  python-mdules = import ./python-modules.nix { inherit pkgs; };
in

pkgs.python27.buildEnv.override rec {

  extraLibs = with pkgs.python27Packages; [
    pkgs.python27Packages.pip
    python-mdules.django
    python-mdules.django-docs
    python-mdules.django-filter
    python-mdules.djangorestframework
    python-mdules.MySQL-python
    python-mdules.requests
    python-mdules.SQLAlchemy
    python-mdules.uwsgi
  ];
}
