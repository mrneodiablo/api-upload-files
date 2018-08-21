# -*- coding: utf-8 -*-

from collections import namedtuple

ErrorCodeProperties = namedtuple("ErrorCodeProperties", ["code", "message"])


# status
SUCCESS = ErrorCodeProperties(0, "success")
FAIL = ErrorCodeProperties(-1, "failed")
EXCEPTION  = ErrorCodeProperties(-100, "excection")


# data error
INVALID_DATA = ErrorCodeProperties(-110, "invalid data")
INVALID_PARAM = ErrorCodeProperties(-111, "invalid param")
INVALID_SIGNATURE = ErrorCodeProperties(-112, "invalid  signature")


# server error
ERROR = ErrorCodeProperties(-503, "error")
SERVER_ERROR = ErrorCodeProperties(-500, "server error")
FILE_DOES_NOT_SYNC = ErrorCodeProperties(-5000, "eat onions WTF  ")

# client error
BAD_REQUEST = ErrorCodeProperties(-400, "request stupid")
PERMISSION_DENY = ErrorCodeProperties(-403, "permission deny ")
NOT_FOUND = ErrorCodeProperties(-404, "file not found ")
METHOD_NOT_ALLOW = ErrorCodeProperties(-405, "method not allow ")
REQUEST_NOT_ALLOW = ErrorCodeProperties(-423, "locked ")
FILE_TYPE_NOT_ALLOW = ErrorCodeProperties(-424, "file type not allow ")
FILE_SIZE_LIMIT = ErrorCodeProperties(-425, "file size limit ")
FILE_EXIST = ErrorCodeProperties(-426, "file has existed")
FILE_DOES_NOT_EXIST = ErrorCodeProperties(-427, "file does not exist")
SIGN_ERROR = ErrorCodeProperties(-450, "sign wrong")