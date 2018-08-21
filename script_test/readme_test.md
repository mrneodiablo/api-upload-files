## DESCRIBE
script **test_api.py** use for test api of server with auto generate `AUTHEN KEY` and `SIGN` with data file in folder **datates**   

 - upload file
 - retrieve file
 - delete file


 or can use **POSTMAN**
 
## RUN
 `python2.7 test_api.py `

## SAMPLE OUTPUT
```
==== upload file sdasdas.csv
=========== header ============
{'sign-client': '2ffa7ad4fa14370e2a3fc814dd096415', 'authenticate': 'Basic ZG9uZ3Z0OmRvbmd2dA=='}
=========== respone ===========
{
    "response_message": "create success", 
    "respone_code": 0, 
    "response_data": {
        "time_modify": "2018-04-14T07:15:30.729817", 
        "hash": "e442926f0e6c255e3dd1bcb8c1dc1d26", 
        "id": 11, 
        "time_upload": "2018-04-14T07:15:30.729778", 
        "name": "sdasdas.csv"
    }
}



==== upload file case1.txt
=========== header ============
{'sign-client': '1152c01b9c5bdc620f978c8dab0acccb', 'authenticate': 'Basic ZG9uZ3Z0OmRvbmd2dA=='}
=========== respone ===========
{
    "response_message": "file has existed", 
    "respone_code": -426, 
    "response_data": {
        "time_modify": "2018-04-14T06:24:02", 
        "hash": "4692991e40007f5ec0bbddc98d99dcfe", 
        "id": 1, 
        "time_upload": "2018-04-14T06:24:02", 
        "name": "case1.txt"
    }
}



==== delete file sdasdas.csv
=========== header ============
{'authenticate': 'Basic ZG9uZ3Z0OmRvbmd2dA=='}
=========== respone ===========
{
    "response_message": "success", 
    "respone_code": 0, 
    "response_data": "remove file sdasdas.csv"
}



==== get file case1.txt
=========== header ============
{'authenticate': 'Basic ZG9uZ3Z0OmRvbmd2dA=='}
=========== respone ===========

# TOOL uppatch local
	10.17.21.15:8888 DC SING
    restart tool: /etc/init.d/gunicorn restart

# API UPPACTH
   172.31.0.63: 9090 AWS
   
   stop: ps aux | grep python
	   kill process gunicorn
   
   start: /build/python2.7/bin/python2.7 /build/python2.7/bin/supervisord -c /etc/supervisord.conf
     start service supervisord là service monitor process auto check start process


# API get CCU
  172.31.5.221
  restart tool: /etc/init.d/gunicorn restart
       
```
