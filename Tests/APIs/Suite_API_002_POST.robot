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
${TCAPI004_EXPECTED_JSON_PATH}      Resources/InputExpect/TCAPI_004/Expect_001.json
${TCAPI005_EXPECTED_JSON_PATH}      Resources/InputExpect/TCAPI_005/Expect_001.json

${TCAPI004_INPUT_JSON_PATH}         Resources/InputExpect/TCAPI_004/Input_001.json
${TCAPI005_INPUT_JSON_PATH}         Resources/InputExpect/TCAPI_005/Input_001.json


*** Test Cases ***
TC-API004 Validate POST /products API
    [Documentation]    Validate POST /products endpoint with a JSON payload.
    [Tags]    API    API_POST
    ${input_json}=    Load Json From File    file_name=${TCAPI004_INPUT_JSON_PATH}    encoding=utf8
    ${response_json}=    FakestorePO.API POST products    jsonContent=${input_json}
    CommonPO.Validate Response Against Expected JSON File    ${response_json}    ${TCAPI004_EXPECTED_JSON_PATH}

TC-API005 Validate POST /products API with rating data
    [Documentation]    Validate POST /products endpoint with JSON payload including rating details.
    [Tags]    API    API_POST
    ${input_json}=    Load Json From File    file_name=${TCAPI005_INPUT_JSON_PATH}    encoding=utf8
    ${response_json}=    FakestorePO.API POST products    jsonContent=${input_json}
    CommonPO.Validate Response Against Expected JSON File    ${response_json}    ${TCAPI005_EXPECTED_JSON_PATH}
