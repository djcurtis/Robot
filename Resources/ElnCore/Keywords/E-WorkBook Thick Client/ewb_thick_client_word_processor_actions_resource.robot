*** Settings ***
Resource          ewb_thick_client_general_actions_resource.txt
Library           String
Library           ImageLibrary

*** Variables ***

*** Keywords ***
Activate text item for inline edit
    [Arguments]    ${document number}
    [Documentation]    Keyword actvates a specified text item for inline editing
    ...
    ...    *Arguments*
    ...
    ...    _document number_
    ...
    ...    is an integer number > 0. This is the position of the document in the record. It can vary depending on wether or not the record is saved prior to using this keyword
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    An open EWB text item has been selected
    ...
    ...    *Example*
    ...    | Activate text item for inline edit | ${document number} |
    ...
    ...    | Select Window | regexp=.*Word Processor |
    ...    | Activate text item for inline edit | 2 |
    ...    Selects the second text item and activates the content for editing inline
    Click On Component    xpath=//*[contains(@class,'ItemPanelWrapper')]//*[@name='htmlpane'][${document number}]    2

Active text item view contains
    [Arguments]    ${html fragment}
    [Documentation]    This keyword checks the current focused on *OPEN TEXT EDITOR* html and looks for the _html fragment_ you specify within the text item.
    ...
    ...    *Arguments*
    ...
    ...    _html fragment_
    ...
    ...    is the text you are searching for, this keyword returns the full html (including tags, headers, etc.) and searches within that html string for your specific html. Bold, italics, etc. can be searched for by including the relevant html tags in this variable
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Precondition*
    ...    An open EWB text item is selected
    ...
    ...    *Example*
    ...    | Active text item view contains | ${html fragment} |
    ...
    ...    | Select Window | regexp=.*Word Processor |
    ...    | Active text item view contains | Some <b>text</b> |
    ...    This searches the open editor for 'Some *text*'
    ${full html}=    Get Text Field Value    htmlpane
    Should Contain    ${full html}    ${html fragment}

Active text item view does not contain
    [Arguments]    ${html fragment}
    [Documentation]    This keyword checks the current focused on *OPEN TEXT EDITOR* html and looks for the _html fragment_ you specify within the text item. It passes if the fragment is NOT present.
    ...
    ...    *Arguments*
    ...
    ...    _html fragment_
    ...
    ...    is the text you are searching for, this keyword returns the full html (including tags, headers, etc.) and searches within that html string for your specific html. Bold, italics, etc. can be searched for by including the relevant html tags in this variable
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    Open EWB text item
    ...
    ...    *Example*
    ...    | Active text item view does not contain | ${html fragment} |
    ...
    ...    | Select Window | regexp=.*Word Processor |
    ...    | Active text item view does not contain | <b>IDBS</b> |
    ...    This confirms the open text item does not contain *IDBS*
    ${full html}=    Get Text Field Value    htmlpane
    Should Not Contain    ${full html}    ${html fragment}

Add text item table column
    [Documentation]    Keyword clicks on the insert column button on the toolbar.
    ...
    ...    Ensure that the mouse cursor is in one of the cells of the column you wish to add to before using this keyword.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    An EWB text item is open and selected, the item contains a table and the cursor is placed within the table (use Send Keyboard Event VK_LEFT etc. to move the cursor around the text item)
    ...
    ...    *Example*
    ...    | Select Window | regexp=.*Word Processor |
    ...    | Send Keyboard Event | VK_UP |
    ...    | Send Keyboard Event | VK_LEFT |
    ...    | Add text item table column | |
    Wait Until Keyword Succeeds    60    1    Focus To Component    class=HTMLPane
    Click on Component    Insert Column

Add text item table row
    [Documentation]    Keyword clicks on the insert row button on the toolbar.
    ...
    ...    Ensure that the mouse cursor is in one of the cells of the row you wish to add to before using this keyword.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    An EWB text item is open and selected, the item contains a table and the cursor is placed within the table (use Send Keyboard Event VK_LEFT etc. to move the cursor around the text item)
    ...
    ...    *Example*
    ...    | Select Window | regexp=.*Word Processor |
    ...    | Send Keyboard Event | VK_UP |
    ...    | Send Keyboard Event | VK_LEFT |
    ...    | Add text item table row | |
    Wait Until Keyword Succeeds    60    1    Focus To Component    class=HTMLPane
    Click on Component    Insert Row

