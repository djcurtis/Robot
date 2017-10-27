*** Settings ***
Resource          ewb_thick_client_general_actions_resource.robot
Library           PyWinAutoLibrary
Library           String
Resource          ewb_thick_client_word_processor_actions_resource.robot
Library           CheckLibrary
Library           IDBSSwingLibrary
Library           RobotRemoteAgent
Library           ImageLibrary
Library           ClipboardLibrary

*** Keywords ***
Add File to current experiment
    [Arguments]    ${file_path}    ${caption}=${EMPTY}
    [Documentation]    Adds a file from the local file system as a new document item to the current experiment.
    ...
    ...    If needed, it can also change the cation of the new document item.
    ...
    ...    *Arguments*
    ...    _file_path_
    ...    The path to the file to add to the experiment as a document section.
    ...
    ...    _caption_
    ...    [optional] \ If specified the caption of the new document item will be set to the specified value.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab.
    ...
    ...    *Example*
    ...    | Add File to current experiment | C:/QTP Data/E-Workbook/Test Data/Basic Experiment Actions/Text_section.doc | |
    ...    | Add File to current experiment | C:/QTP Data/E-Workbook/Test Data/Basic Experiment Actions/Text_section.doc | New Text Section |
    Add File to current record entity    ${file_path}    ${caption}

Add File to current record entity
    [Arguments]    ${file_path}    ${caption}=${EMPTY}
    [Documentation]    Adds a file from the local file system as a new document item to the current experiment.
    ...
    ...    If needed, it can also change the cation of the new document item.
    ...
    ...    *Arguments*
    ...    _file_path_
    ...    The path to the file to add to the experiment as a document section.
    ...
    ...    _caption_
    ...    [optional] \ If specified the caption of the new document item will be set to the specified value.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab.
    ...
    ...    *Example*
    ...    | Add File to current experiment | C:/QTP Data/E-Workbook/Test Data/Basic Experiment Actions/Text_section.doc | |
    ...    | Add File to current experiment | C:/QTP Data/E-Workbook/Test Data/Basic Experiment Actions/Text_section.doc | New Text Section |
    Select from E-WorkBook Main Menu    Record    Insert Item...    Insert File    Other
    Choose From File Chooser    ${file_path}
    ${path}    ${extension}=    Split Extension    ${file_path}
    Run Keyword If    '${extension}'.upper()=='HTML'    Close E-WorkBook word processor
    Run Keyword If    '${extension}'.upper()=='BSS'    Close E-WorkBook spreadsheet
    Run Keyword If    '${extension}'.upper()=='CHEMBSS'    __Handle Resize stucture dialog
    Run Keyword If    '${extension}'.upper()=='CDX'    __Handle Resize stucture dialog
    Run Keyword If    '${extension}'.upper()=='SKC'    __Handle Resize stucture dialog
    Run Keyword If    '${extension}'.upper()=='TXT'    __Handle Select Item Type Format dialog
    Select E-WorkBook Main Window
    Run Keyword If    '${caption}'!='${EMPTY}'    Change Caption of last item panel    ${caption}

Add File to current report
    [Arguments]    ${file_path}    ${caption}=${EMPTY}
    [Documentation]    Adds a file from the local file system as a new document item to the current experiment.
    ...
    ...    If needed, it can also change the cation of the new document item.
    ...
    ...    *Arguments*
    ...    _file_path_
    ...    The path to the file to add to the experiment as a document section.
    ...
    ...    _caption_
    ...    [optional] \ If specified the caption of the new document item will be set to the specified value.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab.
    ...
    ...    *Example*
    ...    | Add File to current experiment | C:/QTP Data/E-Workbook/Test Data/Basic Experiment Actions/Text_section.doc | |
    ...    | Add File to current experiment | C:/QTP Data/E-Workbook/Test Data/Basic Experiment Actions/Text_section.doc | New Text Section |
    Add File to current record entity    ${file_path}    ${caption}

