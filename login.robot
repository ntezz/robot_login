*** Settings ***
Library             SeleniumLibrary

Suite Setup         Open Browser To Login Page
Suite Teardown      Close Browser


*** Variables ***
${URL}                  https://opensource-demo.orangehrmlive.com/web/index.php/auth/login
${BROWSER}              chrome
${VALID_USERNAME}       Admin
${VALID_PASSWORD}       admin123
${INVALID_USERNAME}     wronguser
${INVALID_PASSWORD}     wrongpass


*** Test Cases ***
Valid Login Should Succeed
    Input Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Wait Until Page Contains Element    xpath=//span[text()='Dashboard']
    Page Should Contain Element    xpath=//span[text()='Dashboard']

Invalid Login Should Show Error
    Input Credentials    ${INVALID_USERNAME}    ${INVALID_PASSWORD}
    Wait Until Page Contains Element    xpath=//p[contains(@class,'oxd-alert-content-text')]
    Element Should Contain    xpath=//p[contains(@class,'oxd-alert-content-text')]    Invalid credentials


*** Keywords ***
Open Browser To Login Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    xpath=//input[@name='username']

Input Credentials
    [Arguments]    ${username}    ${password}
    Input Text    xpath=//input[@name='username']    ${username}
    Input Text    xpath=//input[@name='password']    ${password}
    Click Button    xpath=//button[@type='submit']
