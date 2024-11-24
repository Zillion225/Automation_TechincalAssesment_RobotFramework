*** Settings ***
Library     SeleniumLibrary
Library     Collections
# Loading reusable resources and common keywords for the project
Resource    ../CommonPO.robot

*** Variables ***
${BASE_URL}     https://www.saucedemo.com    # Base URL for the main application

*** Keywords ***
Open browser then navigate to test url
    [Arguments]    ${browser}=chrome    ${window_width}=1280    ${window_height}=800
    Open Browser    browser=${browser}    url=${BASE_URL}
    Set Window Size    width=${window_width}    height=${window_height}