Add File to current template
    [Arguments]    ${file_path}    ${caption}=${EMPTY}
    [Documentation]    Adds a file from the local file system as a new document item to the current experiment.
    ...
    ...    If needed, it can also change the cation of the new document item.
    ...
    ...    *Arguments*
    ...    _file_path_
    ...    The path to the file to add to the experiment as a document section.
    ...
    ...    _caption_
    ...    [optional] \ If specified the caption of the new document item will be set to the specified value.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab.
    ...
    ...    *Example*
    ...    | Add File to current experiment | C:/QTP Data/E-Workbook/Test Data/Basic Experiment Actions/Text_section.doc | |
    ...    | Add File to current experiment | C:/QTP Data/E-Workbook/Test Data/Basic Experiment Actions/Text_section.doc | New Text Section |
    Add File to current record entity    ${file_path}    ${caption}

Change Caption of last item panel
    [Arguments]    ${caption}
    Focus to Component    class=ItemPanelWrapper
    Select from E-WorkBook Main Menu    Item    Properties.*
    Select Dialog    regexp=Properties.*
    Insert Into Text Field    xpath=//*[@name='caption_editor_textArea']//*[contains(@class,'JTextArea')]    ${caption}
    Push Button    OK
    Select E-WorkBook Main Window

Change caption of document in current experiment
    [Arguments]    ${item_type}    ${current_caption}    ${new_caption}
    ${panel_description}=    __Build document panel description and scroll to view    ${item_type}    ${current_caption}
    Focus to Component    ${panel_description}
    Select from E-WorkBook Main Menu    Item    Properties.*
    Select Dialog    regexp=Properties.*    5
    ${status}    ${value}=    Run Keyword And Ignore Error    Component Should Be Visible    xpath=//*[@GetName="OptionalAttributePanel"]//org.jdesktop.swingx.JXPanel
    Run Keyword if    '${status}'=='FAIL'    Click On Component    OptionalAttributePanel
    Sleep    5s
    Insert Into Text Field    xpath=//*[@name='caption_editor_textArea']//*[contains(@class,'JTextArea')]    ${new_caption}
    Push Button    OK
    Select E-WorkBook Main Window

Change item type of experiment item
    [Arguments]    ${current_item_type}    ${caption}    ${new_item_type}
    ${panel_description}=    __Build document panel description and scroll to view    ${current_item_type}    ${caption}
    Focus to Component    ${panel_description}
    Select from E-WorkBook Main Menu    Item    Properties.*
    Select Dialog    regexp=Properties.*
    Sleep    1s    Wait for animation
    ${status}    ${value}=    Run Keyword And Ignore Error    Component Should Be Visible    xpath=//*[@GetName="OptionalAttributePanel"]//org.jdesktop.swingx.JXPanel
    Run Keyword if    '${status}'=='FAIL'    Click On Component    OptionalAttributePanel
    Sleep    5s
    Scroll Component To View    itemType_editor
    Type Into Combobox    itemType_editor    ${new_item_type}
    Push Button    OK
    Select E-WorkBook Main Window

Check Marted Status for current document is as expected
    [Arguments]    ${expected_status}
    Select from E-WorkBook Main Menu    Item    Properties.*
    Select Dialog    regexp=Properties.*
    ${mart_status}=    Get Text Field Value    idbs:spreadsheet_mart_status
    Push Button    Cancel
    Select E-WorkBook Main Window
    Check String Equals    Check marted status is as expected.    ${mart_status}    ${expected_status}

Check document in current experiment has publishing state of
    [Arguments]    ${item_type}    ${caption}    ${expected_state}
    [Documentation]    Verifies that all the items in the currently open experiment have the expected publishing state.
    ...
    ...    The keyword will iterate over all the items in the current experiment and report all of them. If any have a publishing state that is not as expected, then it fails.
    ...
    ...    *Arguments*
    ...    _expected_state_
    ...    The expected publishing state
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab.
    ...
    ...    *Example*
    ...    | Check all items in current experiment have publishing state of | Published |
    Select E-WorkBook Main Window
    ${panel_description}=    __Build document panel description and scroll to view    ${item_type}    ${caption}
    Click On Component At Coordinates    ${panel_description}    30    30
    Select from E-WorkBook Main Menu    Item    Properties.*
    Select Dialog    regexp=Properties.*
    ${actual_publishing_state}=    Get Text Field Value    publishingState_editor_textField
    Check String Equals    Verify that item published state is as expected.    ${actual_publishing_state}    ${expected_state}
    Push Button    OK
    Select E-WorkBook Main Window

