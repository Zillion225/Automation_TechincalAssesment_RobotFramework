*** Settings ***
# Importing libraries for web automation, API testing, and JSON handling
Library     SeleniumLibrary    # Keywords for browser-based automation
Library     RequestsLibrary    # Keywords for RESTful API interaction
Library     JSONLibrary    # Keywords for JSON manipulation and parsing
# Loading reusable resources and common keywords for the project
Resource    ./CommonPO.robot    # Contains shared keywords and utility functions


*** Keywords ***
API GET products
    [Documentation]    Sends a GET request to fetch all products from the API and verifies a successful response.
    # Make a GET request to the /products endpoint
    ${response}=    GET    url=${API_TEST_URL}/products
    # Verify that the API response status is successful
    CommonPO.Verify Response Status is Success    ${response}
    # Parse the response body text into JSON format
    ${response_json}=    Convert String To Json    ${response.text}
    # Return the parsed JSON response for further processing
    RETURN    ${response_json}

API GET products with sorting
    [Documentation]    Sends a GET request to fetch products with sorting parameters and verifies a successful response.
    [Arguments]    ${sorting}    # Sorting parameter to customize the API request
    # Make a GET request to the /products endpoint with the specified sorting parameter
    ${response}=    GET    url=${API_TEST_URL}/products?sort=${sorting}
    # Verify that the API response status is successful
    CommonPO.Verify Response Status is Success    ${response}
    # Parse the response body text into JSON format
    ${response_json}=    Convert String To Json    ${response.text}
    # Return the parsed JSON response for further processing
    RETURN    ${response_json}

API GET products/categories
    [Documentation]    Sends a GET request to fetch all product categories from the API and verifies a successful response.
    # Make a GET request to the /products/categories endpoint
    ${response}=    GET    url=${API_TEST_URL}/products/categories
    # Verify that the API response status is successful
    CommonPO.Verify Response Status is Success    ${response}
    # Parse the response body text into JSON format
    ${response_json}=    Convert String To Json    ${response.text}
    # Return the parsed JSON response for further processing
    RETURN    ${response_json}

API POST products
    [Documentation]    Sends a POST request to create a new product using the API and verifies a successful response.
    [Arguments]    ${jsonContent}    # JSON content payload for creating a new product
    # Make a POST request to the /products endpoint with the given JSON payload
    ${response}=    POST    url=${API_TEST_URL}/products    json=${jsonContent}
    # Verify that the API response status is successful
    CommonPO.Verify Response Status is Success    ${response}
    # Parse the response body text into JSON format
    ${response_json}=    Convert String To Json    ${response.text}
    # Return the parsed JSON response for further processing
    RETURN    ${response_json}

API PUT products
    [Documentation]    Sends a PUT request to update a product info using the API and verifies a successful response.
    [Arguments]    ${productId}    ${jsonContent}
    # Make a PUT request to the /products/${productId} endpoint with the given JSON payload
    ${response}=    PUT    url=${API_TEST_URL}/products/${productId}    json=${jsonContent}
    # Verify that the API response status is successful
    CommonPO.Verify Response Status is Success    ${response}
    # Parse the response body text into JSON format
    ${response_json}=    Convert String To Json    ${response.text}
    # Return the parsed JSON response for further processing
    RETURN    ${response_json}

API DELETE products
    [Documentation]    Sends a DELETE request to delete a product using the API and verifies a successful response.
    [Arguments]    ${productId}
    # Make a DELETE request to the /products/${productId} endpoint.
    ${response}=    DELETE    url=${API_TEST_URL}/products/${productId}
    # Verify that the API response status is successful
    CommonPO.Verify Response Status is Success    ${response}
    # Parse the response body text into JSON format
    ${response_json}=    Convert String To Json    ${response.text}
    # Return the parsed JSON response for further processing
    RETURN    ${response_json}
