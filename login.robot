*** Settings ***
Library             SeleniumLibrary

Test Setup          Open Browser To Login Page
Test Teardown       Close Browser


*** Variables ***
${URL}                  https://opensource-demo.orangehrmlive.com/web/index.php/auth/login
${BROWSER}              chrome
${VALID_USERNAME}       Admin
${VALID_PASSWORD}       admin123
${INVALID_USERNAME}     wronguser
${INVALID_PASSWORD}     wrongpass

# Locators
${USERNAME_FIELD}       xpath=//input[@name='username']
${PASSWORD_FIELD}       xpath=//input[@name='password']
${LOGIN_BUTTON}         xpath=//button[@type='submit']
${DASHBOARD_HEADER}     xpath=//span[text()='Dashboard']
${ERROR_MESSAGE}        xpath=//p[contains(@class,'oxd-alert-content-text')]
${USER_DROPDOWN}        xpath=//span[@class='oxd-userdropdown-tab']
${LOGOUT_LINK}          xpath=//a[text()='Logout']


*** Test Cases ***
Test Login Sequence
    # Bước 1: Đăng nhập thành công
    Input Credentials    ${VALID_USERNAME}    ${VALID_PASSWORD}
    Verify Dashboard Page Is Displayed

    # Bước 2: Đăng xuất
    Logout From Application
    Verify Login Page Is Displayed

    # Bước 3: Thử đăng nhập với thông tin không hợp lệ
    Input Credentials    ${INVALID_USERNAME}    ${INVALID_PASSWORD}
    Verify Error Message Is Displayed    Invalid credentials


*** Keywords ***
Open Browser To Login Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Page Contains Element    ${USERNAME_FIELD}    timeout=10s
    Set Selenium Timeout    10s

Input Credentials
    [Arguments]    ${username}    ${password}
    Input Text    ${USERNAME_FIELD}    ${username}
    Input Password    ${PASSWORD_FIELD}    ${password}
    Click Element    ${LOGIN_BUTTON}
    Sleep    1s

Verify Dashboard Page Is Displayed
    Wait Until Page Contains Element    ${DASHBOARD_HEADER}    timeout=10s
    Element Should Be Visible    ${DASHBOARD_HEADER}

Verify Login Page Is Displayed
    Wait Until Page Contains Element    ${LOGIN_BUTTON}    timeout=10s
    Element Should Be Visible    ${LOGIN_BUTTON}

Verify Error Message Is Displayed
    [Arguments]    ${expected_message}
    Wait Until Element Is Visible    ${ERROR_MESSAGE}    timeout=10s
    Element Should Contain    ${ERROR_MESSAGE}    ${expected_message}

Logout From Application
    Click Element    ${USER_DROPDOWN}
    Wait Until Element Is Visible    ${LOGOUT_LINK}    timeout=5s
    Click Element    ${LOGOUT_LINK}
    Sleep    1s
