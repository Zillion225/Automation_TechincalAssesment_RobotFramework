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
${TCAPI006_EXPECTED_JSON_PATH}      Resources/InputExpect/TCAPI_006/Expect_001.json
${TCAPI007_EXPECTED_JSON_PATH}      Resources/InputExpect/TCAPI_007/Expect_001.json
${TCAPI008_EXPECTED_JSON_PATH}      Resources/InputExpect/TCAPI_008/Expect_001.json
${TCAPI009A_EXPECTED_JSON_PATH}     Resources/InputExpect/TCAPI_009/Expect_001.json
${TCAPI009B_EXPECTED_JSON_PATH}     Resources/InputExpect/TCAPI_009/Expect_002.json

${TCAPI006_INPUT_JSON_PATH}         Resources/InputExpect/TCAPI_006/Input_001.json
${TCAPI007_INPUT_JSON_PATH}         Resources/InputExpect/TCAPI_007/Input_001.json
${TCAPI008_INPUT_JSON_PATH}         Resources/InputExpect/TCAPI_008/Input_001.json
${TCAPI009_INPUT_JSON_PATH}         Resources/InputExpect/TCAPI_009/Input_001.json
${TCAPI012_INPUT_JSON_PATH}         Resources/InputExpect/TCAPI_012/Input_001.json


*** Test Cases ***
TC-API006 Validate PUT /products API
    [Documentation]    Validate PUT /products endpoint with a JSON payload.
    [Tags]    API    API_PUT
    ${input_json}=    Load Json From File    file_name=${TCAPI006_INPUT_JSON_PATH}    encoding=utf8
    ${response_json}=    FakestorePO.API PUT products    productId=3    jsonContent=${input_json}
    CommonPO.Validate Response Against Expected JSON File    ${response_json}    ${TCAPI006_EXPECTED_JSON_PATH}

TC-API007 Validate PUT /products API with rating data
    [Documentation]    Validate PUT /products endpoint with JSON payload including rating details.
    [Tags]    API    API_PUT
    ${input_json}=    Load Json From File    file_name=${TCAPI007_INPUT_JSON_PATH}    encoding=utf8
    ${response_json}=    FakestorePO.API PUT products    productId=4    jsonContent=${input_json}
    CommonPO.Validate Response Against Expected JSON File    ${response_json}    ${TCAPI007_EXPECTED_JSON_PATH}

TC-API008 Validate PUT /products API, send id in JSON content
    [Documentation]    Test the PUT /products endpoint by sending a JSON payload with an id value that differs from the URL endpoint.
    [Tags]    API    API_PUT
    ${input_json}=    Load Json From File    file_name=${TCAPI008_INPUT_JSON_PATH}    encoding=utf8
    ${response_json}=    FakestorePO.API PUT products    productId=3    jsonContent=${input_json}
    CommonPO.Validate Response Against Expected JSON File    ${response_json}    ${TCAPI008_EXPECTED_JSON_PATH}

TC-API009 Validate PUT /products API with invalid id (id=0, -1)
    [Documentation]    Test the PUT /products endpoint by sending a JSON payload with an invalid id (id = 0, -1).
    [Tags]    API    API_PUT
    # Check product id = 0
    ${input_json}=    Load Json From File    file_name=${TCAPI009_INPUT_JSON_PATH}    encoding=utf8
    ${response_json}=    FakestorePO.API PUT products    productId=0    jsonContent=${input_json}
    CommonPO.Validate Response Against Expected JSON File    ${response_json}    ${TCAPI009A_EXPECTED_JSON_PATH}
    # Check product id < 0
    ${input_json}=    Load Json From File    file_name=${TCAPI009_INPUT_JSON_PATH}    encoding=utf8
    ${response_json}=    FakestorePO.API PUT products    productId=-1    jsonContent=${input_json}
    CommonPO.Validate Response Against Expected JSON File    ${response_json}    ${TCAPI009B_EXPECTED_JSON_PATH}
