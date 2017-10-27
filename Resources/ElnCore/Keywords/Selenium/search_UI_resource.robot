*** Settings ***
Documentation     A resource file containing IDBS defined keywords used for testing the IDBS E-WorkBook Web Client application. This resource file contains keywords specific to testing the search view UI elements.
...               This file is loaded by the common_resource.txt file which is automatically loaded when running tests through the Robot Framework.
...               *Version: E-WorkBook Web Client 9.1.0*
Resource          general_resource.robot
Library           IDBSSelenium2Library

*** Variables ***
${search text field}    SearchBasicControlsPanel-textBoxText
${run search button}    SearchBasicControlsPanel-buttonSearch
${hide search options}    searchOptionsHideShow
${search in properties}    ewb-search-searchin
${search in content}    ewb-search-option-within-document-content
${search in comments}    ewb-search-option-within-comments
${search scope record}    ewb-search-option-records
${search scope everything}    ewb-search-option-anything
${search date selector link}    dateTimestampOption
${ewb-timestamp-popup-menu}    ewb-popup-menu
${search date created}    timestamp-menu-created-by
${search date modified}    timestamp-menu-last-modified-by
${search date modified or created}    timestamp-menu-created-or-last-modified-by
${search date any}    ewb-search-option-any-time
${search date week}    ewb-search-option-in-the-past-week
${search date month}    ewb-search-option-in-the-past-month
${search date custom}    ewb-search-option-custom-range
${search date from}    startDateTextBox
${search date to}    endDateTextBox
${search date from picker}    startDatePicker
${search date to picker}    endDatePicker
${search user selector link}    userTimestampOption
${ewb-user-popup-menu}    ewb-popup-menu
${search user created}    timestamp-menu-created-by
${search user modified}    timestamp-menu-last-modified-by
${search user modified or created}    timestamp-menu-created-or-last-modified-by
${search user selection}    suggestionBox1
${search user text field}    //div[contains(text(), 'suggestPopupContent')]
${search in properties checkbox}    ewb-search-option-properties-checkBox
${search in content checkbox}    ewb-search-option-content-checkBox
${search in comments checkbox}    ewb-search-option-comments-checkBox
${search scope record radiobutton}    ewb-search-option-record-data-radioButton
${search scope everything radiobutton}    ewb-search-option-everything-radioButton
${search date created checkbox}    ewb-search-option-created-on-checkBox
${search date modified checkbox}    ewb-search-option-last-modified-on-checkBox
${search date any radiobutton}    ewb-search-option-any-radioButton
${search date week radiobutton}    ewb-search-option-past-week-radioButton
${search date month radiobutton}    ewb-search-option-past-month-radioButton
${search date custom radiobutton}    ewb-search-option-custom-radioButton
${search user created checkbox}    ewb-search-option-created-by-checkBox
${search user modified checkbox}    ewb-search-option-last-modified-by-checkBox

*** Keywords ***
Check Search Header UI
    [Documentation]    Verifies that search options header options are present. Checks search text field, clear search button and run search buttons are visible.
    ...
    ...    NOTE - these are actually part of the main header of the application and do not indicate that the search view is present
    Element Should Be Visible    ${search text field}
    Element Should Be Visible    ${run search button}

Check Default Search Options UI
    [Documentation]    Verifies that the default search options are present. This does not check which options are selected.
    Check Search In UI
    Check Search Scope UI
    Check Search Date UI No Custom
    Check Search User UI No User Field Open

Check Search In UI
    [Documentation]    Verifies that the "Search In" options are present. This does not check which options are selected.
    Element Should Be Visible    ${search in properties}
    Element Should Be Visible    ${search in content}
    Element Should Be Visible    ${search in comments}

Check Search Scope UI
    [Documentation]    Verifies that the "Search Scope" options are present. This does not check which options are selected.
    Element Should Be Visible    ${search scope record}
    Element Should Be Visible    ${search scope everything}

Check Search Date UI No Custom
    [Documentation]    Verifies that the "Search Date" options are present without the custom date fields open. This does not check which options are selected.
    Element Should Be Visible    ${search date selector link}
    Page Should Not Contain Element    ${search date created}
    Page Should Not Contain Element    ${search date modified}
    Page Should Not Contain Element    ${search date modified or created}
    Robust Click    xpath=//div[@id='${search date selector link}']/a
    Element Should Be Visible    ${ewb-timestamp-popup-menu}
    Element Should Be Visible    ${search date created}
    Element Should Be Visible    ${search date modified}
    Element Should Be Visible    ${search date modified or created}
    Robust Click    ${search date modified}
    Page Should Not Contain Element    ${ewb-timestamp-popup-menu}
    Page Should Not Contain Element    ${search date created}
    Page Should Not Contain Element    ${search date modified}
    Page Should Not Contain Element    ${search date modified or created}
    Element Should Be Visible    ${search date any}
    Element Should Be Visible    ${search date week}
    Element Should Be Visible    ${search date month}

Check Search User UI No User Field Open
    [Documentation]    Verifies that the "Search In" options are present without the user selection field active. This does not check which options are selected.
    Element Should Be Visible    ${search user selector link}
    Page Should Not Contain Element    ${search user created}
    Page Should Not Contain Element    ${search user modified}
    Page Should Not Contain Element    ${search user modified or created}
    Robust Click    xpath=//div[@id='${search user selector link}']/a
    Element Should Be Visible    ${search user created}
    Element Should Be Visible    ${search user modified}
    Element Should Be Visible    ${search user modified or created}
    Robust Click    ${search user modified or created}
    Page Should Not Contain Element    ${search user created}
    Page Should Not Contain Element    ${search user modified}
    Page Should Not Contain Element    ${search user modified or created}
    Element Should Be Visible    ${search user selection}
    Page Should Not Contain Element    ${search user text field}

Toggle Search Options View
    [Documentation]    *DEPRECATED*
    ...
    ...    EWB WEB 9.3 has no hide/show search options element
    ...
    ...    Toggles the Search Options Visibility On or Off.
    Click Link    ${hide search options}    don't wait

Check Search Options Hidden
    [Documentation]    *DEPRECATED*
    ...
    ...    EWB WEB 9.3 has no hide/show search options element
    ...
    ...    Checks that the search options are hidden in the search UI.
    Element Should Not Be Visible    ${search in properties}
    Element Should Not Be Visible    ${search in content}
    Element Should Not Be Visible    ${search in comments}
    Element Should Not Be Visible    ${search scope record}
    Element Should Not Be Visible    ${search scope everything}
    Element Should Not Be Visible    ${search date created}
    Element Should Not Be Visible    ${search date modified}
    Element Should Not Be Visible    ${search date any}
    Element Should Not Be Visible    ${search date week}
    Element Should Not Be Visible    ${search date month}
    Element Should Not Be Visible    ${search user created}
    Element Should Not Be Visible    ${search user modified}
    Element Should Not Be Visible    ${search user selection}
