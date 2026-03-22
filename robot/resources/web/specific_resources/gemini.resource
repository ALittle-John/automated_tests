*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    ../../qa_lib/my_python/utils/utils.py

Resource    ../web_common.resource

*** Variables ***
${response_count}    ${0}

${FILE_plus_button}    xpath=//button[contains(@class, 'upload-card-button')]
${FILE_plus_do_login}    //div[contains(@class, 'uploader-signed-out-tooltip')]//button[contains(@class, 'sign-in-button')]
${FILE_response_element}    (//div[contains(@id, 'model-response-message-contentr')])[last()]

*** Keywords ***
Close Gemini Publicity
    ${pub_close_button}    Set Variable    xpath=//button[@data-test-id='close-button']
    ${status}    Run Keyword And Return Status    Element Should Be Visible    locator=${pub_close_button}
    IF    ${status} == ${True}
        Click Element    ${pub_close_button}
    END

Add Text Question Into Gemini
    [Arguments]    ${text}=${EMPTY}

    IF    '${text}' == '${EMPTY}'
        Run Keyword And Continue On Failure    Fail    msg=Can't ask something to Gemini... Nothing was passed to send to Gemini.
    END
    Close Gemini Publicity

    ${input_locator}    Set Variable    xpath=//div[@contenteditable="true"]/p

    ${status}    Run Keyword And Return Status    Wait Until Element Is Enabled    ${input_locator}    timeout=1s
    IF    ${status} == False
        Fatal Error    msg=Can't ask something to Gemini... Input was not enabled.
    END

    Input Text    locator=${input_locator}    text=${text}
    Log    message=Written the text from the text    level=WARN

Add Local File Into Gemini
    [Arguments]    ${title_file_explorer}    ${base_path}    ${file_name}

    IF    '${base_path}' != '${EMPTY}' and '${file_name}' != '${EMPTY}'
        ${logged}    Select Action Plus Button Gemini    locator_type=xpath    locator=//button[@data-test-id='local-images-files-uploader-button']
        IF    ${logged} == True
            Log    message=Base path starts from the root (home) of your system.    level=WARN

            Select File By Search File Explorer    title_file_explorer=${title_file_explorer}    file_name=${file_name}    path=${base_path}
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

    ${logged}    Click Plus Button If Logged
    IF    ${logged} == True
        Click Target Action    ${locator_type}    ${locator}
    END

    RETURN    ${logged}

Click Plus Button If Logged
    Click Element    ${FILE_plus_button}

    ${not_logged}    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=${FILE_plus_do_login}    timeout=1.5s
    IF    ${not_logged} == True
        ${logged}    Set Variable    ${False}
        Log    message=You must be logged in to use the Plus button.    level=WARN
    ELSE
        ${logged}    Set Variable    ${True}
    END

    RETURN    ${logged}

Send The Message To Gemini
    Click Element    locator=//*[contains(@class, 'send-button-icon')]

Prove Gemini Gave Response
    ${response_container}    Set Variable    //response-container
    ${status}    Run Keyword And Return Status    Wait Until Element Is Visible    locator=${response_container}    timeout=7s
    IF    ${status} == ${True}
        ${count}    Get Element Count    locator=${response_container}
        IF    ${count} == ${response_count + 1}
            Set Suite Variable    ${response_count}    ${count}
            Log    message=Gemini replied.    console=True    html=True

            ${status}    Set Variable    ${True}
        ELSE
            Run Keyword And Continue On Failure    Fail    msg=Gemini did not reply...

            ${status}    Set Variable    ${False}
        END
    ELSE
        Run Keyword And Continue On Failure    Fail    msg=Gemini took a while to respond
    END

    RETURN    ${status}

Store Visual Gemini Response
    ${status}    Prove Gemini Gave Response
    IF    ${status} == True
        ${ui_html_response}    Get Element Attribute    locator=${FILE_response_element}    attribute=innerHTML
        Create File    path=robot/tests/results/gemini/gemini_response.html    content=${ui_html_response}
        Log    message=Created the file "gemini_response.html".    console=True    html=True
    END
