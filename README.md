# HTTP API UPLOAD FILE

## Features

- upload file
- retrieve file by name
- delete file by name
- if multiple files have similar contents, reuse the contents
- authentication api with Basic Authen
- signature in http header to make secure data in transport
- check file type in white-list
- check size limit

### Detail

1. multiple files have similar contents, reuse the contents

I will use database for save real name of file, file content will be save on disk and rename with its content after md5
 
==> reuse contents decreases disk use for save data file
 
Example 

 **Database**
 ```
 |------------|---------------|
 |  name      |  hash_content |
 |------------|---------------|
 |a.png       |  abcdd        |
 |b.png       |  abcdd        |
 |c.pgn       |  adssadds     |
 |------------|---------------|
``` 
 
 **File**
 ----------
 file on disk will be rename build hash content file
 
 ```
 abcdd
 adssadds
 ```
2. Authen Basic

==> Authen API

```
authen_basic = base64.b64encode(username + ":" + passwd).decode("ascii")

headers = {
            'authenticate': 'Basic ' + authen_basic,
}
```

3. make secure data in transport

Client will generate sign and put it in header , after that server recive data will be generate sign and recheck with header client send to

==> make secure data in transport

```
    SECRET_KEY = "sdfsfFKLJodsg082343223_"
    sign = hash_md5(str(md5_content_file + SECRET_KEY))
    
    headers = {
                'authenticate': 'Basic ' + str(generator_authen_basic()),
                'sign-client': sign)
    }
```

4. Check file type in white-list

```
FILE_TYPE_ALLOW = {
    "png": "image/png",
    "jpeg": "image/jpeg",
    "jpg": "image/jpeg",
    "pdf": "application/pdf",
    "txt": "text/plain",
    "csv": "text/plain",
    "abc": "application/octet-stream"
}

```

5. Check file size limit

```
FILE_SIZE = 1024*1024 # 1 MB
``` 

### Use HTTP REST API

- POST   : upload file
- GET    : retrieve file by name
- DELETE : delete file by name
- PUT    : update file by name

* Logs of app service at: `/data/uploadfile/logs`
* File will be save on dir: `/data/uploadfile/resource_upload`

## Install Server

- install manual
- install by docker file
- install by docker compose

 [Detail for setup](setup/readme_setup.MD)

## Test API
 
 [Detail for test](script_test/readme_test.MD)
 