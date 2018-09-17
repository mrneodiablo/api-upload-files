# -*- coding: utf-8 -*-
import base64
import hashlib
import requests
import json
import os

URL = "http://elbhttpupload-1440253491.ap-southeast-1.elb.amazonaws.com:80/api/v1/file/"

def hash_md5(data):
    md5sum = hashlib.md5()
    md5sum.update(str(data))
    return str(md5sum.hexdigest())

def generator_authen_basic():
    username = "dongvt"
    passwd   = "dongvt"
    authen_basic = base64.b64encode(username + ":" + passwd).decode("ascii")
    return str(authen_basic)

def generate_sign(md5_content_file):
    SECRET_KEY = "sdfsfFKLJodsg082343223_"
    sign = hash_md5(str(md5_content_file + SECRET_KEY))
    return sign


def upload_file(file):

    data = ""
    with open(file, 'rb') as f:
        data = f.read()
    f.close()


    files = {'files': open(file, 'rb')}
    headers = {
                'authenticate': 'Basic ' + str(generator_authen_basic()),
                'sign-client': generate_sign(hash_md5(data))
    }
    print "=========== header ============"
    print headers
    r = requests.post(URL, files=files, headers=headers)
    print "=========== respone ==========="
    print json.dumps(r.json(),indent=4)


def get_file(file_name):
    headers = {
        'authenticate': 'Basic ' + str(generator_authen_basic())
    }
    print "=========== header ============"
    print headers
    r = requests.get(URL + file_name, headers=headers)

    print "=========== respone ==========="
    print r.content


def delete_file(file_name):

    headers = {
        'authenticate': 'Basic ' + str(generator_authen_basic())
    }
    print "=========== header ============"
    print headers
    r = requests.delete(URL+ file_name, headers=headers)

    print "=========== respone ==========="
    print headers
    print json.dumps(r.json(), indent=4)


if __name__ == '__main__':

    dir_file = os.getcwd()
    print "==== upload file case7.pdf"
    upload_file(dir_file + '/datatest/case7.pdf')

    print "\n\n"
    print "==== upload file case9.csv"
    upload_file(dir_file + '/datatest/case9.csv')


    print "\n\n"
    print "==== delete file case9.csv"
    delete_file(dir_file + "/case9.csv")

    print "\n\n"
    print "==== delete file asd.dd"
    delete_file("asd.dd")

    print "\n\n"
    print "==== get file case9.csv"
    get_file("case9.csv")
