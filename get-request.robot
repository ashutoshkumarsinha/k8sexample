*** Settings ***
Library         REST              http://localhost:3000/	   ssl_verify=false


*** Test Cases ***
RESTinstance: Should have 200 status code and message with pong as value
    GET         ping
    Integer     response status   200
    String      $.message            pong
    Output      $