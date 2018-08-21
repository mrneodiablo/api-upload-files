# -*- coding: utf-8 -*-

import logging
import sys
import traceback

import six
from django.core.exceptions import PermissionDenied

from django.core import exceptions as djexcs
from django.http import Http404
from rest_framework import exceptions, status, views
from rest_framework.response import Response
from api.base import ResponseAPI
from api import respone_status
from api import exceptions as mexcs
from rest_framework.compat import set_rollback


logger = logging.getLogger("debug")


def default_handler(exc, context):

    logger.error(traceback.format_exc())

    if isinstance(exc, exceptions.APIException):

        if isinstance(exc.detail, (list, dict)):
            data = exc.detail
        else:
            data = {'detail': exc.detail}

        set_rollback()

        return ResponseAPI(
            respone_code=respone_status.EXCEPTION.code,
            response_message=respone_status.EXCEPTION.message,
            response_data=None
        ).resp

    elif isinstance(exc, Http404):
        msg = ('Not found.')
        data = {'detail': six.text_type(msg)}

        set_rollback()
        return ResponseAPI(
            respone_code=respone_status.NOT_FOUND.code,
            response_message=respone_status.NOT_FOUND.message + " " + str(data),
            response_data=None
        ).resp

    elif isinstance(exc, PermissionDenied):

        set_rollback()
        return ResponseAPI(
            respone_code=respone_status.PERMISSION_DENY.code,
            response_message=respone_status.PERMISSION_DENY.message + " " + str(exc),
            response_data=None
        ).resp

    return None

def exception_handler(exc, context):

    logger.error(traceback.format_exc())

    default_exc = (exceptions.APIException, djexcs.PermissionDenied)

    if isinstance(exc, PermissionDenied):

        return ResponseAPI(
                            respone_code=respone_status.PERMISSION_DENY.code,
                            response_message=respone_status.PERMISSION_DENY.message + " " + str(exc.message),
                            response_data=None
        ).resp
    elif isinstance(exc, mexcs.UnknownTypeException):

        return ResponseAPI(
            respone_code=respone_status.EXCEPTION.code,
            response_message=respone_status.EXCEPTION.message + + str(exc.msg),
            response_data=None
        ).resp
    elif isinstance(exc, mexcs.FileDoesNotExist):
        return ResponseAPI(
            respone_code=respone_status.NOT_FOUND.code,
            response_message=respone_status.NOT_FOUND.message,
            response_data=exc.msg
        ).resp
    elif isinstance(exc, mexcs.FileExist):
        return ResponseAPI(
            respone_code=respone_status.FILE_EXIST.code,
            response_message=respone_status.FILE_EXIST.message,
            response_data=exc.msg).resp
    elif isinstance(exc, mexcs.DoesNotExist):
        return ResponseAPI(
            respone_code=respone_status.NOT_FOUND.code,
            response_message=respone_status.NOT_FOUND.message,
            response_data=exc.msg
        ).resp
    elif isinstance(exc, mexcs.FileTypeNotAllow):
        return ResponseAPI(
            respone_code=respone_status.FILE_TYPE_NOT_ALLOW.code,
            response_message=respone_status.FILE_TYPE_NOT_ALLOW.message,
            response_data=exc.msg
        ).resp
    elif isinstance(exc, mexcs.FileNotSync):
        return ResponseAPI(
            respone_code=respone_status.FILE_DOES_NOT_SYNC.code,
            response_message=respone_status.FILE_DOES_NOT_SYNC.message + exc.msg,
            response_data=None
        ).resp
    elif isinstance(exc, mexcs.FileSizeLimit):
        return ResponseAPI(
            respone_code=respone_status.FILE_SIZE_LIMIT.code,
            response_message=respone_status.FILE_SIZE_LIMIT.message,
            response_data=exc.msg
        ).resp
    elif isinstance(exc, mexcs.SignError):
        return ResponseAPI(
            respone_code=respone_status.SIGN_ERROR.code,
            response_message=respone_status.SIGN_ERROR.message,
            response_data=exc.msg
        ).resp
    elif isinstance(exc, mexcs.ServerError):
        return ResponseAPI(
            respone_code=respone_status.SERVER_ERROR.code,
            response_message=respone_status.SERVER_ERROR.message,
            response_data=exc.msg
        ).resp
    elif not isinstance(exc, default_exc) and isinstance(exc, Exception):

        return ResponseAPI(
            respone_code=respone_status.BAD_REQUEST.code,
            response_message=respone_status.BAD_REQUEST.message,
            response_data=None
        ).resp

    default_response = default_handler(exc, context)

    return default_response