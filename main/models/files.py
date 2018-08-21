# -*- coding: utf-8 -*-

from django.db import models
from django.utils import timezone


class Files(models.Model):

    name = models.CharField(max_length=100)
    hash = models.CharField(max_length=32)
    time_upload = models.DateTimeField(auto_now_add=True)
    time_modify = models.DateTimeField(auto_now=True)