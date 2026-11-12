# Sauce Demo - Test Automation

## Project Overview

This project is an automated web testing suite for Sauce Demo, an online shopping application used for software testing practice.

The project was developed using Python, Robot Framework and SeleniumLibrary to automate common e-commerce user journeys, including login, product sorting, shopping cart operations and checkout.

The aim of the project is to demonstrate practical knowledge of test automation, functional testing, test case design and validation of expected application behaviour.

## Technologies Used

- Python - Programming language
- Robot Framework - Test automation framework
- SeleniumLibrary - Browser automation library
- Selenium WebDriver - Browser interaction
- Firefox - Browser used for automated testing
- Visual Studio Code - Development environment

## Test Coverage

The project contains five test suites covering different areas of the Sauce Demo application.

### 1. Login Tests

- Successful login.
- Login attempt using a locked-out account.
- Login attempt using an incorrect password.
- Verification of login error messages.

### 2. Shopping Cart Tests

- Adding multiple products to the shopping cart.
- Verifying cart contents and item count.
- Removing products from the cart.
- Verifying cart updates after removal.

### 3. Checkout Tests

- Successful checkout process.
- Checkout with a missing first name.
- Checkout with a missing last name.
- Checkout with a missing postal code.
- Verification of checkout validation messages.

### 4. Product Sorting Tests

- Sorting products by name (A to Z).
- Sorting products by name (Z to A).
- Sorting products by price (low to high).
- Sorting products by price (high to low).
- Verification of the resulting product order.

### 5. End-to-End Test

A complete shopping journey combining multiple application features:

- Logging into the application.
- Adding products to the cart.
- Sorting products using different options.
- Verifying cart contents and removing products.
- Continuing shopping and adding another product.
- Entering customer details during checkout.
- Verifying order information, subtotal, tax and total.
- Completing the purchase and verifying the confirmation message.

## Running Tests and Test Reports

All test suites can be executed from the project root using:

- robot --outputdir results/reports tests/

The --outputdir option directs Robot Framework's generated HTML reports and execution logs to the results/reports/ folder, keeping the main project directory organised.

After execution, the following reports are generated:

- results/reports/report.html
- results/reports/log.html

The reports can be opened in a web browser to review test results, execution details and any failures.

Screenshots captured during selected tests are stored separately in results/screenshots/.

## Application Under Test

https://www.saucedemo.com/

The application is provided by Sauce Labs for demonstration and software testing purposes.