Close E-WorkBook word processor
    [Documentation]    Keyword selects an open EWB Text Item and closes it without saving. It will fail if there are unsaved changes present.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Precondition*
    ...    An open EWB text item is present
    ...
    ...    *Example*
    ...    | Select Window | regexp-.*Word Processor |
    ...    | Select from menu | File/Save |
    ...    | Close E-WorkBook word processor | |
    IDBSSwingLibrary.Select Window    regexp=.*Word Processor    120
    IDBSSwingLibrary.Close Window    regexp=.*Word Processor
    ${old_window_wait_timeout}=    Set Jemmy Timeout    WindowWaiter.WaitWindowTimeout    1
    Wait Until Keyword Succeeds    120 seconds    2 seconds    Window should not be open    regexp=.*Word Processor
    Set Jemmy Timeout    WindowWaiter.WaitWindowTimeout    ${old_window_wait_timeout}
    Select E-WorkBook Main Window

Close E-WorkBook word processor and action prompt
    [Arguments]    ${yes-no-cancel}
    [Documentation]    Keyword closes an open EWB word processor *WITH UNSAVED CHANGES* and waits for the save prompt to appear. It then selects yes, no or cancel on the dialog prompt.
    ...
    ...    *Arguments*
    ...
    ...    _yes-no-cancel_
    ...
    ...    which of the three options on the prompt is desired. Only accepts (case sensitive!) Yes, No or Cancel.
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Precondition*
    ...    A single EWB text item is open and it contains unsaved changes
    ...
    ...    *Example*
    ...    | Close E-WorkBook word processor and action prompt | ${yes-no-cancel} |
    ...    | Close E-WorkBook word processor and action prompt | No | | | |
    ...    | Wait Until Keyword Suceeds | 30s | 1s | Select Window | IDBS E-WorkBook - Workbook Editor |
    ...    _this closes the open text item, discards the changes and reselects the E-WorkBook window_
    Select Window    regexp=.*Word Processor    120
    Close Window    regexp=.*Word Processor
    Select Dialog    Unsaved Changes    30
    Push Button    text=${yes-no-cancel}
    Wait Until Keyword Succeeds    120 seconds    1s    Window should not be open    regexp=.*Word Processor

Create new autotext
    [Arguments]    ${autotext name}    ${autotext content}
    [Documentation]    Opens the autotext manager using the Open autotext manager keyword and then creates a new autotext item with _autotext name_ and _autotext content_ supplied by the user
    ...
    ...    *Arguments*
    ...
    ...    _autotext name_
    ...
    ...    the name of the autotext item
    ...
    ...    _autotext content_
    ...
    ...    the content of the autotext, should be inserted as html (tags for formatting etc.)
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    An open EWB text item is selected
    ...
    ...    *Example*
    ...    | Create new autotext | ${autotext name} | ${autotext content} |
    ...    | Select Window | regexp=.*Word Processor |
    ...    | Create new autotext | createName | <b>createContent<b/> |
    Open autotext manager
    sleep    2
    Push Button    AddAutoTextButton
    Select Dialog    New AutoText    30
    Insert Into Text Field    class=JStringField    ${autotext name}
    Focus To Component    class=HTMLPane
    Insert Into Text Field    class=HTMLPane    ${autotext content}
    Push Button    OK
    Select Dialog    AutoText Manager...    30

Decrease text item indent
    [Documentation]    Clicks on the decrease indent button on the text editor toolbar
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    Open EWB text editor selected
    ...
    ...    *Example*
    ...    | Select Window | regexp=.*Word Processor |
    ...    | Decrease text item indent | |
    Click On Component    Decrease Indent