Check document in current experiment has signature
    [Arguments]    ${item_type}    ${caption}    ${reason}    ${username}    ${timestamp}    ${index}=1
    [Documentation]    Verifies that the all items in the currently open experiment have the expected signature.
    ...
    ...    The signature can appear either on the right or the left of the signature panel.
    ...
    ...    *Arguments*
    ...    _reason_
    ...    The expected sign-off reason
    ...
    ...    _username_
    ...    The expected sign-off username
    ...
    ...    _timestamp_
    ...    The expected sign-off timestamp. This needs to be with +/- 30 seconds of the actual timestamp being displayed to allow for differences in the client and server times as well as inaccuracies in capturing the time of an action.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab.
    ...
    ...    *Example*
    ...    | Check all items in current experiment have signature | reason=Experiment Completed | username=Biochem | timestamp=${signoff_timestamp} |
    Select E-WorkBook Main Window
    ${panel_description}=    __Build document panel description and scroll to view    ${item_type}    ${caption}
    Focus to Component    ${panel_description}
    Select Context    ${panel_description}
    ${sign_off_user}=    Get Text Field Value    SIGNOFF_INFO_USER_VALUE[${index}]
    ${sign_off_user}=    Evaluate    "${sign_off_user}".strip()
    Check String Equals    Verify signoff username for ${item_type}${caption}    ${sign_off_user}    ${username}
    ${sign_off_reason}=    Get Text Field Value    SIGNOFF_INFO_REASON_VALUE[${index}]
    ${sign_off_reason}=    Evaluate    "${sign_off_reason}".strip()
    Check String Equals    Verify signoff reason for ${item_type}${caption}    ${sign_off_reason}    ${reason}
    ${sign_off_timestamp}=    Get Text Field Value    SIGNOFF_INFO_TIMESTAMP_VALUE[${index}]
    ${sign_off_timestamp}=    Evaluate    "${sign_off_timestamp}".strip()
    ${sign_off_epoch}=    Evaluate    int(time.mktime(time.strptime("${sign_off_timestamp}","%d-%b-%Y %H:%M:%S")))    time
    ${timestamp_error}=    Evaluate    abs(${sign_off_epoch}-${sign_off_epoch})
    Check Number Is Less Than    Verify signoff time stamp is less than 30 seconds from expected value    ${timestamp_error}    30
    Select E-WorkBook Main Window

Check screenshot of document in current experiment
    [Arguments]    ${item_type}    ${caption}    ${expected_screenshot}
    [Documentation]    Saves a screenshot of the last itme in the current experiment to the specified file name.
    ...
    ...    The screenshot will be saved as a png file and added to the log output. The screenhsot is taken by the `Save last panel as image` keyword.
    ...
    ...    *Arguments*
    ...    _image_name_
    ...    The path and file name for the file to which the screenshot should be written.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab.
    ...    *In order to compare the imge files, the library uses the `Compare Images` keyword from the ImageLibrary which needs to be available.*
    ...
    ...    *Example*
    ...    | Check screenshot of last panel in experiment | c:/expected_screenshot.png |
    ${expected_screenshot_path}    ${expected_screenshot_file}=    Split Path    ${expected_screenshot}
    ${expected_screenshot_file_no_extension}    ${expected_screenshot_file_extension}=    Split Extension    ${expected_screenshot_file}
    ${actual_image}=    Save document as image    ${item_type}    ${caption}    ${expected_screenshot_file_no_extension}_actual.${expected_screenshot_file_extension}
    Crop Image    ${actual_image}    567    735
    Compare Images    ${actual_image}    ${expected_screenshot}    ${expected_screenshot_file_no_extension}_diff.${expected_screenshot_file_extension}

