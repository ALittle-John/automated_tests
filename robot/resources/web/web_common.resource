*** Settings ***
Library    SeleniumLibrary
Library    ../../load_env.py
Library    ../../resources/python/utils.py

*** Variables ***
${FILE_user}    %{env_google_user}
${FILE_email}    %{env_email}
${FILE_phone}    %{env_phone}
${FILE_password}    %{env_password}

${FILE_google_profile_path}    %{env_google_profile_path}

*** Keywords ***
Open Target Website
    [Documentation]    Opens a target website with optional support for a pre-authenticated browser session.
    ...
    ...    When the argument "use_user_data_dir" is set to "yes", this keyword starts the browser
    ...    using a Chrome User Data Directory that contains a previously authenticated profile.
    ...
    ...    Due to Google security policies, the first execution using a new User Data Directory
    ...    may require manual identity confirmation. This is an expected behavior.
    ...
    ...    After the initial confirmation, subsequent executions will reuse the authenticated
    ...    session automatically.
    ...
    ...    This manual confirmation is a one-time setup step and is not required again unless
    ...    the profile data is removed or invalidated.
    [Arguments]    ${url}    ${browser}=chrome    ${headless}=${False}    ${use_user_data_dir}=${False}    ${user_data_directory}=${None}    ${custom_config}=${None}

    ${browser}    Set Variable    ${browser.lower()}

    ${browser_cfg}    Build Browser Config    headless=${headless}    use_user_data_dir=${use_user_data_dir}    user_data_directory=${user_data_directory}
    ...    custom_config=${custom_config}
    Open Browser    url=${url}    browser=${browser}    options=${browser_cfg}
    Maximize Browser Window

    Set Selenium Speed    value=0.2
    Set Screenshot Directory    path=robot/tests/results/web_results

Build Browser Config
    [Arguments]    ${headless}    ${use_user_data_dir}    ${user_data_directory}    ${custom_config}=${None}

    ${browser_cfg}    Set Variable    add_argument('--no-sandbox')
    ${global_path}    Get Variable Value    ${FILE_google_profile_path}

    IF    ${use_user_data_dir} == ${True}
        ${path}       Evaluate    $user_data_directory or $global_path
        ${is_not_none}    Evaluate    $path not in [None, '', '${None}', '${EMPTY}']
        IF    ${is_not_none} == ${True}
            ${is_not_empty}    Directory Is Not Empty    path=${path}
            IF    ${is_not_empty} == ${False}
                Log    message=There isn't a saved google profile content. The browser will not open with a saved account.    level=ERROR
            ELSE
                ${browser_cfg}    Catenate    SEPARATOR=    ${browser_cfg}    ;add_argument('--user-data-dir=${path}')
            END
        END
    END
    IF    ${headless} == ${True}
        ${browser_cfg}    Catenate    SEPARATOR=    ${browser_cfg}    ;add_argument('--headless=new')
    END
    IF    ${custom_config}
        ${browser_cfg}    Catenate    SEPARATOR=    ${browser_cfg}    ;add_argument('${custom_config}')
    END

    RETURN    ${browser_cfg}

Click Target Action
    [Arguments]    ${locator_type}    ${locator}

    TRY
        Click Element    ${locator_type}=${locator}
    EXCEPT
        Run Keyword And Continue On Failure    Fail    msg=The targget button was not clickable. Locator: ${locator}
    END

# Select Google's Login Page
#     [Documentation]    Select the Google login page regardless of whether you are in a new window or the same tab.

#     @{handles}    Get Window Handles

#     FOR    ${handle}    IN    @{handles}
#         Switch Window    ${handle}
#         ${current_url}    Get Location

#         ${is_google_login}    Run Keyword And Return Status    Should Contain    ${current_url}    accounts.google.com
#         IF    ${is_google_login} == True
#             Log    Google's login page detected: ${current_url}    console=True
#             RETURN
#         END
#     END

#     Fail    The Google login page was not found in any open window/tab.

# Fill In Login Step
#     [Arguments]    ${input_locator}    ${input_value}

#     ${continue_button_locator}    Set Variable    //div[@id='identifierNext']//button
#     ${error_msg_locator}    Set Variable    //div[@id='i8']

#     TRY
#         Wait Until Element Is Visible    locator=${input_locator}    timeout=3s
#     EXCEPT
#         Fatal Error    msg=Can't continue, targget input was not visible in 3s.
#     END

#     Input Text    locator=${input_locator}    text=${input_value}
#     Click Target Action    locator_type=xpath    locator=${continue_button_locator}
#     ${status}    Run Keyword And Return Status    Element Should Be Visible    ${error_msg_locator}
#     IF    ${error_msg_locator} == True
#         ${error_msg}    Get Text    locator=${error_msg_locator}
#         Fatal Error    msg=Impossible to continue Log in. Error message: ${error_msg}
#     END

# Do Google Log in
#     [Arguments]    ${email}=${FILE_email}    ${phone}=${FILE_phone}    ${password}=${FILE_password}    ${user}=${FILE_user}

#     Select Google's Login Page

#     IF    '${email}' == '${EMPTY}' and '${phone}' == '${EMPTY}'
#         Fatal Error    msg=Can't continue, Email and phone was not passed.
#     END

#     ${identfier_value}    Set Variable If    ${email}    ${email}    ${phone}

#     Fill In Login Step    input_locator=//input[@name='identifier']    input_value=${identfier_value}
#     Fill In Login Step    input_locator=//input[@name='Passwd']    input_value=${password}

