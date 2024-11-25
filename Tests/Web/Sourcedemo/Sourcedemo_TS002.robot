*** Settings ***
Documentation    
...    This test suite automates the testing of the login functionality for the Saucedemo website using the Robot Framework. 
...    It validates the behavior of the login page when incorrect credentials are used, 
...    ensuring error messages appear as expected.
# Import necessary libraries and resource files
Library             SeleniumLibrary
Library             JSONLibrary
Library             DataDriver    file=Resources/InputExpect/TC_002/DataList.xlsx    encoding=UTF-8
Resource            ../../../Resources/PageObjects/CommonPO.robot
Resource            ../../../Resources/PageObjects/Saucedemo/Saucedemo_CommonPO.robot
Resource            ../../../Resources/PageObjects/Saucedemo/Saucedemo_LoginPO.robot
Test Setup          Saucedemo_CommonPO.Open browser then navigate to test url
Test Teardown       Close Browser

*** Variables ***
# Define default configurations and paths
${BROWSER}                      chrome    # Browser to use for testing

*** Test Cases ***
Login with invalid username: {${username}} and password: {${password}}
    [Template]    Login error test template

*** Keywords ***
Login error test template
    [Arguments]    ${username}    ${password}    ${expected_error_message}
    Saucedemo_LoginPO.Input Username and Password    username=${username}    password=${password}
    Saucedemo_LoginPO.Click login button
    Element Should Be Visible    locator=css:.error-message-container    message=Error message container should be visible
    Page Should Contain    text=${expected_error_message}
    