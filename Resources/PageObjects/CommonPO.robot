*** Settings ***
# Importing necessary libraries for file operations and JSON handling
Library             OperatingSystem        # Handles file-related operations
Library             JSONLibrary            # Enables JSON data manipulation

*** Variables ***
${BASE_URL}         https://www.saucedemo.com    # Base URL for the main application
${API_TEST_URL}     https://fakestoreapi.com     # Base URL for testing API endpoints

*** Keywords ***
Verify Response Status is Success
    [Arguments]    ${response}
    # Assert that the response status code is 200 (Success)
    Should Be Equal As Strings    ${response.status_code}    200

Validate Response Against Expected JSON File
    [Arguments]    ${response_json}    ${expected_json_file_path}    ${encoding}=utf8
    # Load the expected JSON data from the provided file path
    ${expected_json}=    Load Json From File    ${expected_json_file_path}    encoding=${encoding}
    # Log the expected JSON and the actual response JSON for debugging
    Log    Expected JSON: ${expected_json}
    Log    Response JSON: ${response_json}
    # Compare the actual response JSON with the expected JSON
    Should Be Equal    ${response_json}    ${expected_json}    msg=API response does not match the expected result.
