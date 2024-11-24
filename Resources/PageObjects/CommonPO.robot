*** Settings ***
# Importing necessary libraries for file operations and JSON handling
Library     SeleniumLibrary
Library     Collections
Library     OperatingSystem    # Handles file-related operations
Library     JSONLibrary    # Enables JSON data manipulation
Library     String    # For string manipulation


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

Get list of text from locator
    [Arguments]    ${locator}
    ${elements}=    Get WebElements    locator=${locator}
    @{item_list}=    Create List
    FOR  ${item}  IN  @{elements}
        ${text}=    Get Text    locator=${item}
        Append To List    ${item_list}    ${text}
    END
    RETURN    ${item_list}

Convert text to numeric
    [Documentation]
    ...    Removes all non-numeric characters from a text string and converts the result into a number.
    ...    Useful for extracting numeric values from strings containing text and numbers.
    [Arguments]
    ...    ${text}    # Input text string containing numbers
    # Remove all non-digit characters (except '.') using regex
    ${cleaned_number_text}=    Replace String Using Regexp    string=${text}    pattern=[^0-9.]    replace_with=
    # Convert the cleaned text to a numeric value with two decimal precision
    ${result}=    Convert To Number    item=${cleaned_number_text}    precision=2
    RETURN    ${result} 
