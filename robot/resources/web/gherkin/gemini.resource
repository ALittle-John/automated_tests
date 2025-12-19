*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    ../../python/utils.py

*** Variables ***
${response_count}    ${0}

${FILE_plus_button}    xpath=//button[contains(@class, 'upload-card-button')]
${FILE_response_element}    (//div[contains(@id, 'model-response-message-contentr')])[last()]

*** Keywords ***
Add Text Question Into Gemini
    [Arguments]    ${text}=${EMPTY}

    IF    '${text}' == '${EMPTY}'
        Run Keyword And Continue On Failure    Fail    msg=Can't ask something to Gemini... Nothing was passed to send to Gemini.
    END

    ${input_locator}    Set Variable    xpath=//div[@contenteditable="true"]/p

    ${status}    Run Keyword And Return Status    Element Should Be Enabled    ${input_locator}
    IF    ${status} == False
        Fatal Error    msg=Can't ask something to Gemini... Input was not enabled.
    END

    Input Text    locator=${input_locator}    text=${text}
    Log    message=Written the text from the text    level=WARN

Add Local File Into Gemini
    [Arguments]    ${base_path}    ${file_name}

    IF    '${base_path}' != '${EMPTY}' and '${file_name}' != '${EMPTY}'
        ${pass}    Select Action Plus Button Gemini    locator_type=data-test-id    locator=local-images-files-uploader-button
        IF    ${pass} == True
            Log    message=Base path starts from the root (home) of your system.    level=WARN

            Select File By Search File Explorer    file_name=${file_name}    path=${base_path}
        END
    ELSE
        Run Keyword And Continue On Failure    Fail    msg=Required "base_path" or "file_name" passed empty.
    END

# Add Photo From Google Photo
#     # COMMING SOON
#     Select Action Plus Button Gemini    locator_type=data-test-id    locator=uploader-photos-button

# Add File From Google Drive
#     # COMMING SOON

Select Action Plus Button Gemini
    [Arguments]    ${locator_type}    ${locator}

    ${pass}    Click Plus Button Or Fail
    IF    ${pass} == True
        Click Target Action Or Fail    ${locator_type}    ${locator}
    END

    RETURN    ${pass}

Click Plus Button Or Fail
    Click Element    ${FILE_plus_button}

    ${not_logged}    Run Keyword And Return Status
    ...    Wait Until Element Is Visible
    ...    xpath=//div[contains(@class, 'uploader-signed-out-tooltip')]
    ...    timeout=3s

    ${pass}    Set Variable    ${True}
    IF    ${not_logged} == True
        ${pass}    Set Variable    ${False}
        Run Keyword And Continue On Failure    Fail    You must be logged in to use the Plus button.
    END

    RETURN    ${pass}

Click Target Action Or Fail
    [Arguments]    ${locator_type}    ${locator}

    Run Keyword And Continue On Failure
    ...    Click Element
    ...    ${locator_type}=${locator}

    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    ${locator_type}=${locator}
    ...    timeout=3s

Send The Message To Gemini
    Click Element    locator=//*[contains(@class, 'send-button-icon')]

Prove Gemini Gave Response
    ${response_container}    Set Variable    //response-container

    ${count}    Get Element Count    locator=${response_container}
    IF    ${count} == ${response_count + 1}
        Set Suite Variable    ${response_count}    ${count}
        Log    message=Gemini replied.    console=True    html=True

        ${status}    Set Variable    ${True}
    ELSE
        Run Keyword And Continue On Failure    Fail    msg=Gemini did not reply...

        ${status}    Set Variable    ${False}
    END

    # ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    locator=${FILE_response_element}    timeout=7s
    # IF    ${status} == True
    #     Log    message=Gemini replied.    console=True    html=True
    # ELSE
    #     Run Keyword And Continue On Failure    Fail    msg=Gemini did not reply...
    # END

    RETURN    ${status}

Store Visual Gemini Response
    ${status}    Prove Gemini Gave Response
    IF    ${status} == True
        ${ui_html_response}    Get Element Attribute    locator=${FILE_response_element}    attribute=innerHTML
        Create File    path=robot/tests/results/gemini/gemini_response.html    content=${ui_html_response}
    END