Delete extant autotext
    [Arguments]    ${position in table}    ${Yes or No}
    [Documentation]    Deletes an autotext item from the AutoText Manager dialog
    ...
    ...    *Arguments*
    ...
    ...    _position in table_
    ...
    ...    the position of the autotext you wish to delete, the list is an index the first item = 0, second = 1, etc. Only accepts integer numbers.
    ...
    ...    _Yes or No_
    ...
    ...    a dialog pops up asking to confirm deletion, press the Yes or No buttons, only accepts (case sensitive) Yes or No.
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    the AutoText Manager dialog is open and there is at least one autotext in the list to select
    ...
    ...    *Example*
    ...    | Delete extant autotext | ${position in table} | ${Yes or No} |
    ...    | Delete extant autotext | 1 | Yes |
    ...    This will delete the first configured autotext in the left hand panel of the dialog
    ...
    ...    *NOTE*
    ...    The numbers of each item in the dialog change as each item prior is deleted. E.g.:
    ...    name1
    ...    name2
    ...    name3
    ...
    ...    If you use
    ...    | Delete extant autotext | 1 | Yes |
    ...    You will delete name1 as it is position 1. name2 then becomes position 1
    ...
    ...    Thus if you have the list
    ...    name1
    ...    name2
    ...    name3
    ...
    ...    and use
    ...
    ...    | Delete extant autotext | 1 | Yes |
    ...    | Delete extant autotext | 2 | Yes |
    ...    you will end up with
    ...    name2 as the only remainign value in the list
    Select Dialog    AutoText Manager...
    Select Table Cell    class=JStripedTable    ${position in table}    0
    Push Button    DeleteAutoTextButton
    Select Dialog    Delete AutoText    30
    Push Button    text=${Yes or No}
    Select Dialog    AutoText Manager...    30

Edit current autotext
    [Arguments]    ${position in table}    ${new autotext name}    ${new autotext content}
    [Documentation]    Edits an extant autotext item with _new autotext name_ and _new autotext content_ supplied by the user.
    ...
    ...    *Arguments*
    ...
    ...    _position in table_
    ...
    ...    the position of the autotext you wish to edit in the left hand panel, integer number, this is an index so the 1st item in th elist is 0, second is 1, etc.
    ...
    ...    _new autotext name_
    ...
    ...    the name of the autotext item
    ...
    ...    _new autotext content_
    ...
    ...    the content of the autotext, should be inserted as html (tags for formatting etc.)
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    the autotext manager dialog is already open and there is at least one autotext item to edit
    ...
    ...    *Example*
    ...    | Edit current autotext | ${position in table} | ${new autotext name} | ${new autotext content} |
    ...    | Open autotext manager | | | |
    ...    | Edit current autotext | 1 | newName | newContent |
    Select Dialog    AutoText Manager...
    Select Table Cell    class=JStripedTable    ${position in table}    0
    Push Button    EditAutoTextButton
    Select Dialog    Edit AutoText    30
    Insert Into Text Field    class=JStringField    ${new autotext name}
    Focus To Component    class=HTMLPane
    Insert Into Text Field    class=HTMLPane    ${new autotext content}
    Push Button    OK
    Select Dialog    AutoText Manager...    30

Increase text item indent
    [Documentation]    Clicks on the increase indent button of the text editor toolbar
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    Open EWB text item selected
    ...
    ...    *Example*
    ...    | Select Window | regexp=.*Word Processor |
    ...    | Increase text item indent | |
    Click On Component    Increase Indent

Inline text item view contains
    [Arguments]    ${document number}    ${html fragment}
    [Documentation]    Keyword gets the text contained in an *INLINE TEXT ITEM* identified by _document number_ and checks that it contains _html fragment_
    ...
    ...    *Arguments*
    ...
    ...    _document number_
    ...
    ...    is an integer number > 0. This is the position of the document in the record. It can vary depending on wether or not the record is saved prior to using this keyword
    ...
    ...    _html fragment_
    ...
    ...    is the text you are searching for, this keyword returns the full html (including tags, headers, etc.) and searches within that html string. Bold, italics, etc. can be searched for by including the relevant html tags in this variable
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Precondition*
    ...    An open EWB record is selected and it contains at least one text item
    ...
    ...    *Example*
    ...    | Inline text item view contains | ${document number} | ${html fragment} |
    ...    | inline text item view contains | 1 | Some <b>text</b> |
    ...    this will search the first text item in the open record for 'Some *text*'
    ${text1}=    Get Text Field Value    xpath=//*[contains(@class,'ItemPanelWrapper')]//*[@name='htmlpane'][${document number}]
    Should Contain    ${text1}    ${html fragment}

