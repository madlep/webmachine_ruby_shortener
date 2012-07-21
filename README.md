This is a super simple example app built with [webmachine-ruby](https://github.com/seancribbs/webmachine-ruby) (the Ruby port of the Erlang [webmachine](http://wiki.basho.com/Webmachine.html) library).

The app is a simple URL shortener. 

## Create Shortened URLs

`POST` to the root path to create a shortened link. Set the `Content-Type` to `application/json` and pass in JSON data as the request body with a `"url"` field. In our example, we're creating a shortened link to [http://www.example.com](http://www.example.com)

    curl -v http://localhost:8080 -d '{"url":"http://www.example.com"}' -H "Content-Type: application/json"
    * About to connect() to localhost port 8080 (#0)
    *   Trying ::1... Connection refused
    *   Trying 127.0.0.1... connected
    * Connected to localhost (127.0.0.1) port 8080 (#0)
    > POST / HTTP/1.1
    > User-Agent: curl/7.21.4 (universal-apple-darwin11.0) libcurl/7.21.4 OpenSSL/0.9.8r zlib/1.2.5
    > Host: localhost:8080
    > Accept: */*
    > Content-Type: application/json
    > Content-Length: 32
    > 
    < HTTP/1.1 201 Created 
    < Content-Type: application/json
    < Location: http://localhost:8080/yr9hm
    < X-Webmachine-Trace-Id: 70195680386660
    < Content-Length: 0
    < Server: Webmachine-Ruby/1.0.0 Rack/1.1
    < Date: Sat, 21 Jul 2012 14:20:19 GMT
    < Connection: Keep-Alive
    < 
    * Connection #0 to host localhost left intact
    * Closing connection #0

The generated short link is contained in the `Location` field: `http://localhost:8080/yr9hm` in this case.

## Follow Shortened URLS

`GET` the location given when creating a request.

    curl -v http://localhost:8080/yr9hm
    * About to connect() to localhost port 8080 (#0)
    *   Trying ::1... Connection refused
    *   Trying 127.0.0.1... connected
    * Connected to localhost (127.0.0.1) port 8080 (#0)
    > GET /yr9hm HTTP/1.1
    > User-Agent: curl/7.21.4 (universal-apple-darwin11.0) libcurl/7.21.4 OpenSSL/0.9.8r zlib/1.2.5
    > Host: localhost:8080
    > Accept: */*
    > 
    < HTTP/1.1 301 Moved Permanently 
    < Content-Type: application/json
    < Location: http://www.example.com
    < X-Webmachine-Trace-Id: 70195680433860
    < Content-Length: 0
    < Server: Webmachine-Ruby/1.0.0 Rack/1.1
    < Date: Sat, 21 Jul 2012 14:24:17 GMT
    < Connection: Keep-Alive
    < 
    * Connection #0 to host localhost left intact
    * Closing connection #0

This serves up a redirect to the original URL we created a shortend URL for
