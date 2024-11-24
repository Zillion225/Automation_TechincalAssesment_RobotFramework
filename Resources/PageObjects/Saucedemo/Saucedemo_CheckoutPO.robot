*** Settings ***
Library     SeleniumLibrary
Library     Collections
# Loading reusable resources and common keywords for the project
Resource    ../CommonPO.robot

*** Keywords ***
Verify current page is inventory page
    Location Should Contain    expected=/checkout-step-one.html    message=Url should be https://www.saucedemo.com/checkout-step-one.html
    Page Should Contain Element    locator=css:#checkout_info_container    message=Page should contain checkout info container

Input checkout information form
    [Arguments]    ${firstname}    ${lastname}    ${zipcode}
    Input Text    locator=css:#first-name    text=${firstname}
    Input Text    locator=css:#last-name    text=${lastname}
    Input Text    locator=css:#postal-code    text=${zipcode}

Next step
    Click Element    locator=css:#continue
    Wait Until Location Contains    expected=/checkout-step-two.html
    Element Should Be Visible    locator=css:#checkout_summary_container 