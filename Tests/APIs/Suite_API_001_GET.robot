*** Settings ***
# Description: Test suite for validating API responses from FakestoreAPI.
Documentation       Test suite for validating API responses from FakestoreAPI.

# Importing necessary libraries for file operations and JSON handling
Library             OperatingSystem        # Provides keywords to manage file system operations
Library             JSONLibrary            # Provides keywords to handle JSON data

# Loading resource files for common validation and Fakestore-specific API operations
Resource            ../../Resources/PageObjects/FakestorePO.robot    # Contains keywords for Fakestore API operations

*** Variables ***
# Define file paths for expected JSON results and input JSON data
${TCAPI001_EXPECTED_JSON_PATH}                Resources/InputExpect/TCAPI_001/Expect_001.json
${TCAPI002_EXPECTED_JSON_PATH_DESC}           Resources/InputExpect/TCAPI_002/Expect_001_DESC.json
${TCAPI002_EXPECTED_JSON_PATH_ASC}            Resources/InputExpect/TCAPI_002/Expect_002_ASC.json
${TCAPI002_EXPECTED_JSON_PATH_INCORRECT}      Resources/InputExpect/TCAPI_002/Expect_002_INCORRECT.json
${TCAPI002_EXPECTED_JSON_PATH_EMPTY}          Resources/InputExpect/TCAPI_002/Expect_002_Empty.json
${TCAPI003_EXPECTED_JSON_PATH}                Resources/InputExpect/TCAPI_003/Expect_001.json

*** Test Cases ***
TC-API001 Validate GET /products API
    [Documentation]    Validate the GET /products endpoint response from FakestoreAPI.
    [Tags]    API    API_GET
    ${response_json}=    FakestorePO.API GET products
    CommonPO.Validate Response Against Expected JSON File    ${response_json}    ${TCAPI001_EXPECTED_JSON_PATH}

TC-API002_A Validate GET /products API with Sorting DESC
    [Documentation]    Validate the GET /products endpoint with descending sorting.
    [Tags]    API    API_GET
    ${response_json}=    FakestorePO.API GET products with sorting    desc
    CommonPO.Validate Response Against Expected JSON File    ${response_json}    ${TCAPI002_EXPECTED_JSON_PATH_DESC}

TC-API002_B Validate GET /products API with Sorting ASC
    [Documentation]    Validate the GET /products endpoint with ascending sorting.
    [Tags]    API    API_GET
    ${response_json}=    FakestorePO.API GET products with sorting    asc
    CommonPO.Validate Response Against Expected JSON File    ${response_json}    ${TCAPI002_EXPECTED_JSON_PATH_ASC}

TC-API002_C Validate GET /products API with Incorrect Sorting Keys
    [Documentation]    Validate the GET /products endpoint with invalid sorting keys.
    [Tags]    API    API_GET
    ${response_json}=    FakestorePO.API GET products with sorting    incorrect
    CommonPO.Validate Response Against Expected JSON File    ${response_json}    ${TCAPI002_EXPECTED_JSON_PATH_INCORRECT}

TC-API002_D Validate GET /products API with Empty Sorting Keys
    [Documentation]    Validate the GET /products endpoint with empty sorting keys.
    [Tags]    API    API_GET
    ${response_json}=    FakestorePO.API GET products with sorting    null
    CommonPO.Validate Response Against Expected JSON File    ${response_json}    ${TCAPI002_EXPECTED_JSON_PATH_EMPTY}

TC-API003 Validate GET /products/categories API
    [Documentation]    Validate the GET /products/categories endpoint from FakestoreAPI.
    [Tags]    API    API_GET
    ${response_json}=    FakestorePO.API GET products/categories
    CommonPO.Validate Response Against Expected JSON File    ${response_json}    ${TCAPI003_EXPECTED_JSON_PATH}
