
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
End To End Test
    Open Firefox Browser
    Sleep    2s

    # Login
    Input Text    id=user-name    ${Username}
    Input Text    id=password    ${Password}
    Click Button    id=login-button
    Wait Until Element Is Visible    css=.inventory_list    timeout=10s
    Page Should Contain Element    css=.inventory_item

    # Add first product
    Click Button    id=add-to-cart-sauce-labs-backpack
    Element Text Should Be    css=.shopping_cart_badge    1

    # Sort products by price high to low
    Select From List By Value    css=.product_sort_container    hilo
    Page Should Contain    Sauce Labs Fleece Jacket

    # Add second product
    Click Button    id=add-to-cart-sauce-labs-fleece-jacket
    Element Text Should Be    css=.shopping_cart_badge    2

    # Sort products by name Z to A
    Select From List By Value    css=.product_sort_container    za
    Page Should Contain    Sauce Labs Onesie

    # Add third product
    Click Button    id=add-to-cart-sauce-labs-onesie
    Element Text Should Be    css=.shopping_cart_badge    3

    # Open cart and verify products
    Click Element    css=.shopping_cart_link
    Wait Until Element Is Visible    css=.cart_item
    Page Should Contain    Sauce Labs Backpack
    Page Should Contain    Sauce Labs Fleece Jacket
    Page Should Contain    Sauce Labs Onesie

    ${cart_count}=    Get Element Count    css=.cart_item
    Should Be Equal As Integers    ${cart_count}    3

    # Remove Onesie
    Click Button    id=remove-sauce-labs-onesie
    Wait Until Element Is Not Visible    id=remove-sauce-labs-onesie
    Element Text Should Be    css=.shopping_cart_badge    2

    # Continue shopping
    Click Button    id=continue-shopping
    Wait Until Element Is Visible    css=.inventory_list

    # Sort products by price high to low
    Select From List By Value    css=.product_sort_container    hilo
    Page Should Contain    Sauce Labs Fleece Jacket

    # Add fourth product
    Click Button    id=add-to-cart-sauce-labs-bike-light
    Element Text Should Be    css=.shopping_cart_badge    3

    # Open cart and verify final products
    Click Element    css=.shopping_cart_link
    Wait Until Element Is Visible    css=.cart_item
    Page Should Contain    Sauce Labs Backpack
    Page Should Contain    Sauce Labs Fleece Jacket
    Page Should Contain    Sauce Labs Bike Light

    ${cart_count}=    Get Element Count    css=.cart_item
    Should Be Equal As Integers    ${cart_count}    3

    # Begin checkout
    Click Button    id=checkout
    Wait Until Element Is Visible    id=first-name

    # Enter customer details
    Input Text    id=first-name    ${FName}
    Input Text    id=last-name    ${LName}
    Input Text    id=postal-code    ${PostalCode}
    Click Button    id=continue

    # Verify checkout overview
    Wait Until Element Is Visible    id=finish    timeout=10s
    Page Should Contain    Payment Information
    Page Should Contain    Shipping Information

    # Verify order products
    Page Should Contain    Sauce Labs Backpack
    Page Should Contain    Sauce Labs Fleece Jacket
    Page Should Contain    Sauce Labs Bike Light

    # Verify order totals
    Element Text Should Be    css=.summary_subtotal_label    Item total: $89.97
    Element Text Should Be    css=.summary_tax_label    Tax: $7.20
    Element Text Should Be    css=.summary_total_label    Total: $97.17

    Capture Page Screenshot    ${EXECDIR}${/}results${/}screenshots${/}checkout_overview.png

    # Complete purchase
    Click Button    id=finish
    Wait Until Element Is Visible    css=.complete-header    timeout=10s
    Element Text Should Be    css=.complete-header    Thank you for your order!
    Page Should Contain    Your order has been dispatched

    Capture Page Screenshot    ${EXECDIR}${/}results${/}screenshots${/}order_confirmation.png

    # Return to inventory
    Click Button    id=back-to-products
    Wait Until Element Is Visible    css=.inventory_list


*** Keywords ***
Open Firefox Browser
    ${service}=    Evaluate    sys.modules['selenium.webdriver'].FirefoxService(log_output=r'${EXECDIR}${/}logs${/}geckodriver.log')    sys, selenium.webdriver
    Open Browser    ${URL}    firefox    service=${service}
    Maximize Browser Window
