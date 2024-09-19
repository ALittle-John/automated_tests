*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem

*** Variables ***
${RESULTS}    robot/results

*** Keywords ***
Test
  ${status}    Run Keyword And Return Status    Directory Should Exist    path=${RESULTS}
  IF    ${status} == False
    Create Directory    path=${RESULTS}
    Log To Console    Directory ${RESULTS} created
  END
  Set Screenshot Directory    path=${RESULTS}
  Log To Console    Set up all failed screenshots will be saved in ${RESULTS}
  Log To Console    Please, don't forget to delete the report file in the project root!

  Open Browser     browser=chrome   url=https://robotframework.org/?tab=0#getting-started
  Maximize Browser Window
