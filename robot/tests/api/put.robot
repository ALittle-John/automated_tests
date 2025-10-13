*** Settings ***
Resource    ../../resources/api/common_api.resource

*** Test Cases ***
POST Reqres Fake API
    Set Test Variable    ${ALIAS}    reqres

    &{user_to_update}    Create Dictionary
    ...    name = morpheus
    ...    job = QA Engineer
    Reqres API    method=PUT    final_url=/users/2    data=${user_to_update}

# POST Json Placeholder Fake API


# POST Swapi Fake API

