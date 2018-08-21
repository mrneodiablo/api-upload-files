# -*- coding: utf-8 -*-
from django.conf.urls import url
from api.v1 import views as view_v1


# v1 api
urlpatterns = [


    url(r'^v1/file/$', view_v1.FileUploadViewSet.as_view()),


    url(r'^v1/file/(?P<name>[a-zA-Z0-9_-].+)$', view_v1.FileViewSet.as_view()),



]