*** Settings ***
Resource    ../../resources/api/common_api.resource

*** Test Cases ***
Get Reqres Fake API
    Set Test Variable    ${ALIAS}    reqres

    ${response_body}    Reqres API    method=GET    final_url=users
    ${response_body}    Reqres API    method=GET    final_url=users/2
    ${response_body}    Reqres API    method=GET    final_url=users/23
    ${response_body}    Reqres API    method=GET    final_url={resource}
    ${response_body}    Reqres API    method=GET    final_url={resource}/23

# Get Json Placeholder Fake API


# Get Swapi Fake API

