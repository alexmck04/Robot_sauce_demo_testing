
*** Settings ***
Library    SeleniumLibrary
Library    Collections
Test Setup    Open Sauce Demo And Login
Test Teardown    Close All Browsers


*** Variables ***
${URL}    https://www.saucedemo.com/
${Username}    standard_user
${Password}    secret_sauce

@{NAMES_A_TO_Z}
...    Sauce Labs Backpack
...    Sauce Labs Bike Light
...    Sauce Labs Bolt T-Shirt
...    Sauce Labs Fleece Jacket
...    Sauce Labs Onesie
...    Test.allTheThings() T-Shirt (Red)

@{NAMES_Z_TO_A}
...    Test.allTheThings() T-Shirt (Red)
...    Sauce Labs Onesie
...    Sauce Labs Fleece Jacket
...    Sauce Labs Bolt T-Shirt
...    Sauce Labs Bike Light
...    Sauce Labs Backpack

@{PRICE_LOW_TO_HIGH}
...    Sauce Labs Onesie
...    Sauce Labs Bike Light
...    Sauce Labs Bolt T-Shirt
...    Test.allTheThings() T-Shirt (Red)
...    Sauce Labs Backpack
...    Sauce Labs Fleece Jacket

@{PRICE_HIGH_TO_LOW}
...    Sauce Labs Fleece Jacket
...    Sauce Labs Backpack
...    Sauce Labs Bolt T-Shirt
...    Test.allTheThings() T-Shirt (Red)
...    Sauce Labs Bike Light
...    Sauce Labs Onesie


*** Test Cases ***
Sort Products By Name A To Z
    Verify Product Sorting    az    ${NAMES_A_TO_Z}

Sort Products By Name Z To A
    Verify Product Sorting    za    ${NAMES_Z_TO_A}

Sort Products By Price Low To High
    Verify Product Sorting    lohi    ${PRICE_LOW_TO_HIGH}

Sort Products By Price High To Low
    Verify Product Sorting    hilo    ${PRICE_HIGH_TO_LOW}


*** Keywords ***
Open Firefox Browser
    ${service}=    Evaluate    sys.modules['selenium.webdriver'].FirefoxService(log_output=r'${EXECDIR}${/}logs${/}geckodriver.log')    sys, selenium.webdriver
    Open Browser    ${URL}    firefox    service=${service}
    Maximize Browser Window

Open Sauce Demo And Login
    Open Firefox Browser
    Sleep    2s

    Input Text    id=user-name    ${Username}
    Input Text    id=password    ${Password}
    Click Button    id=login-button

    Wait Until Element Is Visible    css=.inventory_list    timeout=10s
    Page Should Contain Element    css=.product_sort_container

Verify Product Sorting
    [Arguments]    ${sort_option}    ${expected_names}

    Select From List By Value    css=.product_sort_container    ${sort_option}

    ${products}=    Get WebElements    css=.inventory_item_name
    @{actual_names}=    Create List

    FOR    ${product}    IN    @{products}
        ${name}=    Get Text    ${product}
        Append To List    ${actual_names}    ${name}
    END

    Lists Should Be Equal    ${actual_names}    ${expected_names}
