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
${TC001_SELECT_LIST_JSON}       Resources/InputExpect/TC_001/Input_001.json
${TC001_EXPECT_JSON}            Resources/InputExpect/TC_001/Expect_001.json

*** Test Cases ***
TC-001: Verify login, add products, and validate checkout process
    [Tags]    Web    E2E    Regression    Smoke
    [Documentation]    Validate the workflow of login, adding items to cart, and verifying checkout.
    # Load the list of products to select from a JSON file
    Log    Loading select item list from JSON file
    @{select_list}=    Load Json From File    file_name=${TC001_SELECT_LIST_JSON}    encoding=utf8
    &{expect_object}=    Load Json From File    file_name=${TC001_EXPECT_JSON}    encoding=utf8
    
    # Step 1: Open browser and login
    TC-001 Step 1: Open Browser and Login to Saucedemo

    # Step 2: Inventory Page - Add products to cart and validate
    TC-001 Step 2: Add Products to Cart and Validate    select_list=@{select_list}

    # Step 3: Cart Page - Validate cart contents
    TC-001 Step 3: Validate Cart Contents and Proceed    expect_object=&{expect_object}

    # Step 4: Checkout Page - Input details and proceed
    TC-001 Step 4: Input Checkout Details

    # Step 5: Overview Page - Validate items and prices
    TC-001 Step 5: Validate Overview Page and Prices    expect_object=&{expect_object}

    # Step 6: Complete Order - Return to inventory page
    TC-001 Step 6: Complete Order and Return to Inventory Page

*** Keywords ***
TC-001 Step 1: Open Browser and Login to Saucedemo
    # Open the browser and navigate to the Saucedemo URL
    Saucedemo_CommonPO.Open browser then navigate to test url    browser=${BROWSER}
    # Log in using standard_user credentials
    Saucedemo_LoginPO.Login with standard_user

TC-001 Step 2: Add Products to Cart and Validate
    [Arguments]    ${select_list}
    # Verify the inventory page is displayed
    Saucedemo_InventoryPO.Verify current page is inventory page
    
    # Add the products to the cart
    Saucedemo_InventoryPO.Add multiple products to cart    product_name_list=@{select_list}
    
    # Verify the total number of items in the cart matches the selection
    ${select_list_length}=    Get Length    item=@{select_list}
    Saucedemo_InventoryPO.Total item in cart should be    number=${select_list_length}
    
    # Navigate to the cart page
    Saucedemo_InventoryPO.Click to open cart page

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