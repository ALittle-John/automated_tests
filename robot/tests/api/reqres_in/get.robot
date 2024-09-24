*** Settings ***
Resource    ../../../resources/api_keywords/reqres_in_keywords/rest.resource

*** Test Cases ***
Get Reqres Fake API
    ${response_body_seccess_list}    Reqres API Method Get    final_url=users
    ${response_body_success_id}    Reqres API Method Get    final_url=users/2
    ${response_body_error_id}    Reqres API Method Get    final_url=users/23
    ${response_body_success_list_r}    Reqres API Method Get    final_url={resource}
    ${response_body_error_list_r}    Reqres API Method Get    final_url={resource}/23
