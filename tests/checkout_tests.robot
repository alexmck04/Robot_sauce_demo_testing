
*** Settings ***
Library    SeleniumLibrary
Test Teardown    Close All Browsers


*** Variables ***
${URL}    https://www.saucedemo.com/
${Username}    standard_user
${Password}    secret_sauce
${FName}    Alex
${LName}    McKeever
${PostalCode}    50100


*** Test Cases ***

Successful Checkout Test
    Open Firefox Browser
    Sleep    2s

    # Login
    Input Text    id=user-name    ${Username}
    Input Text    id=password    ${Password}
    Click Button    id=login-button
    Sleep    2s

    Wait Until Element Is Visible    css=.inventory_list    timeout=10s
    Page Should Contain Element    css=.inventory_item

    # Add product to cart
    Click Button    id=add-to-cart-sauce-labs-backpack
    Element Text Should Be    css=.shopping_cart_badge    1

    # Open cart
    Click Element    css=.shopping_cart_link
    Wait Until Element Is Visible    css=.cart_item

    ${cart_count}=    Get Element Count    css=.cart_item
    Should Be Equal As Integers    ${cart_count}    1

    # Begin checkout
    Click Button    id=checkout
    Wait Until Element Is Visible    id=first-name

    # Enter customer details
    Input Text    id=first-name    ${FName}
    Input Text    id=last-name    ${LName}
    Input Text    id=postal-code    ${PostalCode}

    Click Button    id=continue

    # Verify checkout overview
    Wait Until Element Is Visible    id=finish
    Page Should Contain    Payment Information
    Page Should Contain    Shipping Information
    Capture Page Screenshot    ${EXECDIR}${/}results${/}screenshots${/}checkout_overview.png

    # Complete purchase
    Click Button    id=finish

    # Verify order confirmation
    Wait Until Element Is Visible    css=.complete-header
    Element Text Should Be    css=.complete-header    Thank you for your order!

    Capture Page Screenshot    ${EXECDIR}${/}results${/}screenshots${/}order_confirmation.png


Checkout With Missing First Name
    Open Firefox Browser
    Sleep    2s

    # Login
    Input Text    id=user-name    ${Username}
    Input Text    id=password    ${Password}
    Click Button    id=login-button

    Wait Until Element Is Visible    css=.inventory_list    timeout=10s

    # Add product to cart
    Click Button    id=add-to-cart-sauce-labs-backpack

    # Open cart and begin checkout
    Click Element    css=.shopping_cart_link
    Wait Until Element Is Visible    css=.cart_item
    Click Button    id=checkout
    Wait Until Element Is Visible    id=first-name

    # Enter customer details, leaving first name empty
    Input Text    id=last-name    ${LName}
    Input Text    id=postal-code    ${PostalCode}

    Click Button    id=continue

    # Verify checkout error
    Wait Until Element Is Visible    css=[data-test="error"]    timeout=10s
    Element Text Should Be    css=[data-test="error"]    Error: First Name is required

    Capture Page Screenshot    ${EXECDIR}${/}results${/}screenshots${/}checkout_missing_first_name.png


Checkout With Missing Last Name
    Checkout With Missing Information
    ...    last-name
    ...    Error: Last Name is required


Checkout With Missing Postal Code
    Checkout With Missing Information
    ...    postal-code
    ...    Error: Postal Code is required


*** Keywords ***

Open Firefox Browser
    ${service}=    Evaluate    sys.modules['selenium.webdriver'].FirefoxService(log_output=r'${EXECDIR}${/}logs${/}geckodriver.log')    sys, selenium.webdriver
    Open Browser    ${URL}    firefox    service=${service}
    Maximize Browser Window


Checkout With Missing Information
    [Arguments]    ${field_to_leave_empty}    ${expected_error}

    Open Firefox Browser

    # Login
    Input Text    id=user-name    ${Username}
    Input Text    id=password    ${Password}
    Click Button    id=login-button
    Wait Until Element Is Visible    css=.inventory_list    timeout=10s

    # Add product and open checkout
    Click Button    id=add-to-cart-sauce-labs-backpack
    Click Element    css=.shopping_cart_link
    Wait Until Element Is Visible    css=.cart_item
    Click Button    id=checkout
    Wait Until Element Is Visible    id=first-name

    # Enter all customer details except the specified field
    IF    '${field_to_leave_empty}' != 'first-name'
        Input Text    id=first-name    ${FName}
    END

    IF    '${field_to_leave_empty}' != 'last-name'
        Input Text    id=last-name    ${LName}
    END

    IF    '${field_to_leave_empty}' != 'postal-code'
        Input Text    id=postal-code    ${PostalCode}
    END

    # Verify expected validation error
    Click Button    id=continue
    Wait Until Element Is Visible    css=[data-test="error"]    timeout=10s
    Element Text Should Be    css=[data-test="error"]    ${expected_error}
