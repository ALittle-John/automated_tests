*** Settings ***
Resource    web/web_common.resource
Resource    web/specific_resources/gemini.resource

# *** Variables ***
# ${TEST_response_gemini_number}    ${0}

*** Test Cases ***
Gherkin Gemini Test
    Given Open Targget Website    url=https://gemini.google.com/
    When Add Text Question Into Gemini    text=Say "Hi" to my automation using Robot Framework and Python that sent this prompt. No need to analyse the attached file.
    And Add Local File Into Gemini    base_path=Pictures    file_name=for_gemini_test.png
    And Send The Message To Gemini
    # But Not Logged, Do Log in
    #     And Send The Message To Gemini
    Then Store Visual Gemini Response