Check screenshot of open document
    [Arguments]    ${frame_name}    ${expected_screenshot}
    [Documentation]    Copies the content of an open window and saves it as a screenshot .png file, then compares the created file to an expected output file
    ...
    ...    *Arguments*
    ...
    ...    _frame name_
    ...
    ...    The name of the frame you wish to select
    ...
    ...    _image name_
    ...
    ...    The name of the image you wish to create should be
    ...
    ...    _expected screenshot_
    ...
    ...    The location and name of the expected output file to compare the screenshot to
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    An open program window
    ...
    ...    *Example*
    ...    | Check screen shot of open docuemt | ${frame name} | ${image name} | ${expected screenshot} |
    ...    | Check screenshot of open document | class=JRootPanel | ${TEST NAME}_actual.png | ${TEST DATA LOCATION}/${TEST NAME}_expected.png |
    ${expected_screenshot_path}    ${expected_screenshot_file}=    Split Path    ${expected_screenshot}
    ${expected_screenshot_file_no_extension}    ${expected_screenshot_file_extension}=    Split Extension    ${expected_screenshot_file}
    ${actual_image}=    Save open editor as image    ${frame_name}    ${expected_screenshot_file_no_extension}_actual.${expected_screenshot_file_extension}
    Compare Images    ${actual_image}    ${expected_screenshot}    ${expected_screenshot_file_no_extension}_diff.${expected_screenshot_file_extension}

Close "${window_title}" window
    [Documentation]    A keyword to close a top level window with a regexp window title of _window_title_. This window is treated as a generic Windows window.
    ...
    ...    *Arguments*
    ...    _window_title_
    ...    The regexp title of the window. This typically is the invariant part of the window that does not depend on the currently openned document.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    An open window with the specified regexp window title.
    ...
    ...    *Example*
    ...    | Close "Notepad" window |
    Generic Select Window    regexp=${window_title}
    # Sometimes the keyword times out
    Generic Close Selected Window

Copy Word Document to Clipboard
    [Arguments]    ${word_document}
    ${word_document}=    Normalize Path    ${word_document}
    Start Process    "${word_document}"
    ${path}    ${file}=    Split Path    ${word_document}
    ${file_name}    ${file_extension}=    Split Extension    ${file}
    Wait Until Keyword Succeeds    180s    5s    Generic Select Window    regexp=${file_name}.*Word
    Generic Set Focus to Selected Window
    Wait Until Keyword Succeeds    120s    5s    __Copy everything to clipboard
    ${clipboard_warning}    ${message}=    Run Keyword And Ignore Error    Generic Does Window Exist    Microsoft Word    timeout=5s
    Comment    Close down E-WorkBook
    Generic Send Keystrokes    %\{F4}
    Run Keyword If    '${clipboard_warning}'=='PASS'    Generic Select Window    Microsoft Word
    Run Keyword If    '${clipboard_warning}'=='PASS'    Generic Push Button    Yes

Copy document content to clipboard
    [Arguments]    ${document_path}    ${window_title}
    [Documentation]    Copies a document identified by _document path_ and copies the data from an open window identified by _window title_
    ...
    ...    *Arguments*
    ...
    ...    _document path_
    ...
    ...    The path to the document whose contents you wish to copy
    ...
    ...    _window title_
    ...
    ...    The title of the document when it is opened into whatever editor it uses
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    The file exists on a location the test runner can access (ideally using ${CURDIR} and a relative path)
    ...
    ...    *Example*
    ...    | Copy document content to clipboard | ${document path} | ${window title} |
    ...    | Copy document content to clipboard | ${TEST DATA LOCATION}/symbols.txt | regexp=.*Notepad |
    ${document_path}=    Normalize Path    ${document_path}
    Start Process    "${document_path}"
    ${path}    ${file}=    Split Path    ${document_path}
    ${file_name}    ${file_extension}=    Split Extension    ${file}
    Wait Until Keyword Succeeds    180s    5s    Generic Select Window    regexp=${window_title}
    Sleep    5s    Give Word time to open properly
    Generic Send Keystrokes    ^a
    Generic Send Keystrokes    ^c
    Generic Send Keystrokes    %\{F4}
    ${clipboard_warning}    ${message}=    Run Keyword And Ignore Error    Generic Does Window Exist    ${window_title}    timeout=5s
    Run Keyword If    '${clipboard_warning}'=='PASS'    Generic Select Window    ${window_title}
    Run Keyword If    '${clipboard_warning}'=='PASS'    Generic Push Button    Yes

