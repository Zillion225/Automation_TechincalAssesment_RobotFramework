*** Settings ***
Library     SeleniumLibrary
Library     Collections
# Loading reusable resources and common keywords for the project
Resource    ../CommonPO.robot

*** Keywords ***
Verify current page is inventory page
    Location Should Contain    expected=/inventory.html    message=Url should be https://www.saucedemo.com/inventory.html
    Page Should Contain Element    locator=css:#inventory_container    message=Page should contain inventory container

Add product to cart
    [Arguments]    ${product_name}
    ${selector}=    Set Variable
    ...    xpath://div[contains(@class, 'inventory_item_name') and text()='${product_name}']/../../../..//button
    Click Element    locator=${selector}
    Wait Until Element Contains    locator=${selector}    text=Remove    timeout=5s

Add multiple products to cart
    [Arguments]    ${product_name_list}
    FOR    ${item}    IN    @{product_name_list}
        Add product to cart    product_name=${item}
    END

Click to open cart page
    Click Element    locator=css:#shopping_cart_container
    Wait Until Location Contains    expected=/cart.html

Get number of item in cart
    Scroll Element Into View    locator=css:#shopping_cart_container
    ${text}=    Get Text    locator=css:#shopping_cart_container .shopping_cart_badge
    ${number}=    CommonPO.Convert text to numeric    text=${text}
    RETURN    ${number}

Total item in cart should be
    [Arguments]    ${number}
    Scroll Element Into View    locator=css:#shopping_cart_container
    Element Text Should Be    locator=css:#shopping_cart_container .shopping_cart_badge    expected=${number}
