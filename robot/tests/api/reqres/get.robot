*** Settings ***
Resource    ../../../resources/api/reqres/rest.resource

*** Test Cases ***
Get Reqres Fake API
    ${response_body_seccess_list}    Reqres API    method=GET    final_url=users
    ${response_body_success_id}    Reqres API    method=GET    final_url=users/2
    ${response_body_error_id}    Reqres API    method=GET    final_url=users/23
    ${response_body_success_list_r}    Reqres API    method=GET    final_url={resource}
    ${response_body_error_list_r}    Reqres API    method=GET    final_url={resource}/23
