*** Settings ***
Library    ../../../qa_lib/my_python/api/routs.py

Resource    ../../resources/api/common_api.resource

Suite Setup    Start Local Fast Api
Suite Teardown    Shutdown Local Fast Api

*** Test Cases ***
Add New Device
    # ${brand}    Set Variable    lg
    # ${company}    Set Variable    LG
    # ${device_name}    Set Variable    MotorolaG86
    @{memory_options}    Create List    128    256

    &{device_data}    Create Dictionary
    ...    company=LG
    ...    model=G86
    ...    release_year=2022
    ...    release_price_usd=368.46
    ...    screen=pOLED HDR10+ com Gorilla Glass 7i
    ...    processor=Dimensity 7300 Octa core de 2,5GHz
    ...    front_camera=32MP
    ...    batery_mah=5200
    ...    memory_options=${memory_options}

    ${response_body}    Custom REST Request    alias=device_api    base_url=http://127.0.0.1:8000    method=POST    final_url=/smartphones/devices/new?brand=lg&device_name=MotorolaG86    data=${device_data}
