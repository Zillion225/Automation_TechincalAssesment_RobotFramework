*** Settings ***
Documentation    
...    This Robot Framework test script is designed to automate the end-to-end workflow of the Saucedemo application. 
...    It verifies login functionality, adding items to the cart, validating items during the checkout process, 
...    and checking the final order summary.
# Import necessary libraries and resource files
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
# Define default configurations and paths
${BROWSER}                      chrome    # Browser to use for testing

# Paths to JSON files for input data and expected results
${TC003_EXPECT_JSON}            Resources/InputExpect/TC_003/Expect_001.json

*** Test Cases ***
TC-001: Verify login, add products, and validate checkout process
    [Tags]    Web    E2E    Regression    Smoke
    [Documentation]    Validate the workflow of login, adding items to cart, and verifying checkout.

    &{expect_object}=    Load Json From File    file_name=${TC003_EXPECT_JSON}    encoding=utf8
    TC-001 Step 1: Open Browser and Login to Saucedemo
    ${select_list}=    TC-001 Step 2: Add Products to Cart and Validate
    TC-001 Step 3: Validate Cart Contents and Proceed    expect_object=&{expect_object}

*** Keywords ***
TC-001 Step 1: Open Browser and Login to Saucedemo
    # Open the browser and navigate to the Saucedemo URL
    Saucedemo_CommonPO.Open browser then navigate to test url    browser=${BROWSER}
    ${user}=    Get UserID From saucedemo    index=1
    Log    ${user}
    ${pwd}=    Get Password From saucedemo
    Log    ${pwd}
    Saucedemo_LoginPO.Input Username and Password    username=${user}    password=${pwd}
    Saucedemo_LoginPO.Click login button

Get UserID From saucedemo
    [Arguments]    ${index}
        ${text}=    Get Text    locator=id:login_credentials
    @{user}=    Split String    string=${text}    separator=\n
    ${select_user}=    Get From List    list_=${user}    index=${index}
    RETURN    ${select_user}

Get Password From saucedemo
    ${text}=    Get Text    locator=css:.login_password
    @{pwd_list}=    Split String    string=${text}    separator=\n
    ${pwd}=    Get From List    list_=${pwd_list}    index=1
    RETURN    ${pwd}


TC-001 Step 2: Add Products to Cart and Validate
    # Verify the inventory page is displayed
    Saucedemo_InventoryPO.Verify current page is inventory page

    # Find List of Price
    ${min_price_index}=    Saucedemo_InventoryPO.Find min price item index
    Log    ${min_price_index}
    ${actual_xpath_index}=    Evaluate  ${min_price_index} + 1  

    # Find Name of min price index
    ${item_name}=    Get Text    locator=xpath:(//div[@class="inventory_item_name "])[${actual_xpath_index}]
    Log    ${item_name}

    ${select_list}=    Create List    ${item_name}
    
    # Add the products to the cart
    Saucedemo_InventoryPO.Add multiple products to cart    product_name_list=@{select_list}
    
    # Verify the total number of items in the cart matches the selection
    ${select_list_length}=    Get Length    item=@{select_list}
    Saucedemo_InventoryPO.Total item in cart should be    number=${select_list_length}
    
    # Navigate to the cart page
    Saucedemo_InventoryPO.Click to open cart page

    RETURN    ${select_list}

TC-001 Step 3: Validate Cart Contents and Proceed
    [Arguments]    ${expect_object}
    # Verify the cart page is displayed
    Saucedemo_CartPO.Verify current page is inventory page
    
    # Get the list of products displayed in the cart and compare with selected items
    @{display_product_list}=    Saucedemo_CartPO.Get all product name in page
    Lists Should Be Equal
    ...    list1=${expect_object["expect_products"]}
    ...    list2=${display_product_list}
    ...    ignore_order=${True}
    ...    msg=Selected items must match items in cart

    @{display_product_description_list}=    Saucedemo_CartPO.Get all product description in page
    Lists Should Be Equal
    ...    list1=${expect_object["expect_descriptions"]}
    ...    list2=${display_product_description_list}
    ...    ignore_order=${True}
    ...    msg=Selected items description must match items in cart

    @{display_product_price_text_list}=    Saucedemo_CartPO.Get all product price text in page
    Lists Should Be Equal
    ...    list1=${expect_object["expect_price_in_cart"]}
    ...    list2=${display_product_price_text_list}
    ...    ignore_order=${True}
    ...    msg=Selected items price must match items in cart
    
    # Proceed to the checkout page
    Saucedemo_CartPO.Next step

TC-001 Step 4: Input Checkout Details
    # Verify the checkout page is displayed
    Saucedemo_CheckoutPO.Verify current page is inventory page
    
    # Input checkout information
    Saucedemo_CheckoutPO.Input checkout information form
    ...    firstname=Jack
    ...    lastname=Doe
    ...    zipcode=10000
    
    # Proceed to the overview page
    Saucedemo_CheckoutPO.Next step

TC-001 Step 5: Validate Overview Page and Prices
    [Arguments]    ${expect_object}
    # Verify the overview page is displayed
    Saucedemo_OverviewPO.Verify current page is inventory page
    
    # Validate product list on the overview page
    @{display_product_list}=    Saucedemo_OverviewPO.Get all product name in page
    Lists Should Be Equal
    ...    list1=${expect_object["expect_products"]}
    ...    list2=${display_product_list}
    ...    ignore_order=${True}
    ...    msg=Selected items must match items on overview page

    @{display_product_description_list}=    Saucedemo_OverviewPO.Get all product description in page
    Lists Should Be Equal
    ...    list1=${expect_object["expect_descriptions"]}
    ...    list2=${display_product_description_list}
    ...    ignore_order=${True}
    ...    msg=Selected items description must match items in cart

    @{display_product_price_text_list}=    Saucedemo_OverviewPO.Get all product price text in page
    Lists Should Be Equal
    ...    list1=${expect_object["expect_price_in_cart"]}
    ...    list2=${display_product_price_text_list}
    ...    ignore_order=${True}
    ...    msg=Selected items price must match items in cart
    
    # Validate pricing details
    ${sub_total_price}=    Saucedemo_OverviewPO.Get subtotal price in cart
    ${tax_price}=    Saucedemo_OverviewPO.Get tax in cart
    ${total_price}=    Evaluate    ${sub_total_price} + ${tax_price}
    
    Should Be True    condition=${expect_object["sub_total_price"]} == ${sub_total_price}
    Should Be True    condition=${expect_object["tax_price"]} == ${tax_price}
    Should Be True    condition=${expect_object["total_price"]} == ${total_price}
    
    # Proceed to complete the order
    Saucedemo_OverviewPO.Next step

TC-001 Step 6: Complete Order and Return to Inventory Page
    # Verify the complete page is displayed
    Saucedemo_Complete.Verify current page is inventory page
    
    # Return to the inventory page
    Saucedemo_Complete.Back to home
    
    # Verify the inventory page is displayed
    Saucedemo_InventoryPO.Verify current page is inventory page