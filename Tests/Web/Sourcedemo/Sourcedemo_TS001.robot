*** Settings ***
Library             SeleniumLibrary
Library             JSONLibrary
Resource            ../../../Resources/PageObjects/CommonPO.robot
Resource            ../../../Resources/PageObjects/Saucedemo/Saucedemo_CommonPO.robot
Resource            ../../../Resources/PageObjects/Saucedemo/Saucedemo_LoginPO.robot
Resource            ../../../Resources/PageObjects/Saucedemo/Saucedemo_InventoryPO.robot
Resource            ../../../Resources/PageObjects/Saucedemo/Saucedemo_CartPO.robot
Resource            ../../../Resources/PageObjects/Saucedemo/Saucedemo_CheckoutPO.robot
Resource            ../../../Resources/PageObjects/Saucedemo/Saucedemo_OverviewPO.robot
Resource            ../../../Resources/PageObjects/Saucedemo/Saucedemo_Complete.robot

Test Teardown       Close Browser


*** Variables ***
${BROWSER}                      chrome    # Default browser

${TC001_SELECT_LIST_JSON}       Resources/InputExpect/TC_001/Input_001.json
${TC001_EXPECT_JSON}            Resources/InputExpect/TC_001/Expect_001.json


*** Test Cases ***
TC-001: Verify login with standard_user, add products to cart, and validate items in checkout process
    [Documentation]    desc
    # Open browser then navigate to Saucedemo then login with user: standard_user
    Saucedemo_CommonPO.Open browser then navigate to test url    browser=${BROWSER}
    Saucedemo_LoginPO.Login with standard_user
    # === Inventory page ===
    # Check is page display inventory page correctly
    Saucedemo_InventoryPO.Verify current page is inventory page
    Log    Load select item list
    @{select_list}=    Load Json From File    file_name=${TC001_SELECT_LIST_JSON}    encoding=utf8
    ${select_list_length}=    Get Length    item=@{select_list}
    Saucedemo_InventoryPO.Add multiple products to cart    product_name_list=@{select_list}
    # Check number of item in cart should be math select list length.
    Saucedemo_InventoryPO.Total item in cart should be    number=${select_list_length}
    # Click cart icon, navigate to cart page
    Saucedemo_InventoryPO.Click to open cart page
    # === Cart page ===
    # Check is page display cart page correctly
    Saucedemo_CartPO.Verify current page is inventory page
    # Confirm product in cart match select_item
    @{display_product_list}=    Saucedemo_CartPO.Get all product name in page
    Lists Should Be Equal
    ...    list1=${select_list}
    ...    list2=${display_product_list}
    ...    ignore_order=${True}
    ...    msg=Item in select_list must match product that display in page
    Saucedemo_CartPO.Next step
    # === Checkout page ===
    Saucedemo_CheckoutPO.Verify current page is inventory page
    Saucedemo_CheckoutPO.Input checkout information form    
    ...    firstname=Jack    
    ...    lastname=Doe    
    ...    zipcode=10000
    Saucedemo_CheckoutPO.Next step
    # === Overview page ===
    Saucedemo_OverviewPO.Verify current page is inventory page
    @{display_product_list}=    Saucedemo_OverviewPO.Get all product name in page
    Lists Should Be Equal
    ...    list1=${select_list}
    ...    list2=${display_product_list}
    ...    ignore_order=${True}
    ...    msg=Item in select_list must match product that display in page
    ${sub_total_price}=    Saucedemo_OverviewPO.Get subtotal price in cart
    ${tax_price}=    Saucedemo_OverviewPO.Get tax in cart
    ${total_price}    Evaluate    ${sub_total_price} + ${tax_price}
    &{expect_json}=    Load Json From File    file_name=${TC001_EXPECT_JSON}    encoding=utf8
    Should Be True    condition=${expect_json["sub_total_price"]} == ${sub_total_price}
    Should Be True    condition=${expect_json["tax_price"]} == ${tax_price}
    Should Be True    condition=${expect_json["total_price"]} == ${total_price}
    Saucedemo_OverviewPO.Next step
    # === Complete page ===
    Saucedemo_Complete.Verify current page is inventory page
    Saucedemo_Complete.Back to home
    # === Inventory page ===
    # Check is page display inventory page correctly
    Saucedemo_InventoryPO.Verify current page is inventory page
