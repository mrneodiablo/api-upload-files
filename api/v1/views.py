# -*- coding: utf-8 -*-
import logging

from django.http import HttpResponse
from rest_framework.views import APIView
from api.exceptions import (
    FileDoesNotExist,
    DoesNotExist,
    FileTypeNotAllow,
    ServerError,
    FileSizeLimit,
    FileNotSync)

from api.utils import (
    check_file_size_limit,
    check_file_type,
    handle_delete_file_disk,
    handle_read_file_disk,
    handle_upload_file_disk
)
from api import respone_status
from main import models as main_models
from api.base import ResponseAPI
from main.serializers import FileSerializer
from api.authentication import check_auth_basic



class FileViewSet(APIView):

    logger = logging.getLogger("data")

    @check_auth_basic
    def get(self, request, name):


        status , content_type = check_file_type(name)

        # validate file type
        if status == 0:
            # file type allow

            # check file in database
            try:
                file_db = main_models.Files.objects.get(name=name)
            except main_models.Files.DoesNotExist as e:
                raise DoesNotExist(name)

            # check file on disk
            status, file_content = handle_read_file_disk(file_db.hash)

            #file okie
            if status == 0:
                self.logger.info(str(file_db.name), extra={"client_ip": request.META['REMOTE_ADDR'], "user": None})
                response = HttpResponse(file_content, content_type=str(content_type))
                response['Content-Disposition'] = 'inline; filename=' + file_db.name
                return response

            # file not found
            elif status == -1:
                raise FileNotSync(name)

            # file error
            elif status == -2:
                raise ServerError(name)

        else:
            # file type not allow
            raise FileTypeNotAllow(name)

    @check_auth_basic
    def delete(self, request, name):

        status, content_type = check_file_type(name)

        # validate file type
        if status == 0:
            # file type allow


            # check file in database
            record_link_file = 0
            try:
                file_db = main_models.Files.objects.get(name=name)
                record_link_file = main_models.Files.objects.filter(hash=file_db.hash).count()
            except main_models.Files.DoesNotExist:
                raise DoesNotExist(name)

            if record_link_file == 1:

                file_db = main_models.Files.objects.get(name=name)

                # check file on disk
                status, file_name = handle_delete_file_disk(file_db.hash)

                file_db.delete()

                # file had deleted
                if status == 0:
                    self.logger.info(str(file_db.hash) + ":" + str(file_db.name), extra={"client_ip": request.META['REMOTE_ADDR'], "user": None})
                    return ResponseAPI(
                        respone_code=respone_status.SUCCESS.code,
                        response_message=respone_status.SUCCESS.message,
                        response_data="remove file " + name).resp

                # file not found
                elif status == -1:
                    raise FileNotSync(name)

                # file error
                elif status == -2:
                    raise ServerError(name)

            elif record_link_file > 1:
                try:
                    main_models.Files.objects.get(name=name).delete()
                    self.logger.info("None" + ":" + str(file_db.name), extra={"client_ip": request.META['REMOTE_ADDR'], "user": None})
                    return ResponseAPI(
                        respone_code=respone_status.SUCCESS.code,
                        response_message=respone_status.SUCCESS.message,
                        response_data="remove file " + name).resp
                except Exception as e:
                    raise ServerError(e.message)
            else:
                raise ServerError(name)

        else:
            # file type not allow
            raise FileTypeNotAllow(name)

class FileUploadViewSet(APIView):

    logger = logging.getLogger("data")

    @check_auth_basic
    def put(self, request):

        # just get file first (can extend with upload multiple file)
        list_file_object = [obj for obj in request.FILES.values()]

        status, content_type = check_file_type(list_file_object[0].name)

        # validate file type
        if status == 0:
            # file type allow


            # check file size
            size_limit = check_file_size_limit(list_file_object[0])
            if size_limit == 0:
                # file size in limit
                try:
                    sign_client = request.META['HTTP_SIGN_CLIENT']
                except:
                    sign_client = ""
                status, message = handle_upload_file_disk(list_file_object[0], sign_client)

                if status == 0:
                    # check file name native have exits
                    try:
                        # if record have in database

                        file_db = main_models.Files.objects.get(name=str(list_file_object[0].name))
                        file_db.hash = message
                        file_db.save()
                        file_serializer = FileSerializer(file_db)

                        self.logger.info(str(file_db.hash) + ":" + str(file_db.name), extra={"client_ip": request.META['REMOTE_ADDR'], "user": None})

                        return ResponseAPI(
                            respone_code=respone_status.SUCCESS.code,
                            response_message="update " + respone_status.SUCCESS.message,
                            response_data=file_serializer.data).resp


                    except main_models.Files.DoesNotExist as e:

                        # if name native record not exits and database
                        raise DoesNotExist(str(list_file_object[0].name))

                    except Exception as e:
                        raise ServerError(str(e.message))

                elif status == -1:
                    raise FileDoesNotExist(message)
                else:
                    raise ServerError(message)

            else:
                # file size > limit
                raise FileSizeLimit(str(list_file_object[0].name))

        else:
            # file type not allow
            raise FileTypeNotAllow(str(list_file_object[0].name))

    @check_auth_basic
    def post(self, request):

        # just get file first (can extend with upload multiple file)
        list_file_object = [obj for obj in request.FILES.values()]

        status, content_type = check_file_type(list_file_object[0].name)

        # validate file type
        if status == 0:
            # file type allow


            # check file size
            size_limit = check_file_size_limit(list_file_object[0])

            # file size in limit
            if size_limit == 0:

                # TODO: force save new file with name is hash of content so if content the new file is same od file is will be same name .
                try:
                    sign_client = request.META['HTTP_SIGN_CLIENT']
                except:
                    sign_client = ""

                status, message = handle_upload_file_disk(list_file_object[0], sign_client)

                if status == 0:

                    # check file name native have exits
                    try:
                        # if record have in database

                        file_db = main_models.Files.objects.get(name=str(list_file_object[0].name))
                        file_serializer = FileSerializer(file_db)

                        self.logger.error(str(file_db.name) + " exist", extra={"client_ip": request.META['REMOTE_ADDR'], "user": None})
                        return ResponseAPI(
                            respone_code=respone_status.FILE_EXIST.code,
                            response_message=respone_status.FILE_EXIST.message,
                            response_data=file_serializer.data).resp

                    except main_models.Files.DoesNotExist as e:

                        # if name native record not exits and database
                        file_db = main_models.Files(name=str(list_file_object[0].name), hash=str(message))
                        file_db.save()
                        file_serializer = FileSerializer(file_db)
                        self.logger.info(str(file_db.hash) + ":" + str(file_db.name), extra={"client_ip": request.META['REMOTE_ADDR'], "user": None})
                        return ResponseAPI(
                            respone_code=respone_status.SUCCESS.code,
                            response_message="create " + respone_status.SUCCESS.message,
                            response_data=file_serializer.data).resp

                    except Exception as e:
                        raise ServerError(str(e.message))

                elif status == -1:
                    raise FileDoesNotExist(message)
                else:
                    raise ServerError(message)

            else:
                # file size > limit
                raise FileSizeLimit(str(list_file_object[0].name))

        # file type not allow
        else:
            raise FileTypeNotAllow(str(list_file_object[0].name))