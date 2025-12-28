*** Settings ***
Library    SeleniumLibrary
Library    ../../load_env.py

*** Variables ***
${FILE_user}    %{env_google_user}
${FILE_email}    %{env_email}
${FILE_phone}    %{env_phone}
${FILE_password}    %{env_password}

*** Keywords ***
Open Targget Website
    [Arguments]    ${url}    ${browser}=chrome    ${headless}=no

    ${browser}    Evaluate    str('${browser}').lower()
    ${is_headless}    Evaluate    str('${headless}').lower()

    IF    '${is_headless}' == 'yes' or '${is_headless}' == '${EMPTY}'
        Open Browser    url=${url}    browser=${browser}    options=add_argument('--headless')
    ELSE
        Open Browser    url=${url}    browser=${browser}
    END
    Maximize Browser Window

    Set Selenium Speed    value=0.2
    Set Screenshot Directory    path=robot/tests/results/web_results

Click Target Action
    [Arguments]    ${locator_type}    ${locator}

    TRY
        Click Element    ${locator_type}=${locator}
    EXCEPT
        Run Keyword And Continue On Failure    Fail    msg=The targget button was not clickable. Locator: ${locator}
    END

Select Google's Login Page
    [Documentation]    Select the Google login page regardless of whether you are in a new window or the same tab.

    @{handles}    Get Window Handles

    FOR    ${handle}    IN    @{handles}
        Switch Window    ${handle}
        ${current_url}    Get Location

        ${is_google_login}    Run Keyword And Return Status    Should Contain    ${current_url}    accounts.google.com
        IF    ${is_google_login} == True
            Log    Google's login page detected: ${current_url}    console=True
            RETURN
        END
    END

    Fail    The Google login page was not found in any open window/tab.

Fill In Log In Step
    [Arguments]    ${input_locator}    ${input_value}

    ${continue_button_locator}    Set Variable    //div[@id='identifierNext']//button
    ${error_msg_locator}    Set Variable    //div[@id='i8']

    TRY
        Wait Until Element Is Visible    locator=${input_locator}    timeout=3s
    EXCEPT
        Fatal Error    msg=Can't continue, targget input was not visible in 3s.
    END

    Input Text    locator=${input_locator}    text=${input_value}
    Click Target Action    locator_type=xpath    locator=${continue_button_locator}
    ${status}    Run Keyword And Return Status    Element Should Be Visible    ${error_msg_locator}
    IF    ${error_msg_locator} == True
        ${error_msg}    Get Text    locator=${error_msg_locator}
        Fatal Error    msg=Impossible to continue Log in. Error message: ${error_msg}
    END

Do Google Log in
    [Arguments]    ${email}=${FILE_email}    ${phone}=${FILE_phone}    ${password}=${FILE_password}    ${user}=${FILE_user}

    Select Google's Login Page

    IF    '${email}' == '${EMPTY}' and '${phone}' == '${EMPTY}'
        Fatal Error    msg=Can't continue, Email and phone was not passed.
    END

    ${identfier_value}    Set Variable If    ${email}    ${phone}

    Fill In Log In Step    input_locator=//input[@name='identifier']    input_value=${identfier_value}
    Fill In Log In Step    input_locator=//input[@name='Passwd']    input_value=${password}
