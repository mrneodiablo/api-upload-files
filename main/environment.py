# -*- coding: utf-8 -*-
import os

default_settings = {
    # django settings module
    "DJANGO_SETTINGS_MODULE": 'main.settings',}


def prepare_environment(**kwargs):
    for key, value in default_settings.items():
        os.environ.setdefault(key, value)
    os.environ.update(kwargs)
