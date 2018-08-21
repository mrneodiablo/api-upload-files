# -*- coding: utf-8 -*-
class DVTException(Exception):
    def __init__(self, *args, **kwargs):
        self.msg = (list(args)[0:1] + [""])[0]
        super(DVTException, self).__init__(*args, **kwargs)

    def __repr__(self):
        return repr(self.msg)

class UnknownTypeException(DVTException):
    _def_message = "Unknown type {}."

    def __init__(self, tp, msg=None):
        self._def_message = msg or self._def_message
        msg = self._def_message.format(tp)
        super(UnknownTypeException, self).__init__(msg)



class DataNotReady(DVTException):
    pass


class FileDoesNotExist(DVTException):
    pass


class FileExist(DVTException):
    pass

class SignError(DVTException):
    pass

class FileTypeNotAllow(DVTException):
    pass

class FileSizeLimit(DVTException):
    pass

class DoesNotExist(DVTException):
    pass

class ServerError(DVTException):
    pass

class FileNotSync(DVTException):
    pass

class JsonParseError(DVTException):
    pass
