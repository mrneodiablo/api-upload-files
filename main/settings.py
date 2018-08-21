import os


## get env variable for container

# set default
if os.environ.get("APP_SECRET_KEY") == None:
    os.environ["APP_SECRET_KEY"] = "sdfsfFKLJodsg082343223_"

if os.environ.get("APP_FILE_SIZE_ALLOW") == None:
    os.environ["APP_FILE_SIZE_ALLOW"] = str(1024*1024)

if os.environ.get("APP_USER") == None:
    os.environ["APP_USER"] = "dongvt"

if os.environ.get("APP_PASS") == None:
    os.environ["APP_PASS"] = "dongvt"


if os.environ.get("APP_DATABASE_NAME") == None:
    os.environ["APP_DATABASE_NAME"] = "file_upload"

if os.environ.get("APP_DATABASE_USER") == None:
    os.environ["APP_DATABASE_USER"] = "root"

if os.environ.get("APP_DATABASE_PASS") == None:
    os.environ["APP_DATABASE_PASS"] = "123456"

if os.environ.get("APP_DATABASE_HOST") == None:
    os.environ["APP_DATABASE_HOST"] = "127.0.0.1"

if os.environ.get("APP_DATABASE_PORT") == None:
    os.environ["APP_DATABASE_PORT"] = "3306"
###

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


SECRET_KEY = str(os.environ.get("APP_SECRET_KEY"))

DEBUG = True
ALLOWED_HOSTS = ["*"]

RESOURCE_UPLOAD = BASE_DIR + "/resource_upload/"

# Application definition

INSTALLED_APPS = [
    'django.contrib.contenttypes',
    'rest_framework',
    'api',
    'main'
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'main.urls'


WSGI_APPLICATION = 'main.wsgi.application'



DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': str(os.environ.get("APP_DATABASE_NAME")),
        'USER': str(os.environ.get("APP_DATABASE_USER")),
        'PASSWORD': str(os.environ.get("APP_DATABASE_PASS")),
        'HOST': str(os.environ.get("APP_DATABASE_HOST")),
        'PORT': str(os.environ.get("APP_DATABASE_PORT")),
    }
}

# Rest Api settings
REST_FRAMEWORK = {
    'UNICODE_JSON' : False,
    'UNAUTHENTICATED_USER': None,
    'DEFAULT_RENDERER_CLASSES': (
        'rest_framework.renderers.JSONRenderer',
    ),
    'EXCEPTION_HANDLER': 'api.handlers.exception_handler',
    'DEFAULT_PERMISSION_CLASSES': ('rest_framework.permissions.AllowAny',),
    'DEFAULT_FILTER_BACKENDS': (
        'rest_framework.filters.DjangoFilterBackend',
        'rest_framework.filters.OrderingFilter',
    )
}


# Some hacks with logs
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'standard': {
            'format': "[%(asctime)s] %(levelname)s [%(funcName)s:%(lineno)d] %(message)s",
            'datefmt': "%d-%b-%Y %H:%M:%S"
        },
        'data': {
            'format': '{ "time": "%(asctime)s", "level": "%(levelname)s", "address": "%(filename)s__%(funcName)s__%(lineno)s", "client_ip": "%(client_ip)s", "user": "%(user)s", "message": "%(message)s" }',
            'datefmt': "%Y-%m-%d %H:%M:%S"
        },
    },
    'handlers': {
        'console': {
            'level': 'DEBUG',
            'formatter': 'standard',
            'class': 'logging.StreamHandler',
        },
        'data': {
            'level': 'DEBUG',
            'formatter': 'data',
            'backupCount': 7,
            'interval': 1,
            'when': 'midnight',
            'class': 'logging.handlers.TimedRotatingFileHandler',
            'filename': BASE_DIR + "/logs/data.log"
        },
        'debug': {
            'level': 'DEBUG',
            'formatter': 'standard',
            'backupCount': 7,
            'interval': 1,
            'when': 'midnight',
            'class': 'logging.handlers.TimedRotatingFileHandler',
            'filename': BASE_DIR + "/logs/debug.log"
        },
    },
    'loggers': {
        'debug': {
            'handlers': ['debug', 'console'],
            'level': 'DEBUG'
        },
        'data': {
            'handlers': ['data'],
            'level': 'INFO'
        }

    }
}


# handler upload file ==
FILE_TYPE_ALLOW = {
    "png": "image/png",
    "jpeg": "image/jpeg",
    "jpg": "image/jpeg",
    "pdf": "application/pdf",
    "txt": "text/plain",
    "csv": "text/plain",
    "abc": "application/octet-stream"
}

# FILE_SIZE = 1024*1024 # 1 MB
FILE_SIZE = int(os.environ.get("APP_FILE_SIZE_ALLOW"))

FILE_RESOURCE_UPLOAD = BASE_DIR + "/resource_upload/"

USER = {
    "USERNAME": str(os.environ.get("APP_USER")),
    "PASSWD": str(os.environ.get("APP_PASS"))
}
# ======================

LANGUAGE_CODE = 'en'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_L10N = True