Delete Document Item
    [Arguments]    ${Item_type}    ${current_caption}
    [Documentation]    Deletes document item
    ...
    ...    *Arguments*
    ...    _Item_type_
    ...    e.g Abstract or Dropped File - please include colon:
    ...    _current_caption_
    ...    Document caption
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This document item to be selected
    ...
    ...    *Example*
    ...    | Delete Document Item | ${Item_type} | ${current_caption} |
    ...    | Delete Document Item | Dropped File: | Image.png |
    ${panel_description}=    __Build document panel description and scroll to view    ${item_type}    ${current_caption}
    Focus to Component    ${panel_description}
    Click On Component At Coordinates    ${panel_description}    30    30
    Select from E-WorkBook Main Menu    Item    Delete.*
    Select Dialog    regexp=E-WorkBook    10
    Push Button    text=Yes
    sleep    5
    Select E-WorkBook Main Window

Display all pages for experiment item
    [Arguments]    ${item_type}    ${caption}    ${multiple pages}=${EMPTY}
    ${panel_description}=    __Build document panel description and scroll to view    ${item_type}    ${caption}
    Focus to Component    ${panel_description}
    Click On Component At Coordinates    ${panel_description}    100    30
    Select from E-WorkBook Main Menu    Item    Display Pages
    ${result}    ${message}=    Run Keyword And Ignore Error    Select Dialog    regexp=Select Display Pages.*    5
    Run Keyword If    '${result}'=='PASS'    __Select all pages in display pages dialog
    Run Keyword If    '${result}'=='FAIL' and '${multiple pages}'!='${EMPTY}'    Run Keyword And Continue On Failure    Fail    Display page dialog failed to open or appear
    Sleep    2s    Make sure the display process can get started
    Select E-WorkBook Main Window

Double-click on document in current experiment
    [Arguments]    ${item_type}    ${caption}
    ${panel_description}=    __Build document panel description and scroll to view    ${item_type}    ${caption}
    Focus to Component    ${panel_description}
    Click On Component At Coordinates    ${panel_description}    100    30    2

Draw something into sketch editor
    [Documentation]    This draws some random shapes into a currently open and active E-WorkBook sketch editor.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects a open sketch editor. That also implies an open E-WorkBook window with an experiment open and the current tab.
    ...
    ...    *Example*
    ...    | Draw something into sketch editor |
    Select Window    regexp=.*Sketch Tool
    Sleep    2s
    Click On Component    xpath=//menuitem[contains(.,'Drawing')]
    Click On Component    xpath=//menuitem[contains(.,'Rectangle')]
    Drag and drop Mouse On Component    class=SVGCanvas    30    30    100    100
    Click On Component    xpath=//menuitem[contains(.,'Drawing')]
    Click On Component    xpath=//menuitem[contains(.,'Ellipse')]
    Drag and drop Mouse On Component    class=SVGCanvas    150    100    200    300
    Click On Component    xpath=//menuitem[contains(.,'Drawing')]
    Click On Component    xpath=//menuitem[contains(.,'Circle')]
    Drag and drop Mouse On Component    class=SVGCanvas    75    90    250    400

Insert Chemistry Item
    [Arguments]    ${item_subtype}
    Insert new item using    Insert Chemistry    ${item_subtype}
    ${chemistry_error_dialog_is_open}    ${message}=    Run Keyword And Ignore Error    Select Dialog    Chemistry Error    2
    Run Keyword If    '${chemistry_error_dialog_is_open}'=='PASS'    Push Button    text=OK
    Select E-WorkBook Main Window

Insert Image into current experiment
    [Arguments]    ${file}    ${sub_type}    ${caption}=${EMPTY}
    Select from E-WorkBook Main Menu    Record    Insert Item...    Insert Image    ${sub_type}
    Choose From File Chooser    ${file}
    ${file_name}    ${path}=    Split Path    ${file}
    Select E-WorkBook Main Window
    Run Keyword If    '${caption}'!='${EMPTY}'    Change caption of document in current experiment    Image:    ${file_name}    ${caption}

