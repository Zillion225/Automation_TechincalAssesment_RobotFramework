*** Settings ***
Library     SeleniumLibrary
Library     Collections
# Loading reusable resources and common keywords for the project
Resource    ./CommonPO.robot    # Contains shared keywords and utility functions


*** Variables ***
${BASE_URL}     https://www.saucedemo.com    # Base URL for the main application


*** Keywords ***
Open browser then navigate to test url
    [Arguments]    ${browser}=chrome    ${window_width}=1280    ${window_height}=800
    Open Browser    browser=${browser}    url=${BASE_URL}
    Set Window Size    width=${window_width}    height=${window_height}

Setup login with standard_user
    [Arguments]    ${browser}=chrome
    Open browser then navigate to test url    browser=${browser}
    Input Text    locator=css:#user-name    text=standard_user
    Input Text    locator=css:#password    text=secret_sauce
    Click Element    locator=css:#login-button
    Wait Until Element Is Visible    locator=css:#header_container    timeout=10s
    Page Should Contain    text=© 2024 Sauce Labs. All Rights Reserved. Terms of Service | Privacy Policy

Add Product To Cart
    [Arguments]    ${product_name}
    ${selector}=    Set Variable
    ...    xpath://div[contains(@class, 'inventory_item_name') and text()='${product_name}']/../../../..//button
    Click Element    locator=${selector}
    Wait Until Element Contains    locator=${selector}    text=Remove    timeout=5s

Add Multiple Products To Cart
    [Arguments]    ${product_name_list}
    FOR    ${item}    IN    @{product_name_list}
        Add Product To Cart    product_name=${item}
    END

Click to open cart page
    Click Element    locator=css:#shopping_cart_container
    Wait Until Location Contains    expected=/cart.html

Click checkout button (Cart page)
    Click Element    locator=css:#checkout
    Wait Until Location Contains    expected=/checkout-step-one.html
    Element Should Be Visible    locator=css:#checkout_info_container

Input checkout information form
    [Arguments]    ${firstname}    ${lastname}    ${zipcode}
    Input Text    locator=css:#first-name    text=${firstname}
    Input Text    locator=css:#last-name    text=${lastname}
    Input Text    locator=css:#postal-code    text=${zipcode}

Click continue button (Checkout information page)
    Click Element    locator=css:#continue
    Wait Until Location Contains    expected=/checkout-step-two.html
    Element Should Be Visible    locator=css:#checkout_summary_container  

Click finish button (Checkout overview page)
    Click Element    locator=css:#finish
    Wait Until Location Contains    expected=/checkout-complete.html
    Element Should Be Visible    locator=css:#checkout_complete_container

Click back home button
    Click Button    locator=css:#back-to-products
    Wait Until Location Contains    expected=/inventory.html
    Element Should Be Visible    locator=css:#inventory_container
    
Get products in page
    ${all_inventories}=    Get WebElements    css:.inventory_list .inventory_item
    ${total}=    Get Length    ${all_inventories}
    ${all_products}=    Create List
    Log    Start create product information.
    FOR    ${index}    IN RANGE    ${total}
        Log    Index {index}
        ${product_name}=    Get Text
        ...    locator=css:.inventory_list .inventory_item:nth-child(${index + 1}) .inventory_item_name
        ${product_desc}=    Get Text
        ...    locator=css:.inventory_list .inventory_item:nth-child(${index + 1}) .inventory_item_desc
        ${product_priceText}=    Get Text
        ...    locator=css:.inventory_list .inventory_item:nth-child(${index + 1}) .inventory_item_price
        ${product_price}=    CommonPO.Convert text to numeric    text=${product_priceText}
        ${product_dic}=    Create Dictionary
        ...    index=${index}
        ...    name=${product_name}
        ...    desc=${product_desc}
        ...    price_text=${product_priceText}
        ...    price=${product_price}
        Append To List    ${all_products}    ${product_dic}
    END
    Log    ${all_products}
    RETURN    ${all_products}

Get all product name (Cart page)
    @{product_list}=    CommonPO.Get list of text from locator    locator=css:.cart_list .cart_item .inventory_item_name
    RETURN    ${product_list}

Get all product name (Checkout overview page)
    @{product_list}=    CommonPO.Get list of text from locator    locator=css:.cart_list .cart_item .inventory_item_name
    RETURN    ${product_list}

Get subtotal price in cart (Checkout overview page)
    ${text}=    Get Text    locator=css:.summary_info .summary_subtotal_label
    ${numeric}=    CommonPO.Convert text to numeric    text=${text}
    RETURN    ${numeric}

Get tax in cart (Checkout overview page)
    ${text}=    Get Text    locator=css:.summary_info .summary_tax_label
    ${numeric}=    CommonPO.Convert text to numeric    text=${text}
    RETURN    ${numeric}

