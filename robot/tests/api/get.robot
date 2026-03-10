*** Settings ***
Resource    ../../resources/api/common_api.resource

*** Test Cases ***
Get Reqres Fake API
    ${alias}    Set Variable    reqres
    # Normally, these are sensitive data, and aren't shared directly like this. Depends what you're connecting.
    ${base_url}    Set Variable    https://reqres.in/
    &{headers}    Create Dictionary
    ...    x-api-key={YOUR_API_KEY}
    ...    Content-Type=application/json
    # Normally, these are sensitive data, and aren't shared directly like this. Depends what you're connecting.

    ${response_body}    Custom REST Request    alias=${alias}    base_url=${base_url}    method=GET    final_url=api/users    headers=${headers}
    ${response_body}    Custom REST Request    alias=${alias}    base_url=${base_url}    method=GET    final_url=api/users/2    headers=${headers}
    ${response_body}    Custom REST Request    alias=${alias}    base_url=${base_url}    method=GET    final_url=api/users/23    headers=${headers}
