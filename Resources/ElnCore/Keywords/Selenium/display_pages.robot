*** Settings ***
Library           IDBSSelenium2Library
Resource          ../Common/common_resource.robot
Resource          ./general_resource.robot
Resource          ../Web Services/Core Web Services/Entity Service/rest_entity_service_resource.robot
Resource          ../Web Services/Core Web Services/Entity Lock Service/rest_entity_lock_service.robot
Resource          ../Web Services/Core Web Services/Entity Service/rest_entity_service_resource.robot
Library           EntityAPILibrary
Library           String

*** Variables ***
${experiment_preview_id_tag}    -preview-    # This is part of the id of a preview image displayed in an experiment page
${select_pages_preview_id_tag}    -select-pages-preview-    # This is part of the id of a preview image displayed in the select pages dialog
${experiment_preview_download_id_tag}    -image-download-link    # This is the part of the id for the download link for the full sized image of a preview
${single_page_id_tag}    -single-page-id-    # This is part of the id of a single page preview image displayed in the Display Pages dialog
${sheet_id_tag}    -page-stack-id-    # This is part of the id of a page stack preview image displayed in the Display Pages dialog
${sheet_expand_tag}    -page-stack-grid-
${single_page_rotate_tag}    -single-page-rotate-    # The tag identifying the element actioning a page rotation
${selected_single_page_id_tag}    [selected-single-page][image]    # The tag identifying a selected page
${checkbox_ticked_id_tag}    [selected-single-page][checkbox-ticked]    # The image corresponding to the ticked checkbox used in the selected pages panel
${checkbox_unticked_id_tag}    [selected-single-page][checkbox-unticked]    # The image corresponding to the unticked checkbox used in the selected pages panel

*** Keywords ***
Add create test experiment and add document
    [Arguments]    ${number_of_pages_in_document}    ${document to add}
    [Documentation]    Creates, via SAPI, a group, a project and an experiment with default names: (Group | Project | Experiment) -${TEST NAME}-${time}. Then it adds a document to the experiment and commit the experiment as DRAFT.
    ...
    ...    *Arguments*
    ...
    ...    ${number_of_pages_in_document} The number of pages in the document
    ...
    ...    ${document to add} The path to the document to add
    ...
    ...    *Return value*
    ...    A List of group id (at [0]), project if (at [1]), experiment id (at [2]), then the document id (at [3])
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    [Timeout]
    @{ids}=    Setup test environment via SAPI    ${document to add}
    ${web app url}=    Create webapp url    @{ids}[2]
    Open Browser    ${web app url}    ${BROWSER}
    Run Keyword And Ignore Error    Maximize Browser Window
    Log In Via Login Dialog    ${VALID USER}    ${VALID PASSWD}
    Open Display Pages Dialog    0
    Comment    The delay is needed to ensure that Select Pages panel is fully loaded before checking its content
    Sleep    5
    Check page configuration and displayed thumbnails    ${number_of_pages_in_document}    @{ids}[3]
    [Return]    @{ids}    # An array containing the group, project, experiment, and document ids

Change content and validate
    [Arguments]    ${updated_document}    ${entity_id}    ${number_of_pages_in_updated_document}    ${mime_type}
    ${original_page_configuration_xml}=    Get Page Configuration    ${entity_id}
    ${entity_version_id}=    Set Entity Data    ${entity_id}    ${updated_document}    ${mime_type}    FILE
    ${page_configuration_xml}=    Get Page Configuration    ${entity_id}
    Compare Page Configuration xml    ${original_page_configuration_xml}    ${page_configuration_xml}    ${number_of_pages_in_updated_document}
    ${selected_pages_count}=    Count selected pages given pages configuration    ${page_configuration_xml}
    Confirm all pages are displayed in experiment    ${entity_id}    ${selected_pages_count}

Check configuration attribute match
    [Arguments]    ${original_page_configuration_xml}    ${updated_page_configuration_xml}    ${page_index}    ${attribute_to_compare}
    @{original}=    XMLLibrary.Get Element Attribute From Xpath    ${original_page_configuration_xml}    .//{http://entity.preview.services.ewb.idbs.com}previewDetail[${page_index}]    ${attribute_to_compare}
    @{updated}=    XMLLibrary.Get Element Attribute From Xpath    ${updated_page_configuration_xml}    .//{http://entity.preview.services.ewb.idbs.com}previewDetail[${page_index}]    ${attribute_to_compare}
    Lists Should Be Equal    @{original}    @{updated}

Check configuration row is equal
    [Arguments]    ${original_page_configuration_xml}    ${updated_page_configuration_xml}    ${page_index}
    Check configuration attribute match    ${original_page_configuration_xml}    ${updated_page_configuration_xml}    ${page_index}    selected
    Check configuration attribute match    ${original_page_configuration_xml}    ${updated_page_configuration_xml}    ${page_index}    rotation

Check correct number of pages displayed
    [Arguments]    ${entity_id}    ${pages displayed}    ${preview_id_tag}=-preview-
    [Documentation]    Check if there are the expected number of occurrences of "${entity_id}${preview_id_tag}"
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id} The entity id
    ...
    ...    ${pages displayed} The expected number of occurrences
    ...
    ...    ${preview_id_tag} The tag part of the preview id
    ...
    ...    *Return value*
    ...    none
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    Wait Five Seconds
    Xpath Should Match X Times    //img[contains(@id, '${preview_id_tag}')]    ${pages displayed}

