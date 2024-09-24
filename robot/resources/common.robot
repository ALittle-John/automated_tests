*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem

*** Keywords ***
Setup Browser
  [Arguments]    ${url}

  ${results}    Set Variable    robot/results

  ${status}    Run Keyword And Return Status    Directory Should Exist    path=${results}
  IF    ${status} == False
    Create Directory    path=${results}
    Log To Console    Directory ${results} created
  END

  Set Screenshot Directory    path=${results}
  Log To Console    Set up all failed screenshots will be saved in ${results}
  Log To Console    Please, don't forget to delete the report file in the project root!

  Open Browser     browser=chrome   url=${url}
  Maximize Browser Window