Inline text item view does not contain
    [Arguments]    ${document number}    ${html fragment}
    [Documentation]    Keyword gets the text contained in an *INLINE TEXT ITEM* identified by _document number_ and checks that it does NOT contain _html fragment_
    ...
    ...    *Arguments*
    ...
    ...    _document number_
    ...
    ...    is an integer number > 0. This is the position of the document in the record. It can vary depending on wether or not the record is saved prior to using this keyword
    ...
    ...    _html fragment_
    ...
    ...    is the text you are searching for, this keyword returns the full html (including tags, headers, etc.) and searches within that html string. Bold, italics, etc. can be searched for by including the relevant html tags in this variable
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    EWB window selected
    ...
    ...    *Example*
    ...    | Inline text item view does not contain | ${document number} | ${html fragment} |
    ...
    ...    | Select Window | IDBS E-WorkBook - Workbook Editor | |
    ...    | Inline text item view does not contain | 1 | <b>IDBS</b> |
    ...    This confirms the first text item in the record does not contain *IDBS*
    ${text1}=    Get Text Field Value    xpath=//*[contains(@class,'ItemPanelWrapper')]//*[@name='htmlpane'][${document number}]
    Should Not Contain    ${text1}    ${html fragment}

Insert image into text editor
    [Arguments]    ${file path}
    [Documentation]    Keyword opens the menu and insert an image specified by _file path_ into the text item at the current cursor position
    ...
    ...    *Arguments*
    ...
    ...    _file path_
    ...
    ...    the correct filepath to the image you want to insert, it is recommended to the use '${CURDIR}' and a relative path
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    There is an open EWB text item
    ...
    ...    *Example*
    ...    | Insert name into text editor | ${file path} |
    ...    | Insert image into text editor | ${TEST DATA LOCATION}/png.png |
    Select Window    regexp=.*Word Processor    30
    Select From Menu    Insert|Insert Image...
    Select Dialog    Insert Image    30
    Push Button    text=Browse...
    Choose From File Chooser    ${file path}
    Push Button    okButton
    Select Window    regexp=.*Word Processor    30

Insert text item hyperlink
    [Arguments]    ${display text}=${EMPTY}    ${address text}=${EMPTY}    ${target frame}=${EMPTY}
    [Documentation]    Keyword clicks the insert hyperlink button on the toolbar and allows the user to insert values into the basic fields of the dialog or leave them blank. The more complicated hyperlink actions (screen tips, etc.) are not covered by this keyword
    ...
    ...    *Arguments*
    ...
    ...    _display text_
    ...
    ...    the text to assign to the display text field
    ...
    ...    _address text_
    ...
    ...    the value to type into the hyperlink address field
    ...
    ...    _target frame_
    ...
    ...    which target frame you wish to use from the drop down menu, accepts only the following values (case sensitive) [None], Same Frame, Whole Page, New Window, Parent Frame
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    Open EWB text item has been selected
    ...
    ...    *Example*
    ...    | Insert text item hyperlink | ${display text} | ${address text} | ${target frame} |
    ...
    ...    | Select Window | regexp=.*Word Processor | | |
    ...    | Insert text item hyperlink | Linkname | https://www.idbs.co.uk | ${EMPTY} |
    ...    | Push Button | jbtnOk | | |
    ...
    ...    To press the OK or Cancel buttons after using this dialog use the commands
    ...
    ...    Push Button jbtnOk
    ...    Push Button jbtnCancel
    Click On Component    Insert Hyperlink...
    Select Dialog    Insert Hyperlink    15
    Run Keyword If    '${display text}'!='${EMPTY}'    Insert Into Text Field    jtxtDisplayText    ${display text}
    Run Keyword If    '${address text}'!='${EMPTY}'    Insert Into Text Field    txtAddress    ${address text}
    Run Keyword If    '${target frame}'!='${EMPTY}'    Select From Combo Box    jComboTargetEditField    ${target frame}

