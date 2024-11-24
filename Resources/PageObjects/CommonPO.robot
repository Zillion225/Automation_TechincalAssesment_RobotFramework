*** Settings ***
# Importing necessary libraries for automation, file handling, and data manipulation
Library     SeleniumLibrary         # For web browser automation
Library     Collections             # Provides support for working with lists and dictionaries
Library     OperatingSystem         # Enables file-related operations
Library     JSONLibrary             # Handles JSON file loading and manipulation
Library     String                  # Offers string manipulation functions


*** Keywords ***
Verify Response Status is Success
    [Documentation]
    ...    Validates that the API response status code is 200.
    ...    This keyword is used to ensure the API request was successful.
    [Arguments]    ${response}
    
    # Validate that the API response status code is 200 (indicating success)
    Should Be Equal As Strings    ${response.status_code}    200


Validate Response Against Expected JSON File
    [Documentation]
    ...    Compares the actual API response JSON with the expected JSON data from a file.
    ...    Logs the expected and actual JSON for debugging purposes if a mismatch occurs.
    [Arguments]    
    ...    ${response_json}              # The actual JSON response from the API.
    ...    ${expected_json_file_path}    # Path to the file containing the expected JSON data.
    ...    ${encoding}=utf8              # Encoding used to read the JSON file.

    # Load expected JSON data from the file at the specified path with the given encoding
    ${expected_json}=    Load Json From File    ${expected_json_file_path}    encoding=${encoding}
    # Log the expected and actual JSON data for debugging purposes
    Log    Expected JSON: ${expected_json}
    Log    Response JSON: ${response_json}
    # Compare the actual JSON response with the expected JSON data
    Should Be Equal    ${response_json}    ${expected_json}    msg=API response does not match the expected result.


Get list of text from locator
    [Documentation]
    ...    Retrieves text from all web elements matching a specified locator.
    ...    Returns a list containing the text of each element.
    [Arguments]
    ...    ${locator}    # Locator used to identify web elements on the page.

    # Retrieve all web elements matching the provided locator
    ${elements}=    Get WebElements    locator=${locator}
    # Initialize an empty list to store text from the elements
    @{item_list}=    Create List
    # Loop through each web element, extract its text, and add it to the list
    FOR  ${item}  IN  @{elements}
        ${text}=    Get Text    locator=${item}
        Append To List    ${item_list}    ${text}
    END
    # Return the final list of text extracted from the web elements
    RETURN    ${item_list}


Convert text to numeric
    [Documentation]
    ...    Extracts numeric values from a text string by removing non-numeric characters (except '.').
    ...    Converts the resulting string into a number with a specified precision (default: 2 decimal places).
    [Arguments]
    ...    ${text}    # Input text containing both numeric and non-numeric characters.

    # Use regex to remove all non-digit characters except the decimal point
    ${cleaned_number_text}=    Replace String Using Regexp    string=${text}    pattern=[^0-9.]    replace_with=
    # Convert the cleaned string into a numeric value, preserving two decimal places
    ${result}=    Convert To Number    item=${cleaned_number_text}    precision=2
    # Return the converted numeric value
    RETURN    ${result}
