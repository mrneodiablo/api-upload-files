# -*- coding: utf-8 -*-
import base64

from django.conf import settings
from django.core.exceptions import PermissionDenied



def check_auth_basic(func):

    def wrapper(self, request, *args, **kwargs):
        sign_client = request.META['HTTP_AUTHENTICATE'].split(" ")[-1]
        sign_server = base64.b64encode(settings.USER["USERNAME"] + ":" + settings.USER["PASSWD"]).decode("ascii")

        if sign_client == sign_server:
            return func(self, request, *args, **kwargs)
        else:
            raise PermissionDenied("user pass wrong")
    return wrapper


