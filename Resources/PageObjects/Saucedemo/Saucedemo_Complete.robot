*** Settings ***
Library     SeleniumLibrary
Library     Collections
# Loading reusable resources and common keywords for the project
Resource    ../CommonPO.robot

*** Keywords ***
Verify current page is inventory page
    Location Should Contain    expected=/checkout-complete.html   message=Url should be https://www.saucedemo.com/checkout-complete.html
    Page Should Contain Element    locator=css:#checkout_complete_container    message=Page should contain complete container
    Element Should Be Visible    locator=css:.complete-header
    Element Text Should Be    locator=css:.complete-header    expected=Thank you for your order!

Back to home
    Click Button    locator=css:#back-to-products
    Wait Until Location Contains    expected=/inventory.html
    Element Should Be Visible    locator=css:#inventory_container