Insert managed file set
    [Arguments]    ${file}    ${type}    @{attributes}
    [Documentation]    Adds a file from the local file system as a managed file set of the specified type. It also sets the attributes of the file set as specified by any optional keyword arguments.
    ...
    ...    *Arguments*
    ...    _file_
    ...    The path to the file to add to the experiment as a managed file set.
    ...
    ...    _type_
    ...    The managed file set type to selecty from the type dropdown in the meneged file set configuration dialog.
    ...
    ...    _@{attributes_
    ...    [optional] A list of attributes with their values in a [attribute name]=[value] format.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab. The specified managed file set type also needs to have been set up with the attributes specified in the attributes list.
    ...
    ...    *Example*
    ...    | Insert managed file set | C:/QTP Data/E-Workbook/Test Data/Basic Experiment Actions/Molbiol.JPG | Test fileset | test attribute=This is some text for the free text attribute |
    Select from E-WorkBook Main Menu    Record    Insert Item...    Insert Managed File Set
    Choose From File Chooser    ${file}
    Select Dialog    Managed File Set Type
    Select From Combo Box    image_types    ${type}
    ${field_index}=    Set Variable    1
    : FOR    ${attribute}    IN    @{attributes}
    \    ${attribute_name}    ${attribute_value}=    Split String    ${attribute}    =    1
    \    Insert Into Text Field    ${field_index}    ${attribute_value}
    \    ${field_index}=    Evaluate    ${field_index}+1
    Push Button    OK
    Select E-WorkBook Main Window

Insert new item using
    [Arguments]    ${item_type}    ${item_subtype}
    [Documentation]    Performs a click on the Record > _item_type_ > _item_subtype} menu in the E-WorkBook main window to create a new document in the current experiment.
    ...
    ...    *Arguments*
    ...    _item_type_
    ...    Item type in the Record menu.
    ...
    ...    _item_subtype_
    ...    Subtype for the item as it appears in the sub-menu that exists under the _item_type_.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab.
    ...
    ...    *Example*
    ...    | Insert new item using | Insert Sketch | Item Test |
    Select E-WorkBook Main Window
    Select from E-WorkBook Main Menu    Record    Insert Item...    ${item_type}    ${item_subtype}

Insert template into current record
    [Arguments]    ${path}
    Select E-WorkBook Main Window
    Select from E-WorkBook Main Menu    Record    Insert Template...
    Select Dialog    Select Template to Insert
    ${pipe_separated_path}=    Replace String    ${path}    /    |
    ${old_timeout}=    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    1
    Tree Node Should Exist    class=NavigatorTree    ${pipe_separated_path}
    Set Jemmy Timeout    JTreeOperator.WaitNextNodeTimeout    ${old_timeout}
    Click On Tree Node    class=NavigatorTree    ${pipe_separated_path}    1
    Push Button    OK
    Wait for glass pane to disappear

Insert web link as last item in experiment
    [Arguments]    ${url}    ${caption}=${EMPTY}
    Select E-WorkBook Main Window
    Select from E-WorkBook Main Menu    Record    Insert Item...    Insert Link    Web Link
    Select Dialog    E-WorkBook
    Insert Into Text Field    OptionPane.textField    ${url}
    Push Button    text=OK
    Select E-WorkBook Main Window
    Run Keyword If    '${caption}'!='${EMPTY}'    Change caption of document in current experiment    Web Link:    \    ${caption}

Open file in chemistry item
    [Arguments]    ${item_type}    ${caption}    ${chemistry_file}
    ${panel_description}=    __Build document panel description and scroll to view    ${item_type}    ${caption}
    Focus to Component    ${panel_description}
    Select Context    ${panel_description}
    Fail

Open item in current experiment with
    [Arguments]    ${item_type}    ${current_caption}    ${option}
    [Documentation]    This keyword clicks on the last item in the currently open experiment and uses the Item > Open With > ${option} menu item to open it.
    ...
    ...    *Arguments*
    ...    _option_
    ...    The display text of the option in the Open with menu to use.
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab.
    ...
    ...    *Example*
    ...    | Open last item in current experiment with | Send Test |
    ${panel_description}=    __Build document panel description and scroll to view    ${item_type}    ${current_caption}
    Focus to Component    ${panel_description}
    Select from E-WorkBook Main Menu    Item    Open with    ${option}

