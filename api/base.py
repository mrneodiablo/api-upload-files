# -*- coding: utf-8 -*-
from rest_framework.response import Response as RestResponse
import six, json



class ResponseAPI():
    """
    class overwrite respine format of api
    
    OrderedDict([
                    'status': 200,
                    'data': OrderedDict([{
                        'respone_code': 0,
                        'response_message': 'dddd',
                        'response_data': OrderedDict([{
                        }])
                    }]),
                    'content_type': 'application/json'
                    ])

    """

    def __init__(self, respone_code, response_message, response_data, *args):

        self.respone_code = respone_code
        self.response_message = response_message

        try:
            # load json
            self.response_data = json.loads(response_data)
        except:
            # load string
            self.response_data = response_data

        if len(args) > 0 and isinstance(args[0], six.integer_types):
            self.status = args[0]
        else:
            self.status = 200

    def _asdict(self):

        respone = dict()

        respone["status"] = self.status
        respone["content_type"] = "application/json"
        respone["data"] = dict()

        respone["data"]["respone_code"] = self.respone_code
        respone["data"]["response_message"] = self.response_message
        respone["data"]["response_data"] = self.response_data


        return respone

    # respone JSON String
    @property
    def resp(self):
        return RestResponse(**self._asdict())

    # respone is object DICT
    @property
    def resp_dict(self):
        return self._asdict()

