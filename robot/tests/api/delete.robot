*** Settings ***
Library    ../../../my_own/api/python/routs.py

Resource    ../../resources/api/common_api.resource

Suite Setup    Start Local Fast Api
Suite Teardown    Shutdown Local Fast Api

*** Test Cases ***
Add New Device
    ${response_body}    Custom REST Request    alias=device_api    base_url=http://127.0.0.1:8000    method=DELETE    final_url=/smartphones/devices/new?brand=lg&device_name=MotorolaG86