Insert text item table
    [Arguments]    ${rows}=${EMPTY}    ${columns}=${EMPTY}    ${text alignment}=${EMPTY}    ${specify width}=${EMPTY}    ${table alignment}=${EMPTY}    ${width}=${EMPTY}
    ...    ${pixel}=${EMPTY}    ${border size}=${EMPTY}    ${cell padding}=${EMPTY}    ${space field}=${EMPTY}    ${ok or cancel}=${EMPTY}
    [Documentation]    Keyword opens the Insert Table dialog for the ewb text editor and then can be used to populate the fields by filling in the arguments.
    ...
    ...    This does not use the Background image or colour options.
    ...
    ...    *Arguments*
    ...
    ...    _rows_
    ...
    ...    the number to type into the rows box, integer values only
    ...
    ...    _columns_
    ...
    ...    the number to type into the columns box, integer values only
    ...
    ...    _text alignment_
    ...
    ...    the value to select from the text alignment drop down, accepts (case sensitive) Default, Left, Right and Center
    ...
    ...    _specify width_
    ...
    ...    any value typed here will deselect the checkbox
    ...
    ...    _table alignment_
    ...
    ...    the alignment of the table, accepts the (case sensitive) values Default, Left, Right and Center
    ...
    ...    _width_
    ...
    ...    an integer number to specify the width of table cells
    ...
    ...    _pixel_
    ...
    ...    any value typed here changes the width measure to pixels (it defaults to percent)
    ...
    ...    _border size_
    ...
    ...    an integer number to type into the border size field
    ...
    ...    _cell padding_
    ...
    ...    an integer number to type into the cell padding field
    ...
    ...    _space field_
    ...
    ...    an integer number to type into the cell spacing field
    ...
    ...    _ok or cancel_
    ...
    ...    case sensitive, only accepts ok or cancel values, this clicks on the button of the same name in the dialog
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    An EWB text item is open
    ...
    ...    *Example*
    ...    | Insert text item table | ${rows} | ${columns} | ${text alignment} | ${specify width} | ${table alignment} | ${width} | ${pixel} | ${border size} | ${cell padding} | ${space field} | ${ok or cancel} |
    ...    | Insert text item table | 3 | 5 | Right | ${EMPTY} | Center | 25 | ${EMPTY} | 1 | 1 | 1 | ok |
    Select Window    regexp=.*Word Processor    30
    sleep    2
    Select From Menu    Table|Insert Table...
    Select Dialog    Insert Table    30
    Run Keyword If    '${rows}'!='${EMPTY}'    Insert Into Text Field    rowField    ${rows}
    Run Keyword If    '${columns}'!='${EMPTY}'    Insert Into Text Field    colField    ${columns}
    Run Keyword If    '${text alignment}'!='${EMPTY}'    Select From Combo Box    textAlignBox    ${text alignment}
    Run Keyword If    '${specify width}'!='${EMPTY}'    Click On Component    jckboxWidth
    Run Keyword If    '${table alignment}'!='${EMPTY}'    Select From Combo Box    alignBox    ${table alignment}
    Run Keyword If    '${width}'!='${EMPTY}'    Insert Into Text Field    widthField    ${width}
    Run Keyword If    '${pixel}'!='${EMPTY}'    Click On Component    jbtnPixel
    Run Keyword If    '${border size}'!='${EMPTY}'    Insert Into Text Field    borderField    ${border size}
    Run Keyword If    '${cell padding}'!='${EMPTY}'    Insert Into Text Field    padField    ${cell padding}
    Run Keyword If    '${space field}'!='${EMPTY}'    Insert Into Text Field    spaceField    ${space field}
    Run Keyword If    '${ok or cancel}'=='ok'    Push Button    okButton
    Run Keyword If    '${ok or cancel}'=='cancel'    Push Button    cancelButton
    Run Keyword If    '${ok or cancel}'!='${EMPTY}'    Select Window    regexp=.*Word Processor    30

Open autotext manager
    [Documentation]    Opens the autotext manager and checks the dialog appears
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    A open EWB text item is selected
    ...
    ...    *Example*
    ...    | Select Window | regexp=.*Word Processor |
    ...    | Open autotext manager | |
    Select Window    regexp=.*Word Processor    60
    Click On Component    AutoText Manager...
    Select Dialog    AutoText Manager...    30

