*** Settings ***
Library    RequestsLibrary

*** Keywords ***
Create Authenticated Session
    [Arguments]    ${alias}    ${base_url}    ${headers}={}

    IF    not ${alias}
        Run Keyword And Continue On Failure   Fail    The request must have an alias.
        RETURN    ${False}
    END
    IF    not ${base_url}
        Run Keyword And Continue On Failure    Fail    The request must have a base URL.
        RETURN    ${False}
    END

    Create Session    alias=${alias}    url=${base_url}    headers=${headers}    disable_warnings=1
    RETURN    ${True}
