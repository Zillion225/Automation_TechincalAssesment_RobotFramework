*** Settings ***
Library     SeleniumLibrary
Library     Collections
# Loading reusable resources and common keywords for the project
Resource    ../CommonPO.robot

*** Keywords ***
Verify current page is inventory page
    Location Should Contain    expected=/checkout-step-two.html    message=Url should be https://www.saucedemo.com/checkout-step-two.html
    Page Should Contain Element    locator=css:#checkout_summary_container    message=Page should contain check out summary container

Get all product name in page
    @{product_list}=    CommonPO.Get list of text from locator    locator=css:.cart_list .cart_item .inventory_item_name
    RETURN    ${product_list}

Get subtotal price in cart
    ${text}=    Get Text    locator=css:.summary_info .summary_subtotal_label
    ${numeric}=    CommonPO.Convert text to numeric    text=${text}
    RETURN    ${numeric}

Get tax in cart
    ${text}=    Get Text    locator=css:.summary_info .summary_tax_label
    ${numeric}=    CommonPO.Convert text to numeric    text=${text}
    RETURN    ${numeric}

Next step
    Click Element    locator=css:#finish
    Wait Until Location Contains    expected=/checkout-complete.html
    Element Should Be Visible    locator=css:#checkout_complete_container

Back to home
    Click Button    locator=css:#back-to-products
    Wait Until Location Contains    expected=/inventory.html
    Element Should Be Visible    locator=css:#inventory_container