Open text editor insert symbol dialog
    [Documentation]    Opens the insert symbol dialog via the toolbar button and confirms the dialog appears
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    Open EWB text editor is selected
    ...
    ...    *Example*
    ...    | Select Window | regexp=.*Word Processor |
    ...    | Open text editor insert symbol dialog | |
    Select Window    regexp=.*Word Processor
    Click On Component    Insert Symbol...
    Select Dialog    Insert Symbol    60

Paste clipboard into word processor
    [Documentation]    Keyword selects an open EWB text item and pastes the data stored on the clipboard into the open editor via the Edit menu.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Precondition*
    ...    An open EWB text item is present and there is data already on the clipboard
    ...
    ...    *Example*
    ...    | Copy word document to clipboard | ${path}/word.docx |
    ...    | Paste clipboard to word processor | |
    Select Window    regexp=.*Word Processor
    ${original_text}=    Get Text Field Value    htmlpane
    ${original_length}=    Get Length    ${original_text}
    Select From Menu    Edit|Paste
    Sleep    1s    Give word_processeor time to update text panel.
    ${post_paste_text}=    Get Text Field Value    htmlpane
    ${post_paste_length}=    Get Length    ${post_paste_text}
    Check Number Does Not Equal    Check that the length of the text in the word processor has changed.    ${post_paste_length}    ${original_length}

Remove text item table column
    [Documentation]    Keyword clicks on the remove column button on the toolbar.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    An EWB text item is open and selected, the item contains a table and the cursor is placed within the table (use Send Keyboard Event VK_LEFT etc. to move the cursor around the text item)
    ...
    ...    *Example*
    ...    | Select Window | regexp=.*Word Processor |
    ...    | Send Keyboard Event | VK_UP |
    ...    | Send Keyboard Event | VK_LEFT |
    ...    | Remove text item table column | |
    Wait Until Keyword Succeeds    60    1    Focus To Component    class=HTMLPane
    Click on Component    Delete Column

Remove text item table row
    [Documentation]    Keyword clicks on the remove row button on the toolbar.
    ...
    ...    Ensure that the mouse cursor is in one of the cells of the row you wish to delete before using this keyword.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    An EWB text item is open and selected, the item contains a table and the cursor is placed within the table (use Send Keyboard Event VK_LEFT etc. to move the cursor around the text item)
    ...
    ...    *Example*
    ...    | Select Window | regexp=.*Word Processor |
    ...    | Send Keyboard Event | VK_UP |
    ...    | Send Keyboard Event | VK_LEFT |
    ...    | Remove text item table row | |
    Wait Until Keyword Succeeds    60    1    Focus To Component    class=HTMLPane
    Click on Component    Delete Row

Save and close word processor
    [Documentation]    Keywords selects, saves and then closes an open EWB text item.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Precondition*
    ...    An open EWB text item is present
    ...
    ...    *Example*
    ...    | Select Window | regexp-.*Word Processor |
    ...    | Save and close word processor | |
    Select Window    regexp=.*Word Processor
    Select From Menu    File|Save
    Sleep    3s    Give Word processor time to carry out save
    Close E-WorkBook word processor

Set text colour
    [Arguments]    ${button number}
    [Documentation]    Keyword clicks on the colour drop down and selects the colour identified by _button number_ from the drop down.
    ...
    ...    *Arguments*
    ...
    ...    _button number_
    ...
    ...    The number of the button of the colour you want to select, this will be between 0-69 inclusive.
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    Open EWB text item selected with some text highlighted
    ...
    ...    *Example*
    ...    | Set text colour | ${button number} |
    ...
    ...    | Select Window | regexp=.*Word Processor | |
    ...    | Select Text in Text Field | class=HTMLpane | IDBStext |
    ...    | Set text colour | 61 | |
    ...    This colours the text 'IDBStext' in the text editor red
    Click On Component    xpath=//*[@name='winEToolBar']/*[@name='Format']/*[@name='Color']
    Wait Until Keyword Succeeds    10    1    Click On Component    xpath=//*[contains(@class,'ColorPopupMenu')]/*[@name='button${button number}']

