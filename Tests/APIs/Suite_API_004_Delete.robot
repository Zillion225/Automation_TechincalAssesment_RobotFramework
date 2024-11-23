*** Settings ***
# Description of the test suite
Documentation       Test suite for validating API responses from fakestoreapi

# Importing libraries for file operations and JSON handling
Library             OperatingSystem    # Provides keywords for file-related operations
Library             JSONLibrary    # Enables handling JSON files and data
# Loading the Page Object file containing API-related keywords
Resource            ../../Resources/PageObjects/FakestorePO.robot


*** Variables ***
# Define file paths for expected JSON results and input JSON data
${TCAPI010_EXPECTED_JSON_PATH}      Resources/InputExpect/TCAPI_010/Expect_001.json


*** Test Cases ***
TC-API010 Validate Delete /products API
    [Documentation]    Validate the Delete /products endpoint response from FakestoreAPI.
    [Tags]    API    API_DELETE
    ${response_json}=    FakestorePO.API DELETE products    productId=20
    CommonPO.Validate Response Against Expected JSON File    ${response_json}    ${TCAPI010_EXPECTED_JSON_PATH}

TC-API011 Validate Delete /products API with invalid id (id=0, -1)
    [Documentation]    Validate the Delete /products with id=0 endpoint response from FakestoreAPI.
    [Tags]    API    API_DELETE
    # Check product id = 0
    ${response_json}=    FakestorePO.API DELETE products    productId=0
    Should Be True    condition=${response_json} == None
    # Check product id < 0
    ${response_json}=    FakestorePO.API DELETE products    productId=-1
    Should Be True    condition=${response_json} == None


