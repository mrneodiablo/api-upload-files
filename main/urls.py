from django.conf.urls import url, include
from main.views import api_return_error

urlpatterns = [

    # api v1
    url(r'^api/', include('api.urls')),
    # exception api
    url(r'^(?P<api>.*)$', api_return_error),
]
