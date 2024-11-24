*** Settings ***
Library     SeleniumLibrary
Library     Collections
# Loading reusable resources and common keywords for the project
Resource    ../CommonPO.robot

*** Keywords ***
Verify current page is inventory page
    Location Should Contain    expected=/cart.html    message=Url should be https://www.saucedemo.com/cart.html
    Page Should Contain Element    locator=css:#cart_contents_container    message=Page should contain cart container

Get all product name in page
    @{product_list}=    CommonPO.Get list of text from locator    locator=css:.cart_list .cart_item .inventory_item_name
    RETURN    ${product_list}

Next step
    Click Element    locator=css:#checkout
    Wait Until Location Contains    expected=/checkout-step-one.html
    Element Should Be Visible    locator=css:#checkout_info_container