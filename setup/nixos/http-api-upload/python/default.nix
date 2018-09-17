{ pkgs ? import <nixpkgs> {} }:

let
  python27Library = pkgs.callPackage ./libraries.nix {};
in
pkgs.python27.withPackages (
  ps: [ 
        ps.pip 
        ps.requests 
        python27Library.django 
        python27Library.django-docs 
        python27Library.django-filter 
        python27Library.djangorestframework 
        python27Library.MySQL-python 
        python27Library.SQLAlchemy 
        python27Library.uwsgi 
      ]
)