Check page configuration and displayed thumbnails
    [Arguments]    ${expected_number_of_pages}    ${entity_id}
    [Documentation]    Retrieves the entity pages configuration for ${entity_id} and checks if the number of pages matches with the expected one. It also cheks if the number of displayed thumbnails is as expected.
    ...
    ...    *Arguments*
    ...
    ...    ${expected_number_of_pages} The expected number of pages in the document
    ...
    ...    ${entity_id} The id of the document
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    ${entity_version_id}=    Get Entity Version ID    ${entity_id}
    ${page_configuration_xml}=    Get Page Configuration    ${entity_id}
    Number of rows in page configuration matches expected number of pages in document    ${page_configuration_xml}    ${expected_number_of_pages}
    Check correct number of pages displayed    ${entity_id}    ${expected_number_of_pages}    ${single_page_id_tag}

Compare Page Configuration xml
    [Arguments]    ${original_page_configuration}    ${updated_page_configuration}    ${expected_number_of_pages}
    Number of rows in page configuration matches expected number of pages in document    ${updated_page_configuration}    ${expected_number_of_pages}
    ${original_number_of_pages}=    Get page count from configuration    ${original_page_configuration}
    ${updated_number_of_pages}=    Get page count from configuration    ${updated_page_configuration}
    ${number_of_pages_to_check} =    Set Variable    ${updated_number_of_pages}
    : FOR    ${current index}    IN RANGE    1
    \    Check configuration row is equal    ${original_page_configuration}    ${updated_page_configuration}    ${current index}

Confirm all pages are displayed in experiment
    [Arguments]    ${entity_id}    ${number of pages displayed}
    Wait Twenty Seconds
    Check correct number of pages displayed    ${entity_id}    ${number of pages displayed}    ${experiment_preview_id_tag}

Count selected pages given pages configuration
    [Arguments]    ${pages_configuration}
    [Documentation]    Counts how many pages are selected in the given configuration
    ...
    ...    *Arguments*
    ...
    ...    ${pages_configuration} the pages configuration
    ...
    ...    *Return value*
    ...    The number of selected pages
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    ...    None
    ${found_attributes}=    XMLLibrary.Get Element Attribute    ${pages_configuration}    previewDetail    selected    http://entity.preview.services.ewb.idbs.com
    ${selected_pages_count}=    Count Values In List    ${found_attributes}    true
    [Return]    ${selected_pages_count}    # The number of selected pages

Create Experiment using TestCase Name
    Click Navigate Header Link
    ${time}    Get Time
    Create Entity    Group    Group-${TEST NAME}-${time}    Root    NAVIGATOR
    Create Entity    Project    Project-${TEST NAME}-${time}    Group-${TEST NAME}-${time}    NAVIGATOR
    Create Entity    Experiment    Experiment-${TEST NAME}-${time}    Project-${TEST NAME}-${time}    NAVIGATOR

Create webapp url
    [Arguments]    ${entity_id}=1
    ${webapp URL}    Set Variable    ${WEB_CLIENT_HTTP_SCHEME}://${SERVER}:${WEB_CLIENT_PORT}/EWorkbookWebApp/#entity/displayEntity?entityId=${entity_id}&r=y&v=y
    [Return]    ${webapp URL}

Display all pages
    [Arguments]    ${page_count}    ${document_to_add}
    [Documentation]    *Arguments*
    ...
    ...    ${page_count} The number of pages in the document
    ...
    ...    ${document to add} The path to the document to add
    ...
    ...    *Return value*
    ...    The document entity id
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    @{ids}    Add create test experiment and add document    ${page_count}    ${document_to_add}
    ${entity_id}=    Set Variable    @{ids}[3]
    ${xpaths found}=    Count Single Pages    ${entity_id}
    Log    ${entity_id}
    : FOR    ${current index}    IN RANGE    ${xpaths found}
    \    Select Single Page    ${entity_id}    ${current index}
    Click OK
    ${current index}=    Evaluate    ${current index}+1
    Confirm all pages are displayed in experiment    ${entity_id}    ${current index}
    Comment    Version Save Record    ${VALID USER}    ${VALID PASSWD}    Data Added
    [Return]    ${entity_id}

Display all pages and version save
    [Arguments]    ${page_count}    ${document_to_add}
    [Documentation]    *Arguments*
    ...
    ...    ${page_count} The number of pages in the document
    ...
    ...    ${document to add} The path to the document to add
    ...
    ...    *Return value*
    ...    The document entity id
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    @{ids}    Add create test experiment and add document    ${page_count}    ${document_to_add}
    ${entity_id}=    Set Variable    @{ids}[3]
    ${xpaths found}=    Count Single Pages    ${entity_id}
    Log    ${entity_id}
    : FOR    ${current index}    IN RANGE    ${xpaths found}
    \    Select Single Page    ${entity_id}    ${current index}
    Click OK
    ${current index}=    Evaluate    ${current index}+1
    Confirm all pages are displayed in experiment    ${entity_id}    ${current index}
    Version Save Record    ${VALID USER}    ${VALID PASSWD}    Data Added
    [Return]    ${entity_id}

