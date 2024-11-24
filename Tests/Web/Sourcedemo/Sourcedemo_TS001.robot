*** Settings ***
Library             SeleniumLibrary
Resource            ../../../Resources/PageObjects/SaucedemoPO.robot
Test Teardown       Close Browser


*** Variables ***
${BROWSER}      chrome    # Default browser


*** Test Cases ***
TC-001: Verify login with standard_user, add products to cart, and validate items in checkout process
    [Documentation]    desc
    @{select_list}=    Create List
    ...    Sauce Labs Bolt T-Shirt
    ...    Sauce Labs Onesie
    ...    Test.allTheThings() T-Shirt (Red)
    ${select_list_length}=    Get Length    item=@{select_list}
    # Open browser then navigate to Saucedemo then login with user: standard_user
    SaucedemoPO.Setup login with standard_user    browser=${BROWSER}
    # Add products in cart
    SaucedemoPO.Add Multiple Products To Cart    product_name_list=@{select_list}
    # Verify number of item in cart match number of select product list
    Scroll Element Into View    locator=css:#shopping_cart_container
    Element Text Should Be    locator=css:#shopping_cart_container .shopping_cart_badge    expected=${select_list_length}
    # Click cart icon to open cart page
    SaucedemoPO.Click to open cart page
    ${items_in_cart}=    SaucedemoPO.Get all product name (Cart page)
    # Log for debug
    Log    ${select_list}
    Log    ${items_in_cart}
    Lists Should Be Equal    list1=${select_list}    list2=${items_in_cart}    ignore_order=${True}
    SaucedemoPO.Click checkout button (Cart page)
    SaucedemoPO.Input checkout information form    firstname=Jack    lastname=Smith    zipcode=10000
    SaucedemoPO.Click continue button (Checkout information page)
    ${items_in_cart_overview}=    SaucedemoPO.Get all product name (Checkout overview page)
    # Log for debug
    Log    ${select_list}
    Log    ${items_in_cart_overview}
    Lists Should Be Equal    list1=${select_list}    list2=${items_in_cart_overview}    ignore_order=${True}
    ${subtotal_price}=    SaucedemoPO.Get subtotal price in cart (Checkout overview page)
    ${total_tax}=    SaucedemoPO.Get tax in cart (Checkout overview page)
    ${total_price}=    Evaluate    ${subtotal_price} + ${total_tax}
    Should Be Equal    first=${subtotal_price}    second=${39.97}
    Should Be Equal    first=${total_tax}    second=${3.20}
    Should Be Equal    first=${total_price}    second=${43.17}
    SaucedemoPO.Click finish button (Checkout overview page)
    SaucedemoPO.Click back home button
    Sleep    3s
