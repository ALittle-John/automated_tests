*** Settings ***
Resource    ../../../resources/api/reqres/rest.resource

*** Test Cases ***
Reqres API Method Put
    &{user_to_update}    Create Dictionary
    ...    name = morpheus
    ...    job = QA Engineer
    Reqres API    method=PUT    final_url=/users/2    data=${user_to_update}
