# -*- coding: utf-8 -*-
import os, sys, shutil
from setuptools import setup

install_requires = "install_requires.txt"

with open(install_requires, "r") as file_install:
    list_req = file_install.readlines()
    install_requires = [ x.strip("\n") for x in list_req]

    setup(
        version='1.0',
        author='dongvt',
        author_email='vothanhdong18@gmail.com',
        include_package_data=False,
        install_requires=install_requires,
    )

    file_install.close()
