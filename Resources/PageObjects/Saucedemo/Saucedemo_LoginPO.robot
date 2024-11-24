*** Settings ***
Library     SeleniumLibrary
Library     Collections
# Loading reusable resources and common keywords for the project
Resource    ../CommonPO.robot

*** Keywords ***
Input Username and Password
    [Arguments]    ${username}    ${password}
    Input Text    locator=css:#user-name    text=${username}
    Input Text    locator=css:#password    text=${password}

Click login button
    Click Element    locator=css:#login-button

Login with standard_user
    Input Username and Password    username=standard_user    password=secret_sauce
    Click login button
    Wait Until Location Contains    expected=/inventory.html    timeout=30s