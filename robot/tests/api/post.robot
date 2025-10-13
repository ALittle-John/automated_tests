*** Settings ***
Resource    ../../resources/api/common_api.resource

*** Test Cases ***
POST Reqres Fake API
    Set Test Variable    ${ALIAS}    reqres

    &{login_body}    Create Dictionary
    ...    email = test@test.com
    ...    password = 1234567
    Reqres API    method=POST    final_url=/login    data=${login_body}

    &{login_body}    Create Dictionary
    ...    email = eve.holt@reqres.in
    ...    password = cityslicka
    Reqres API    method=POST    final_url=/login    data=${login_body}
