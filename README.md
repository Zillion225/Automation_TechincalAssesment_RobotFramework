
# Automation Technical Assessment with Robot Framework

This project serves as a technical assessment for automation testing using the [Robot Framework](https://robotframework.org/), a generic open-source automation framework for acceptance testing and robotic process automation (RPA).

## Project Structure

The repository is organized as follows:

- **Resources/**: Contains resource files with reusable keywords and variables.
- **Tests/**: Includes test case files written in Robot Framework syntax.
- **.gitignore**: Specifies files and directories to be ignored by Git.
- **requirements.txt**: Lists the Python dependencies required for the project.
- **run.bat**: A batch script to execute the test cases.
- **run_parallel.bat**: A batch script to execute test cases in parallel.

## Prerequisites

Ensure the following are installed on your system:

- [Python 3.8 or newer](https://www.python.org/downloads/)
- [pip](https://pip.pypa.io/en/stable/installation/)
- [Robot Framework](https://robotframework.org/)
- [Robot Framework SeleniumLibrary](https://github.com/robotframework/SeleniumLibrary)

## Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/Zillion225/Automation_TechincalAssesment_RobotFramework.git
   ```

2. **Navigate to the project directory**:

   ```bash
   cd Automation_TechincalAssesment_RobotFramework
   ```

3. **Install the required dependencies**:

   ```bash
   pip install -r requirements.txt
   ```

## Running Tests

- **To execute all test cases**:

   ```bash
   robot Tests/
   ```

- **To execute tests in parallel**:

   ```bash
   pabot --processes 4 Tests/
   ```

   *Note*: Ensure [pabot](https://github.com/mkorpela/pabot) is installed for parallel execution.

## Reporting

After execution, reports and logs are generated in the `output` directory. Open `report.html` in a web browser to view the test results.

## Contributing

Contributions are welcome. Please fork the repository and submit a pull request for any enhancements or bug fixes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
