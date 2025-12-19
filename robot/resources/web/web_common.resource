*** Settings ***
Library    SeleniumLibrary

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