Set text highlight
    [Arguments]    ${button number}
    [Documentation]    Keyword clicks on the highlight drop down and selects the colour identified by *${button number}* from the drop down.
    ...
    ...    *Arguments*
    ...
    ...    _button number_
    ...
    ...    The number of the button of the colour you want to select, this will be between 0-69 inclusive.
    ...
    ...    Some common colours are
    ...    60 = dark red
    ...    61 = red
    ...    62 = orange
    ...    63 = yellow
    ...    64 = light green
    ...    65 = dark green
    ...    66 = light blue
    ...    67 = dark blue
    ...    68 = indigo
    ...    69 = purple
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    Open EWB text item selected with some text highlighted
    ...
    ...    *Example*
    ...    | Set text highlight | ${button number} |
    ...
    ...    | Select Window | regexp=.*Word Processor | |
    ...    | Select Text in Text Field | class=HTMLpane | IDBStext |
    ...    | Set text highlight | 61 | |
    ...    This highlights the text 'IDBStext' in the text editor red
    Click On Component    xpath=//*[@name='winEToolBar']/*[@name='Format']/*[@name='Highlight Color']
    Wait Until Keyword Succeeds    10    1    Click On Component    xpath=//*[contains(@class,'ColorPopupMenu')]/*[@name='button${button number}']

Set text item bulleted list
    [Documentation]    Presses on the bulleted list button on the EWB text item toolbar, turning it on or off.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    Open EWB text item selected
    ...
    ...    *Example*
    ...    | Select Window | regexp=.*Word Processor |
    ...    | Set text item bulleted list | |
    Click On Component    Unordered List

Set text item font
    [Arguments]    ${font name}
    [Documentation]    Keyword clicks on the font drop down and selects the font identified by _font name_ from the drop down list.
    ...
    ...    *Arguments*
    ...
    ...    _font name_
    ...
    ...    The case sensitive name of the font you wish to select
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    Open EWB text item selected with some text highlighted
    ...
    ...    *Example*
    ...    | Set text item font | ${font name} |
    ...
    ...    | Select Window | regexp=.*Word Processor | |
    ...    | Select Text in Text Field | class=HTMLpane | IDBStext |
    ...    | Set text item font | Batang | |
    ...    This sets the text 'IDBStext' in the text editor to Batang font
    Wait Until Keyword Succeeds    10    1    Select From Combo Box    xpath=//*[@name='winEToolBar']/*[@name='Format']/*[contains(@tooltip,'Font')]    ${font name}

Set text item numbered list
    [Documentation]    Presses on the numbered list button on the EWB text item toolbar, turning it on or off.
    ...
    ...    *Arguments*
    ...    None
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    Open EWB text item selected
    ...
    ...    *Example*
    ...    | Select Window | regexp=.*Word Processor |
    ...    | Set text item numbered list | |
    Click On Component    Ordered List

