shortenurl
=====

## Run
```shell
$ make
```


## Example usage

``` shell
$ curl -i -X POST http://localhost:8080/longurl
```

``` shell
HTTP/1.1 200 OK
content-length: 38
content-type: text/plain
date: Tue, 01 May 2018 19:02:37 GMT
server: Cowboy

http://localhost:8080/5RtLbSs4w5eUjA==
```

```shell
$ curl -i http://localhost:8080/5RtLbSs4w5eUjA==
```

```shell
HTTP/1.1 301 Moved Permanently
content-length: 0
date: Tue, 01 May 2018 19:02:55 GMT
location: longurl
server: Cowboy
```
