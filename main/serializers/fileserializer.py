# -*- coding: utf-8 -*-
from rest_framework import serializers
from main import models as main_models

class FileSerializer(serializers.ModelSerializer):

    class Meta:
        model = main_models.Files
        fields = ("id",
                  "name",
                  "hash",
                  "time_upload",
                  "time_modify"
                  )


