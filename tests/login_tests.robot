
*** Settings ***
Library    SeleniumLibrary
Test Teardown    Close All Browsers


*** Variables ***
${URL}    https://www.saucedemo.com/
${Username}    standard_user
${Password}    secret_sauce
${LockedUsername}    locked_out_user
${InvalidPassword}    wrong_password


*** Test Cases ***
Login With Locked Out User
    Open Firefox Browser
    Sleep    2s

    Input Text    id=user-name    ${LockedUsername}
    Sleep    1s
    Input Text    id=password    ${Password}
    Sleep    1s

    Click Button    id=login-button
    Sleep    1s

    Wait Until Element Is Visible    css=[data-test="error"]    timeout=10s

    Element Text Should Be    css=[data-test="error"]    Epic sadface: Sorry, this user has been locked out.

    Capture Page Screenshot    ${EXECDIR}${/}results${/}screenshots${/}locked_out_user.png


Login With Incorrect Password
    Open Firefox Browser
    Sleep    2s

    Input Text    id=user-name    ${Username}
    Sleep    1s
    Input Text    id=password    ${InvalidPassword}
    Sleep    1s

    Click Button    id=login-button
    Sleep    1s

    Wait Until Element Is Visible    css=[data-test="error"]    timeout=10s

    Element Text Should Be    css=[data-test="error"]    Epic sadface: Username and password do not match any user in this service

    Capture Page Screenshot    ${EXECDIR}${/}results${/}screenshots${/}incorrect_password.png


*** Keywords ***
Open Firefox Browser
    ${service}=    Evaluate    sys.modules['selenium.webdriver'].FirefoxService(log_output=r'${EXECDIR}${/}logs${/}geckodriver.log')    sys, selenium.webdriver
    Open Browser    ${URL}    firefox    service=${service}
    Maximize Browser Window