Set text item size
    [Arguments]    ${text size}
    [Documentation]    Keyword clicks on the size drop down and selects the size identified by _text size_ from the drop down list.
    ...
    ...    *Arguments*
    ...
    ...    _text size_
    ...
    ...    The size of the font you wish to select, must be a valid size from the list (i.e.: if list says 7pt, 12pt you can't select 10pt). Do NOT include the 'pt', simply type a number.
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    Open EWB text item selected with some text highlighted
    ...
    ...    *Example*
    ...    | Set text item size | ${text size} |
    ...
    ...    | Select Window | regexp=.*Word Processor | |
    ...    | Select Text in Text Field | class=HTMLpane | IDBStext |
    ...    | Set text item size | 12 | |
    ...    This sets the text 'IDBStext' in the text editor to 12pt font size
    Wait Until Keyword Succeeds    10    1    Select From Combo Box    xpath=//*[@name='winEToolBar']/*[@name='Format']/*[contains(@tooltip,'Size')]    ${text size}pt

Set text style
    [Arguments]    ${style}
    [Documentation]    Keyword clicks on the style drop down and selects the style identified by _style_ from the drop down list.
    ...
    ...    *Arguments*
    ...
    ...    _style_
    ...
    ...    The style you wish to select, must be a valid style from the list (case sensitive), the list is:
    ...
    ...    Remove Formatting;Paragraph Styles;p.null;h1.null;h2.null;h3.null;h4.null;h5.null;h6.null
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    Open EWB text item selected with some text highlighted
    ...
    ...    *Example*
    ...    | Set text style | ${style} |
    ...
    ...    | Select Window | regexp=.*Word Processor | |
    ...    | Select Text in Text Field | class=HTMLpane | IDBStext |
    ...    | Set text style | h1.null | |
    ...    This styles the text 'IDBStext' in the text editor to header 1
    Wait Until Keyword Succeeds    10    1    Select From Combo Box    xpath=//*[@name='winEToolBar']/*[@name='Format']/*[contains(@tooltip,'Style')]    ${style}

Start text item spellchecker
    [Documentation]    Opens the text item spellchecker
    ...
    ...    This keyword only opens the spellchecker it does not operate on it.
    ...
    ...    *Push Button* with:
    ...    ignoreButton
    ...    ignoreAllButton
    ...    addButton
    ...    changeButton
    ...    changeAllButton
    ...    suggestButton
    ...    undoButton
    ...    cancelButton
    ...
    ...    Also the fields
    ...    problemTextFld
    ...    changeToTextFld
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    Open EWB text item that contains some text
    ...
    ...    *Example*
    ...    | Select Window | regexp=.*Word Processor |
    ...    | Start text item spellchecker | |
    ...    | Push Button | ignoreButton |
    ...    | Push Button | changeButton |
    ...    | Push Button | cancelButton |
    ...
    ...    The names of the buttons and fields in the dialog are:
    ...
    ...    ignoreButton,
    ...    ignoreAllButton,
    ...    addButton,
    ...    changeButton,
    ...    changeAllButton,
    ...    suggestButton,
    ...    undoButton,
    ...    cancelButton
    ...
    ...    Also the fields
    ...
    ...    problemTextFld,
    ...    changeToTextFld
    Click on Component    Spelling...
    Select Dialog    Check Spelling    30

Use text editor find dialog
    [Arguments]    ${find text}=${EMPTY}    ${replace text}=${EMPTY}    ${case match}=${EMPTY}    ${complete word}=${EMPTY}
    [Documentation]    Keyword opens the text editor find dialog and either leaves it blank or, if desired the fields can be populated using the argument variables.
    ...
    ...    *Arguments*
    ...
    ...    _find text_
    ...
    ...    The text you want to type into the 'Find what' field
    ...
    ...    _replace text_
    ...
    ...    The text you want to type into the 'Replace with' field
    ...
    ...    _case match_
    ...
    ...    Type any value into this field (except ${EMPTY}) to check the checkbox
    ...
    ...    _complete word_
    ...
    ...    Type any value into this field (except ${EMPTY}) to check the checkbox
    ...
    ...    *Return Value*
    ...    None
    ...
    ...    *Preconditions*
    ...    Open EWB text item selected
    ...
    ...    *Example*
    ...    | Use text editor find dialog | ${find text} | ${replace text} | ${case match} | ${complete word} |
    ...
    ...    | Select Window | regexp=.*Word Processor | | | |
    ...    | Use text editor find dialog | IDBS | ${EMPTY} | true | ${EMPTY} |
    ...    | Push Button | findNextBtn | | | |
    ...
    ...    *NOTE*: If you want to populate one of the later fields but not one of the prior ones (e.g.: check the whole word checkbox but not the match case checkbox) then insert the ${EMPTY} variable into the cells you wish to leave blank when using the keyword.
    ...
    ...    *NOTE2*: Use the:
    ...    Push Button replaceBtn
    ...    Push Button replaceAllBtn
    ...    Push Button findNextBtn
    ...    Push Button cancelBtn
    Click On Component    Find...
    Select Dialog    Find    30
    Run Keyword Unless    '${find text}' == '${EMPTY}'    Insert Into Text Field    findText    ${find text}
    Run Keyword Unless    '${replace text}' == '${EMPTY}'    Insert Into Text Field    replaceText    ${replace text}
    Run Keyword Unless    '${case match}' == '${EMPTY}'    Click On Component    matchCaseCheckBox
    Run Keyword Unless    '${complete word}' == '${EMPTY}'    Click On Component    wholeWordCheckBox
