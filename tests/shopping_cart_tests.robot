
*** Settings ***
Library    SeleniumLibrary
Test Teardown    Close All Browsers


*** Variables ***
${URL}    https://www.saucedemo.com/
${Username}    standard_user
${Password}    secret_sauce


*** Test Cases ***
Add And Remove Products From Cart
    Open Firefox Browser
    Sleep    2s

    # Login
    Input Text    id=user-name    ${Username}
    Input Text    id=password    ${Password}
    Click Button    id=login-button

    Wait Until Element Is Visible    css=.inventory_list    timeout=10s

    # Add two products to cart
    Click Button    id=add-to-cart-sauce-labs-backpack
    Click Button    id=add-to-cart-sauce-labs-bike-light

    Wait Until Element Is Visible    css=.shopping_cart_badge
    Element Text Should Be    css=.shopping_cart_badge    2

    # Open cart
    Click Element    css=.shopping_cart_link
    Wait Until Element Is Visible    css=.cart_item

    ${cart_count}=    Get Element Count    css=.cart_item
    Should Be Equal As Integers    ${cart_count}    2

    # Remove Backpack from cart
    Click Button    id=remove-sauce-labs-backpack

    Wait Until Element Is Not Visible    id=remove-sauce-labs-backpack

    # Verify remaining cart contents
    Element Text Should Be    css=.shopping_cart_badge    1
    Page Should Not Contain    Sauce Labs Backpack
    Page Should Contain    Sauce Labs Bike Light

    ${cart_count}=    Get Element Count    css=.cart_item
    Should Be Equal As Integers    ${cart_count}    1

    Capture Page Screenshot


*** Keywords ***
Open Firefox Browser
    ${service}=    Evaluate    sys.modules['selenium.webdriver'].FirefoxService(log_output=r'${EXECDIR}${/}logs${/}geckodriver.log')    sys, selenium.webdriver
    Open Browser    ${URL}    firefox    service=${service}
    Maximize Browser Window