Display all pages rotated anticlockwise
    [Arguments]    ${page_count}    ${document_to_add}
    [Documentation]    *Arguments*
    ...
    ...    ${page_count} The number of pages in the document
    ...
    ...    ${document to add} The path to the document to add
    ...
    ...    *Return value*
    ...    The document entity id
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    @{ids}    Add create test experiment and add document    ${page_count}    ${document_to_add}
    ${entity_id}=    Set Variable    @{ids}[3]
    ${xpaths_found}=    Count Single Pages    ${entity_id}
    Log    ${entity_id}
    : FOR    ${current index}    IN RANGE    ${xpaths_found}
    \    Select Single Page    ${entity_id}    ${current index}
    \    Rotate Single Page    ${entity_id}    ${current index}    ${false}
    Click OK
    ${current index}=    Evaluate    ${current index}+1
    Confirm all pages are displayed in experiment    ${entity_id}    ${current index}
    [Return]    ${entity_id}

Display all pages rotated clockwise
    [Arguments]    ${page_count}    ${document_to_add}
    [Documentation]    *Arguments*
    ...
    ...    ${page_count} The number of pages in the document
    ...
    ...    ${document to add} The path to the document to add
    ...
    ...    *Return value*
    ...    The document entity id
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    @{ids}    Add create test experiment and add document    ${page_count}    ${document_to_add}
    ${entity_id}=    Set Variable    @{ids}[3]
    ${xpaths found}=    Count Single Pages    ${entity_id}
    Log    ${entity_id}
    : FOR    ${current index}    IN RANGE    ${xpaths found}
    \    Select Single Page    ${entity_id}    ${current index}
    \    Rotate Single Page    ${entity_id}    ${current index}
    Click OK
    ${current index}=    Evaluate    ${current index}+1
    Confirm all pages are displayed in experiment    ${entity_id}    ${current index}
    [Return]    ${entity_id}

Display even pages
    [Arguments]    ${page_count}    ${document_to_add}
    [Documentation]    *Arguments*
    ...
    ...    ${page_count} The number of pages in the document
    ...
    ...    ${document to add} The path to the document to add
    ...
    ...    *Return value*
    ...    The document entity id
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    @{ids}    Add create test experiment and add document    ${page_count}    ${document_to_add}
    ${entity_id}=    Set Variable    @{ids}[3]
    ${xpaths found}=    Count Single Pages    ${entity_id}
    Log    ${entity_id}
    ${number_of_selected_page}=    Set Variable    0
    : FOR    ${current index}    IN RANGE    ${xpaths found}
    \    Run Keyword If    ${current index}%2==1    Select Single Page    ${entity_id}    ${current index}
    \    ${number_of_selected_page}=    Set Variable If    ${current index}%2==1    ${${number_of_selected_page}+1}    ${number_of_selected_page}
    Click OK
    Log    Selected Page=${number_of_selected_page}
    Confirm all pages are displayed in experiment    ${entity_id}    ${number_of_selected_page}
    [Return]    ${entity_id}    # The document entity id

Display odd pages rotated clockwise
    [Arguments]    ${page_count}    ${document_to_add}
    [Documentation]    *Arguments*
    ...
    ...    ${page_count} The number of pages in the document
    ...
    ...    ${document to add} The path to the document to add
    ...
    ...    *Return value*
    ...    The document entity id
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    @{ids}    Add create test experiment and add document    ${page_count}    ${document_to_add}
    ${entity_id}=    Set Variable    @{ids}[3]
    ${xpaths found}=    Count Single Pages    ${entity_id}
    Log    ${entity_id}
    ${number_of_selected_page}=    Set Variable    0
    : FOR    ${current index}    IN RANGE    ${xpaths found}
    \    Run Keyword If    ${current index}%2==0    Select Single Page    ${entity_id}    ${current index}
    \    Run Keyword If    ${current index}%2==0    Rotate Single Page    ${entity_id}    ${current index}
    \    ${number_of_selected_page}=    Set Variable If    ${current index}%2==0    ${${number_of_selected_page}+1}    ${number_of_selected_page}
    Click OK
    Log    Selected Page=${number_of_selected_page}
    Confirm all pages are displayed in experiment    ${entity_id}    ${number_of_selected_page}
    [Return]    ${entity_id}

Display odd pages rotated clockwise even rotated Anticlockwise
    [Arguments]    ${page_count}    ${document_to_add}
    [Documentation]    *Arguments*
    ...
    ...    ${page_count} The number of pages in the document
    ...
    ...    ${document to add} The path to the document to add
    ...
    ...    *Return value*
    ...    The document entity id
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    @{ids}    Add create test experiment and add document    ${page_count}    ${document_to_add}
    ${entity_id}=    Set Variable    @{ids}[3]
    ${xpaths found}=    Count Single Pages    ${entity_id}
    Log    ${entity_id}
    : FOR    ${current index}    IN RANGE    ${xpaths found}
    \    Run Keyword If    ${current index}%2==1    Rotate Single Page    ${entity_id}    ${current index}
    \    Run Keyword If    ${current index}%2==0    Rotate Single Page    ${entity_id}    ${current index}    ${false}
    \    Select Single Page    ${entity_id}    ${current index}
    Click OK
    ${current index}=    Evaluate    ${current index}+1
    Confirm all pages are displayed in experiment    ${entity_id}    ${current index}
    [Return]    ${entity_id}

Get page count from configuration
    [Arguments]    ${page_configuration_xml}
    ${number_of_pages_in_configuration}=    Get Xml Element Count    ${page_configuration_xml}    previewDetail    http://entity.preview.services.ewb.idbs.com
    [Return]    ${number_of_pages_in_configuration}

