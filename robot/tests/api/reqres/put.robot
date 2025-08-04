*** Settings ***
Resource    ../../../resources/api/reqres/rest.resource

*** Test Cases ***
Get User To Update
    ${response_body_success_id}    Reqres API Method Get    final_url=users/2
    Log To Console    message=Get User: ${response_body_success_id}

Reqres API Method Put
    &{user_to_update}    Create Dictionary
    ...    name = morpheus
    ...    job = QA Engineer
    Reqres API Method Put    final_url=/users/2    data=${user_to_update}
