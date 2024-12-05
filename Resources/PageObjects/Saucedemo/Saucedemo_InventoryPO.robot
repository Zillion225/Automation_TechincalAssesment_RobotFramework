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

Find min price item index
        ${list_of_prices}=    CommonPO.Get list of text from locator    locator=css:.inventory_item_price
    Log    ${list_of_prices}

    # Find Min Price Index
    ${min_price}=    Set Variable    999999
    ${min_price_index}    Set Variable    -1
    ${count}    Set Variable
    FOR  ${price_text}  IN  @{list_of_prices}
        Log    ${price_text}
        ${price}=    CommonPO.Convert text to numeric    text=${price_text}
        IF  ${price} < ${min_price}
            ${min_price}    Set Variable    ${price}
            ${min_price_index}    Set Variable    ${count}
        END
        ${count}    Evaluate    ${count} + 1
    END
    Log    ${min_price}
    Log    ${min_price_index}
    RETURN    ${min_price_index}