Number of rows in page configuration matches expected number of pages in document
    [Arguments]    ${page_configuration_xml}    ${number_of_pages_in_document}
    ${number_of_pages_in_configuration}=    Get page count from configuration    ${page_configuration_xml}
    Log    ${page_configuration_xml}
    Log    ${number_of_pages_in_configuration}=
    Log    ${number_of_pages_in_document}
    Should Be Equal As Numbers    ${number_of_pages_in_configuration}    ${number_of_pages_in_document}

Open Display Pages Dialog
    [Arguments]    ${DOC_INDEX}
    Log    ${DOC_INDEX}
    Open Document Header Tool Menu    ${DOC_INDEX}
    wait until page contains element    ewb-editor-command-edit-selected-previews
    Robust Click    ewb-editor-command-edit-selected-previews



Download preview full size image
    [Arguments]    ${entity_id}
    [Documentation]    Downloads the full size version of the perview image
    ${full_id}    Set Variable    ${entity_id}${experiment_preview_download_id_tag}
    Page Should Contain Element    ${full_id}
    Robust Click    ${full_id}

Open Experiment
    [Arguments]    ${experiment_id}    # The experiment id
    [Documentation]    Open the browser and login to the given experiment
    ...
    ...    *Arguments*
    ...
    ...    ${experiment_id} The experiment id
    ...
    ...    *Return value*
    ...
    ...    *Precondition*
    ...
    ...    *Example*
    ${web app url}=    Create webapp url    ${experiment_id}
    Open Browser    ${web app url}    ${BROWSER}
    Run Keyword And Ignore Error    Maximize Browser Window
    Log In Via Login Dialog    ${VALID USER}    ${VALID PASSWD}

Count Single Pages
    [Arguments]    ${entity_id}
    [Documentation]    Count how many Single Pages are displayed in the current HTML page or frame
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    ${source_page}: the page source
    ...
    ...    *Return value*
    ...
    ...    ${pages_count}: the number of displayed Single Pages
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    ${page_indexes}=    Get Single Page Indexes    ${entity_id}
    ${pages_count}=    Get Length    ${page_indexes}
    [Return]    ${pages_count}    # The number of found pages

Count Sheets
    [Arguments]    ${entity_id}
    [Documentation]    Count how many Page Stacks are displayed in the current HTML page or frame
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    ${source_page}: the page source
    ...
    ...    *Return value*
    ...
    ...    ${pages_count}: the number of displayed Page Stacks
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    ${sheet_names}=    Get Sheet Names    ${entity_id}
    ${sheets_count}=    Get Length    ${sheet_names}
    [Return]    ${sheets_count}    # The number of found page stacks