Save and close sketch editor
    [Documentation]    Closes an open sketch editor. If the "Save changes" dailog pops up, it clicks the yes button.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return value*
    ...    None
    ...
    ...    *Precondition*
    ...    This keyword expects a open sketch editor. That also implies an open E-WorkBook window with an experiment open and the current tab.
    ...
    ...    *Example*
    ...    | Save and close sketch editor |
    Select Window    regexp=.*Sketch Tool
    Close Window    regexp=.*Sketch Tool
    ${save_confirm_dialog_is_open}    ${message}=    Run Keyword And Ignore Error    Select Dialog    Confirmation...    2
    Run Keyword If    '${save_confirm_dialog_is_open}'=='PASS'    Push Button    text=Yes
    Sleep    2s    Give Sketch Tool time to carry out save
    Select E-WorkBook Main Window

Save document as image
    [Arguments]    ${item_type}    ${caption}    ${image_name}
    [Documentation]    Saves a screenshot of the last item in the current experiment to the specified file name in the output folder.
    ...
    ...    The screenshot will be saved as a png file and added to the log.
    ...
    ...    *Arguments*
    ...    _image_name_
    ...    The file name for the file to which the screenshot should be written.
    ...
    ...    *Return value*
    ...    _image_path_
    ...    The full path to the file to which the screenshot has been saved.
    ...
    ...    *Precondition*
    ...    This keyword expects an open E-WorkBook window with an experiment open and the current tab.
    ...
    ...    *Example*
    ...    | ${image_file}= | Save last panel as image | c:/screenshot.png |
    ${image_path}=    Set Variable    ${OUTPUT DIR}${/}${image_name}
    ${panel_description}=    __Build document panel description and scroll to view    ${item_type}    ${caption}
    Comment    Click on status bar to make sure that the cursor is not over any part of the experiment
    Move Cursor to Staus bar
    Save Component Screenshot    ${panel_description}    ${image_path}
    Log    Last panel in experiment is <img src="${image_path}" />    HTML
    [Return]    ${image_path}

Save open editor as image
    [Arguments]    ${frame_name}    ${image_name}
    ${image_path}=    Set Variable    ${OUTPUT DIR}${/}${image_name}
    Save Component Screenshot    ${frame_name}    ${image_path}
    Log    Last panel in experiment is <img src="${image_path}" />    HTML
    [Return]    ${image_path}

Wait for spreadsheet transform on document
    [Arguments]    ${item_type}    ${caption}    ${timeout}
    ${panel_description}=    __Build document panel description and scroll to view    ${item_type}    ${caption}
    Focus to Component    ${panel_description}
    Wait Until Keyword Succeeds    ${timeout}    20s    Check Marted Status for current document is as expected    AVAILABLE

__Build document panel description and scroll to view
    [Arguments]    ${item_type}    ${caption}
    ${panel_description}=    Set Variable If    ''=='${caption}'    xpathwithchildren=//*/component[contains(@class,'ItemPanelWrapper') and children/descendant::textcomponent[not(text())] and children/descendant::label/text()='${item_type}']    xpathwithchildren=//*/component[contains(@class,'ItemPanelWrapper') and children/descendant::textcomponent/text()='${caption}' and children/descendant::label/text()='${item_type}']
    Wait Until Keyword Succeeds    60s    5s    Scroll Component To View    ${panel_description}
    [Return]    ${panel_description}

__Copy everything to clipboard
    Empty Clipboard
    Generic Send Keystrokes    ^a
    Generic Send Keystrokes    ^c
    Check Clipboard Has Contents

__Handle Resize stucture dialog
    ${Status}    ${message}=    Run Keyword And Ignore Error    Select Dialog    regexp=.*Question.*    30
    Run Keyword If    '${Status}'=='PASS'    Push Radio Button    text=Resize Structure
    Run Keyword If    '${Status}'=='PASS'    Push Button    text=OK

__Handle Select Item Type Format dialog
    Select Dialog    Select Item Type Format    120
    Push Radio Button    PLAIN_TEXT
    Push Button    text=OK

__Select all pages in display pages dialog
    Select Dialog    regexp=Select Display Pages.*
    : FOR    ${index}    IN RANGE    200
    \    Push Button    text=Select current set
    \    ${more_pages}=    Component Is Enabled    NextPageButton
    \    Run Keyword If    not ${more_pages}    Exit For Loop
    \    Push Button    NextPageButton
    Push Button    text=OK