Get Single Page Indexes
    [Arguments]    ${entity_id}
    [Documentation]    Count how many Single Pages are displayed in the current HTML page or frame
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    ${source_page}: the page source
    ...
    ...    *Return value*
    ...
    ...    ${pages_count}: the number of displayed Single Pages
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    ${matching_tag}=    Set Variable    ${entity_id}${single_page_id_tag}
    ${elements_count}=    IDBSSelenium2Library.Get Matching Xpath Count    //img[contains(@id, "${matching_tag}")]
    Run Keyword If    '${elements_count}'=='25'    Robust Click    xpath=(//img[contains(@id, "${matching_tag}")])[25]
    Run Keyword If    '${elements_count}'=='25'    Robust Click    xpath=(//img[contains(@id, "${matching_tag}")])[25]
    Comment    sleep    5
    ${elements_count}=    IDBSSelenium2Library.Get Matching Xpath Count    //img[contains(@id, "${matching_tag}")]
    ${page_indexes}=    Create List
    : FOR    ${loop_index}    IN RANGE    1    ${elements_count}+1
    \    ${element_id}=    IDBSSelenium2Library.Get Element Attribute    xpath=(//img[contains(@id, '${matching_tag}')])[${loop_index}]@id
    \    ${page_index}=    String.Fetch From Right    ${element_id}    ${matching_tag}
    \    Append To List    ${page_indexes}    ${page_index}
    [Return]    ${page_indexes}    # The page indexes

Get Sheet Names
    [Arguments]    ${entity_id}
    [Documentation]    Count how many Single Pages are displayed in the current HTML page or frame
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    ${source_page}: the page source
    ...
    ...    *Return value*
    ...
    ...    ${pages_count}: the number of displayed Single Pages
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    ${matching_tag}=    Set Variable    ${entity_id}${sheet_id_tag}
    ${elements_count}=    IDBSSelenium2Library.Get Matching Xpath Count    //img[contains(@id, '${matching_tag}')]
    ${sheet_names}=    Create List
    : FOR    ${loop_index}    IN RANGE    1    ${elements_count}+1
    \    ${element_id}=    IDBSSelenium2Library.Get Element Attribute    xpath=(//img[contains(@id, '${matching_tag}')])[${loop_index}]@id
    \    ${sheet_name}=    String.Fetch From Right    ${element_id}    ${matching_tag}
    \    Append To List    ${sheet_names}    ${sheet_name}
    [Return]    ${sheet_names}    # The page indexes

Display Sheet Content
    [Arguments]    ${entity_id}    ${sheet_name}
    [Documentation]    Count how many Single Pages are displayed in the current HTML page or frame
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    *Return value*
    ...
    ...    ${pages_count}: the number of displayed Single Pages
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    Scroll Element Into View    ${entity_id}${sheet_id_tag}${sheet_name}
    Click Element    ${entity_id}${sheet_expand_tag}${sheet_name}

Select All Pages
    [Documentation]    Select all pages displayed in the current pages panel by clicking the Select All button
    ...
    ...    *Arguments*
    ...
    ...    *Return value*
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    Click Element    display-pages-select-all-button

Deselect All Pages
    [Documentation]    Deselect all pages displayed in the current pages panel by clicking the Deselect All button
    ...
    ...    *Arguments*
    ...
    ...    *Return value*
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    Click Element    display-pages-unselect-all-button

Scroll To Last Displayed Sheet
    [Arguments]    ${entity_id}
    [Documentation]    Sroll to the last displayed sheet. Scolling causes more sheet to be displayed if they are not all already displayed. *Note: it will fails if no Single Pages are displayed*.
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    *Return value*
    ...
    ...    ${last_sheet_namet}: the name of the last sheet displayed
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    @{sheet_names}=    Get Sheet Names    ${entity_id}
    ${sheets_count}=    Get Length    ${sheet_names}
    ${last_element_index}=    Evaluate    ${sheets_count}-1
    ${last_sheet_name}=    Set Variable    @{sheet_names}[${last_element_index}]
    ${last_sheet_name}=    Set Variable    ${entity_id}${sheet_id_tag}${last_sheet_name}
    Scroll Element Into View    ${last_sheet_name}
    [Return]    ${last_sheet_name}    # The name of the last sheet displayed in the panel

Scroll To Last Displayed Single Page
    [Arguments]    ${entity_id}
    [Documentation]    Sroll to the last displayed single page. Scolling causes more single pages to be displayed if they are not all already displayed. *Note: it will fails if no Single Pages are displayed*.
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    *Return value*
    ...
    ...    ${last_sheet_namet}: the index of the last single page displayed
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    @{page_indexes}=    Get Single Page Indexes    ${entity_id}
    ${pages_count}=    Get Length    ${page_indexes}
    ${last_element_index}=    Evaluate    ${pages_count}-1
    ${last_page_index}=    Set Variable    @{page_indexes}[${last_element_index}]
    ${last_page_id}=    Set Variable    ${entity_id}${single_page_id_tag}${last_page_index}
    Scroll Element Into View    ${last_page_id}
    [Return]    ${last_page_index}    # The index of the last page displayed in the panel

Click Back Button
    Click Element    display-pages-back-button

Is Sheet Selected
    [Arguments]    ${entity_id}    ${sheet_name}
    [Documentation]    Asses the select status of the given sheet.
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    ${sheet_name}: the sheet name
    ...
    ...    *Return value*
    ...
    ...    ${1} if the sheet is selected, ${0} otherwise
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    ${matching_id_tag}=    Set Variable    ${entity_id}${sheet_id_tag}${sheet_name}
    ${matching_class_tag}    Set Variable    display-pages-image-selected
    ${status}    ${class_attribute}    Run Keyword And Ignore Error    IDBSSelenium2Library.Get Element Attribute    xpath=(//img[@id='${matching_id_tag}' and contains(@class, '${matching_class_tag}')])@class
    ${is_selected}    Set Variable If    '${status}' == 'PASS'    ${true}    ${false}
    [Return]    ${is_selected}    # ${true} if it's selected, ${false} otherwise

Is Single Page Selected
    [Arguments]    ${entity_id}    ${page_index}
    [Documentation]    Asses the select status of the given page.
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    ${page_index}: the page index
    ...
    ...    *Return value*
    ...
    ...    ${1} if the sheet is selected, ${0} otherwise
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    ${matching_id_tag}=    Set Variable    ${entity_id}${single_page_id_tag}${page_index}
    ${matching_class_tag}    Set Variable    display-pages-image-selected
    ${status}    ${class_attribute}    Run Keyword And Ignore Error    IDBSSelenium2Library.Get Element Attribute    xpath=(//img[@id='${matching_id_tag}' and contains(@class, '${matching_class_tag}')])@class
    ${is_selected}    Set Variable If    '${status}' == 'PASS'    ${true}    ${false}
    [Return]    ${is_selected}    # ${true} if it's selected, ${false} otherwise

Assert Sheets Are Selected
    [Arguments]    ${entity_id}    ${expected_selected_sheets_count}
    [Documentation]    Check if the given number of sheets are selected.
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    ${expected_selected_sheets_count}: the number of expected selected sheets
    ...
    ...    *Return value*
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    ${selected_sheets_count}=    Set Variable    0
    @{sheet_names}=    Get Sheet Names    ${entity_id}
    : FOR    ${sheet_name}    IN    @{sheet_names}
    \    ${is_selected}=    Is Sheet Selected    ${entity_id}    ${sheet_name}
    \    ${upated_selected_sheets_count}=    Evaluate    ${selected_sheets_count}+1
    \    ${selected_sheets_count}=    Set Variable If    ${is_selected} == ${true}    ${upated_selected_sheets_count}    ${selected_sheets_count}
    Should Be Equal As Numbers    ${selected_sheets_count}    ${expected_selected_sheets_count}

Assert Single Pages Are Selected
    [Arguments]    ${entity_id}    ${expected_selected_pages_count}
    [Documentation]    Check if the given number of single pages are selected.
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    ${expected_selected_pages_count}: the number of expected selected pages
    ...
    ...    *Return value*
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    ${selected_pages_count}=    Set Variable    0
    @{page_indexes}    Get Single Page Indexes    ${entity_id}
    : FOR    ${page_index}    IN    @{page_indexes}
    \    ${is_selected}=    Is Single Page Selected    ${entity_id}    ${page_index}
    \    ${upated_selected_pages_count}=    Evaluate    ${selected_pages_count}+1
    \    ${selected_pages_count}=    Set Variable If    ${is_selected} == ${true}    ${upated_selected_pages_count}    ${selected_pages_count}
    Should Be Equal As Numbers    ${selected_pages_count}    ${expected_selected_pages_count}

Rotate Single Page
    [Arguments]    ${entity_id}    ${page_index}    ${clockwise}=${true}
    [Documentation]    Rotates a page of 90 degrees clockwise.
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    ${page_index}: the page index
    ...
    ...    ${clockwise}: by default is ${true}, set to ${false} for unti-clockwise
    ...
    ...    *Return value*
    ...
    ...    *Precondition*
    ...
    ...    *Example*
    Scroll single page into view    ${entity_id}    ${page_index}
    Comment    Click once to rotare clockwise
    Run Keyword If    ${clockwise} == ${true}    Click Element    ${entity_id}${single_page_rotate_tag}${page_index}
    Comment    Click 3 times to rotate anti-clockwise
    Run Keyword If    ${clockwise} == ${false}    Click Element    ${entity_id}${single_page_rotate_tag}${page_index}
    Run Keyword If    ${clockwise} == ${false}    Click Element    ${entity_id}${single_page_rotate_tag}${page_index}
    Run Keyword If    ${clockwise} == ${false}    Click Element    ${entity_id}${single_page_rotate_tag}${page_index}

Assert Single Page Rotation
    [Arguments]    ${entity_id}    ${page_index}    ${expected_rotation}
    [Documentation]    Check if a given page has the expected rotation set.
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    ${page_index}: the page index
    ...
    ...    ${expected_rotation}: the expected rotation in degress. It can be 0, 90, 180, or 270
    ...
    ...    *Return value*
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    ${matching_id_tag}=    Set Variable    ${entity_id}${single_page_id_tag}${page_index}
    ${matching_class_tag}    Set Variable    display-pages-rotation-${expected_rotation}
    ${status}    ${class_attribute}    Run Keyword And Ignore Error    IDBSSelenium2Library.Get Element Attribute    xpath=(//img[@id='${matching_id_tag}' and contains(@class, '${matching_class_tag}')])@class
    ${is_rotated}    Set Variable If    '${status}' == 'PASS'    ${true}    ${false}
    Should Be True    ${is_rotated}    Rotation class should be ${matching_class_tag}

Select Single Page
    [Arguments]    ${entity_id}    ${page_index}
    [Documentation]    Select a single page, is the page is already selected it then no action is performed
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    ${page_index}: the page index
    ...
    ...    *Return value*
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    ${is_selected}    Is Single Page Selected    ${entity_id}    ${page_index}
    ${image_id}    Set Variable    ${entity_id}${single_page_id_tag}${page_index}
    Run Keyword If    ${is_selected} == ${false}    Click Element    ${image_id}

Deselect Single Page
    [Arguments]    ${entity_id}    ${page_index}
    [Documentation]    Select a single page, is the page is already selected it then no action is performed
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    ${page_index}: the page index
    ...
    ...    *Return value*
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    ${is_selected}    Is Single Page Selected    ${entity_id}    ${page_index}
    ${image_id}    Set Variable    ${entity_id}${single_page_id_tag}${page_index}
    Run Keyword If    ${is_selected} == ${true}    Click Element    ${image_id}

Select Sheet
    [Arguments]    ${entity_id}    ${sheet_name}
    [Documentation]    Select a sheet, is the sheet is already selected it then no action is performed
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    ${sheet_name}: the sheet name
    ...
    ...    *Return value*
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    ${is_selected}    Is Sheet Selected    ${entity_id}    ${sheet_name}
    ${image_id}    Set Variable    ${entity_id}${sheet_id_tag}${sheet_name}
    Run Keyword If    ${is_selected} == ${false}    Click Element    ${image_id}

Get Selected Pages Indexes
    [Arguments]    ${entity_id}
    [Documentation]    Count how many selected pages are displayed in the Selected Pages Panel (the right side panel)
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    *Return value*
    ...
    ...    ${pages_count}: the number of displayed Single Pages
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    ${matching_tag}=    Set Variable    ${entity_id}${selected_single_page_id_tag}
    ${elements_count}=    IDBSSelenium2Library.Get Matching Xpath Count    //img[contains(@id, "${matching_tag}")]
    ${page_indexes}=    Create List
    : FOR    ${loop_index}    IN RANGE    1    ${elements_count}+1
    \    ${element_id}=    IDBSSelenium2Library.Get Element Attribute    xpath=(//img[contains(@id, '${matching_tag}')])[${loop_index}]@id
    \    ${page_index}=    String.Fetch From Right    ${element_id}    ${matching_tag}
    \    Append To List    ${page_indexes}    ${page_index}
    [Return]    ${page_indexes}    # The page indexes

Delete Selected Pages
    [Documentation]    Delete the selected pages from the selected pages panel
    ...
    ...    *Arguments*
    ...
    ...    *Return value*
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    Click Element    display-pages-selected-pages-panel-delete

Rotate Selected Pages
    [Arguments]    ${entity_id}
    [Documentation]    Rotate the selected pages from the selected pages panel
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    *Return value*
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    Click Element    display-pages-selected-pages-panel-rotate

Deselect Sheet
    [Arguments]    ${entity_id}    ${sheet_name}
    [Documentation]    Select a sheet, is the sheet is already selected it then no action is performed
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    ${sheet_name}: the sheet name
    ...
    ...    *Return value*
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    ${is_selected}    Is Sheet Selected    ${entity_id}    ${sheet_name}
    ${image_id}    Set Variable    ${entity_id}${sheet_id_tag}${sheet_name}
    Run Keyword If    ${is_selected} == ${true}    Click Element    ${image_id}

Select Selected Page
    [Arguments]    ${entity_id}    ${page_index}
    [Documentation]    Select a single page, is the page is already selected it then no action is performed
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    ${page_index}: the page index
    ...
    ...    *Return value*
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    ${is_selected}    Is Selected Page Selected    ${entity_id}    ${page_index}
    ${checkbox_unticked}    Set Variable    ${entity_id}${checkbox_unticked_id_tag}${page_index}
    Run Keyword If    ${is_selected} == ${false}    Click Element    ${checkbox_unticked}

Is Selected Page Selected
    [Arguments]    ${entity_id}    ${page_index}
    [Documentation]    Asses the select status of a selected page, which is a page shown in the selected pages panel    # ${true} if it's selected, ${false} otherwise
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    ${page_index}: the page index
    ...
    ...    *Return value*
    ...
    ...
    ...
    ...    *Precondition*
    ...
    ...    The pages panel must be already displayed
    ...
    ...    *Example*
    Comment    If the page is unselected, then the ticked checbox image must be invisible (display: none)
    ${matching_id_tag}=    Set Variable    ${entity_id}${checkbox_unticked_id_tag}${page_index}
    ${attribute_name}=    Set Variable    style
    ${attribute_value}=    Set Variable    display: none;
    ${status}    ${class_attribute}    Run Keyword And Ignore Error    IDBSSelenium2Library.Get Element Attribute    xpath=(//img[@id='${matching_id_tag}' and contains(@${attribute_name}, '${attribute_value}')])@${attribute_name}
    ${is_selected}    Set Variable If    '${status}' == 'PASS'    ${true}    ${false}
    [Return]    ${is_selected}    # ${true} if it's selected, ${false} otherwise

Scroll single page into view
    [Arguments]    ${entity_id}    ${page_index}
    [Documentation]    Scroll the single page into view
    ...
    ...    *Arguments*
    ...
    ...    ${entity_id}: the entity id
    ...
    ...    ${page_index}: the page index
    ...
    ...    *Return value*
    ...
    ...    *Precondition*
    ...
    ...    Page index must exist
    ...
    ...    *Example*
    ${page_id}=    Set Variable    ${entity_id}${single_page_id_tag}${page_index}
    Scroll Element Into View    ${page_id}

Setup test environment via SAPI
    [Arguments]    ${document to add}
    [Documentation]    Creates, via SAPI, a group, a project and an experiment with default names: (Group | Project | Experiment) -${TEST NAME}-${time}. Then it adds a document to the experiment and commit the experiment as DRAFT.
    ...
    ...    *Arguments*
    ...
    ...    ${number_of_pages_in_document} The number of pages in the document
    ...
    ...    ${document to add} The path to the document to add
    ...
    ...    *Return value*
    ...    A List of group id (at [0]), project if (at [1]), experiment id (at [2]), then the document id (at [3])
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    ${root_id}=    Set Variable    1
    ${group_id}=    EntityAPILibrary.Ensure Group Is Present    ${root_id}    EWB Web - Display pages
    @{suite_path}=    Split String From Right    ${SUITE NAME}    .
    ${actual_suite_name}=    Set Variable    @{suite_path}[-1]
    ${project_id}=    EntityAPILibrary.Ensure Project Is Present    ${group_id}    ${actual_suite_name}
    ${experiment_id}=    EntityAPILibrary.Create Experiment    ${project_id}    ${TEST NAME}
    EntityAPILibrary.Lock Entity    ${experiment_id}
    ${document_id}=    EntityAPILibrary.Create Generic Document    ${experiment_id}    ${document to add}
    EntityAPILibrary.Draft Save    ${experiment_id}
    EntityAPILibrary.Unlock Entity    ${experiment_id}
    @{ids}    Create List    ${group_id}    ${project_id}    ${experiment_id}    ${document_id}
    [Return]    ${ids}    # An array containing the group, project, experiment, and document ids

Display full content
    [Arguments]    ${document_to_add}    ${number_of_pages}
    [Documentation]    *Description*
    ...    This is for items that can only display all content or none at all i.e. do not trigger the page select dialog
    ...
    ...    *Arguments*
    ...
    ...    ${page_count} The number of pages in the document
    ...
    ...    ${document to add} The path to the document to add
    ...
    ...    *Return value*
    ...    The document entity id
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    @{ids}    Add create test experiment and add text file    ${document_to_add}
    Open Display Pages Plain Text
    ${entity_id}=    Set Variable    @{ids}[2]
    Wait Until Page Contains Element    //img[contains(@id, '-preview-')]
    Confirm all pages are displayed in experiment    ${entity_id}    ${number_of_pages}
    Version Save Record    ${ADMIN USER}    ${ADMIN PASSWD}    Data Added
    [Return]    ${entity_id}

Add create test experiment and add text file
    [Arguments]    ${document to add}
    [Documentation]    Creates, via SAPI, a group, a project and an experiment with default names: (Group | Project | Experiment) -${TEST NAME}-${time}. Then it adds a document to the experiment and commit the experiment as DRAFT. This is designed for Text Files and will NOT check for Display Pages Dialog or the number of pages
    ...
    ...    *Arguments*
    ...
    ...    ${number_of_pages_in_document} The number of pages in the document
    ...
    ...    ${document to add} The path to the document to add
    ...
    ...    *Return value*
    ...    A List of group id (at [0]), project if (at [1]), experiment id (at [2]), then the document id (at [3])
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    [Timeout]
    @{ids}=    Setup Experiment Path
    Add Plain Text File To Experiment    @{ids}[2]    ${CURDIR}${/}..${/}..${/}..${/}Test Data${/}Web Client${/}Display Page Test Data${/}Misc Files${/}Text File.txt
    ${web app url}=    Create webapp url    @{ids}[2]
    Open Browser    ${web app url}    ${BROWSER}
    Run Keyword And Ignore Error    Maximize Browser Window
    Log In Via Login Dialog    ${VALID USER}    ${VALID PASSWD}
    [Return]    @{ids}    # An array containing the group, project, experiment, and document ids

Open Display Pages Plain Text
    Open Document Header Tool Menu    0
    Robust Click    ewb-editor-command-edit-selected-previews

Setup Experiment Path
    [Documentation]    Creates, via SAPI, a group, a project and an experiment with default names: (Group | Project | Experiment) -${TEST NAME}-${time}.
    ...
    ...    *Arguments*
    ...
    ...    *Return value*
    ...    A List of group id (at [0]), project if (at [1]), experiment id (at [2])
    ...
    ...    *Precondition*
    ...    None
    ...
    ...    *Example*
    ${time}    Get Time
    ${root_id}=    Set Variable    1
    ${group_id}=    EntityAPILibrary.Ensure Group Is Present    ${root_id}    EWB Web - Display pages
    @{suite_path}=    Split String From Right    ${SUITE NAME}    .
    ${actual_suite_name}=    Set Variable    @{suite_path}[-1]
    ${project_id}=    EntityAPILibrary.Ensure Project Is Present    ${group_id}    ${actual_suite_name}
    ${experiment_id}=    EntityAPILibrary.Create Experiment    ${project_id}    ${TEST NAME}-${time}
    EntityAPILibrary.Lock Entity    ${experiment_id}
    EntityAPILibrary.Unlock Entity    ${experiment_id}
    @{ids}    Create List    ${group_id}    ${project_id}    ${experiment_id}
    [Return]    ${ids}    # An array containing the group, project, and experiment ids

Add Plain Text Item To Experiment
    [Arguments]    ${experiment_id}    ${data_file_location}    ${item_type}=Uploaded text document
    [Documentation]    Adds a html text item to the experiment and version save
    ...
    ...
    ...    *Arguments*
    ...
    ...    ${experiment_id} id of exp or record to put it in
    ...
    ...    ${data_file_location} \ where the data file is picked up
    ...
    ...    ${item_type} - optional, set to item type property to be displayed (can be anything you like, it doesn't have to be to dow ith file type etc)
    ...
    ...    *Return value*
    ...    Entity id of the document created
    ...
    ...    *Precondition*
    ...    Experiment must exist
    ...
    ...    *Example*
    ${text_doc_entity_id}=    Add TEXT_DOCUMENT To Experiment    ${experiment_id}    ${data_file_location}    text/plain    PLAIN_TEXT    ${item_type}
    [Return]    ${text_doc_entity_id}

Add TEXT_DOCUMENT To Experiment
    [Arguments]    ${experiment_id}    ${data_file_location}    ${mime type}    ${file type}    ${item_type}
    [Documentation]    Adds an item of specified type to the experiment and version save
    ...
    ...
    ...    *Arguments*
    ...
    ...    ${experiment_id} id of exp or record to put it in
    ...
    ...    ${data_file_location} \ where the data file is picked up
    ...
    ...    ${mime type} mime type to match the file
    ...
    ...    ${file type} EWB file type to match the file, e.g. PNG_IMAGE, JPG_IMAGE
    ...
    ...    ${item_type} - optional, set to item type property to be displayed (can be anything you like, it doesn't have to be to dow ith file type etc)
    ...
    ...    *Return value*
    ...    Entity id of the document created
    ...
    ...    *Precondition*
    ...    Experiment must exist
    ...
    ...    *Example*
    Lock Entity    ${experiment_id}
    ${doc_entity_id}=    Add TEXT_DOCUMENT With File Data    ${experiment_id}    ${data_file_location}    ${mime type}    ${file type}    ${item_type}
    Commit Versioned Entity    ${experiment_id}
    Unlock entity    ${experiment_id}
    [Return]    ${doc_entity_id}

Add Plain Text File To Experiment
    [Arguments]    ${experiment_id}    ${data_file_location}    ${item_type}=Uploaded text document
    [Documentation]    Adds a html text item to the experiment and version save
    ...
    ...
    ...    *Arguments*
    ...
    ...    ${experiment_id} id of exp or record to put it in
    ...
    ...    ${data_file_location} \ where the data file is picked up
    ...
    ...    ${item_type} - optional, set to item type property to be displayed (can be anything you like, it doesn't have to be to dow ith file type etc)
    ...
    ...    *Return value*
    ...    Entity id of the document created
    ...
    ...    *Precondition*
    ...    Experiment must exist
    ...
    ...    *Example*
    ${text_doc_entity_id}=    EntityAPILibrary.Create Generic Document    ${experiment_id}    ${data_file_location}
    [Return]    ${text_doc_entity_id}
