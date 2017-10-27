*** Settings ***
Documentation     Instance OQ Test Suite
...
...               The instance OQ test specification, which is described below, is designed to test the high level
...               features of E-WorkBook Inventory and confirm that that the product is functional on the provided
...               infrastructure following installation and is behaving as expected. It is not designed to check all
...               in E-WorkBook Inventory since the complete application has gone through thorough testing as part of
...               the application's development. For further details regarding the application's development and
...               associated tests please see the separate SDLC procedures.
...
...               Prerequisites
...               This test is designed to be run on an E-WorkBook Inventory instance configured against an E-WorkBook
...               instance with no configuration changes from the installed product.
...               The test requires the following Office document to be used: Example Office Document.docx
...               If the document is not available, then prior to the test create a Word document called
...               "Example Office Document.docx" that contains the following text: "This is an example of an Office Document."
...
Suite Setup
Suite Teardown
Test Setup
Test Teardown
Force Tags
Library           IDBSSelenium2Library
Library           DateTime
Library           EntityAPILibrary
Library           TestDataGenerationLibrary
Library           ManualActionLibrary

#pybot -T -d results -i SMOKE "Tests/Business Scenarios/ELNCORE_OQ/IOQ-ELN.robot"

*** Variables ***


*** Test Cases ***




IOQ-INV-0: Execution Log
    [Documentation]
    ...
    [Tags]
    ${INV_INSTANCE_NAME}=    Get Value from User    Inventory Instance Name:    default
    ${EWB_INSTANCE_NAME}=    Get Value from User    E-WorkBook Instance Name:    default
    ${TESTED_BY}=    Get Value from User    Name of person performing test:    default
    ${INV_VERSION}=    Get Value from User    E-WorkBook version and build    default
    ${EWB_VERSION}=    Get Value from User    E-WorkBook version and build    default
    ${BROWSER_VERSION}=    Get Value from User    Browser and version used to perform test:    default

#######################################################################################################################
#          OQ Test SCRIPT PART 1 - E-WorkBook Inventory                                                               #
#                                                                                                                     #
#   This test is designed to be run on an E-WorkBook Inventory instance configured against an E-WorkBook instance     #
#   with no configuration changes from the installed product.                                                         #
#   The test requires the following Office document to be used: Example Office Document.docx                          #
#   If the document is not available, then prior to the test create a Word document called                            #
#   "Example Office Document.docx" that contains the following text: "This is an example of an Office Document."      #
#######################################################################################################################

IOQ-INV-1: An authenticated user with administrator permissions can access the application with appropriate credentials based on the authentication method being used.
    [Documentation]    Test successful login to the E-WorkBook Inventory web application:
    ...
    ...    Following correct user credentials being inserted a successful login occurs and the user is presented with the Search Inventory view.
    [Tags]
    Manual Action    Launch application
    Manual Action    Enter user credentials in logon dialog and press "sign-in."

IOQ-INV-2: Ability to add new types in E-WorkBook Inventory
    [Documentation]    User adds a new item type for equipment items called "OQ Test Type 1" within the system
    ...
    ...    Two item types are created with the names:
    ...         "OQ Test Type 1"
    ...         "OQ Test Type 2"
    ...    After each item type is created, a notification is displayed confirming the success of the action.
    [Tags]
    Manual Action    Select "Settings"
    Manual Action    Click "Acknowledge"
    manual action    Select "Create Item Type"
    manual action    Select "Item Type Name"
    manual action    Use the name "OQ Test Type 1"
    manual action    Select "Create Item Type"
    Manual Action    Select "Settings"
    Manual Action    Click "Acknowledge"
    manual action    Select "Create Item Type"
    manual action    Select "Item Type Name"
    manual action    Use the name "OQ Test Type 2"
    manual action    Select "Create Item Type"

IOQ-INV-3: Ability to create new inventory items in E-WorkBook Inventory
    [Documentation]    User adds an item of equipment called "OQ Test Item 1" within the system:
    ...
    ...    Three equipment items are created with the names:
    ...         "OQ Test Item 1"
    ...         "OQ Test Item 2"
    ...         "OQ Test Item 3"
    ...     After each equipment item is created, a notification is displayed confirming the success of the action.
    [Tags]
    Manual Action    Navigate back to the Search Inventory view by selecting the "Back to application" option
    Manual Action    Select "Add New..." and add an item of equipment called "OQ Test Item 1" within the system:
    Manual Action    Choose "Equipment"
    Manual Action    Select "Equipment Status" and Choose "Available"
    Manual Action    Select "Name" and enter the name "OQ Test Item 1"
    Manual Action    Select "Type" and Choose "OQ Test Type 1"
    Manual Action    Select "Create Equipment"
    Manual Action    Record date and time of test and the System ID value of "OQ Test Item 1".
    Manual Action    Select "Add New..." and add an item of equipment called "OQ Test Item 2" within the system:
    Manual Action    Choose "Equipment"
    Manual Action    Select "Equipment Status" and Choose "Available"
    Manual Action    Select "Name" and enter the name "OQ Test Item 2"
    Manual Action    Select "Type" and Choose "OQ Test Type 2"
    Manual Action    Select "Create Equipment"
    Manual Action    Record date and time of test and the System ID value of "OQ Test Item 2".
    Manual Action    Select "Add New..." and add an item of equipment called "OQ Test Item 3" within the system:
    Manual Action    Choose "Equipment"
    Manual Action    Select "Equipment Status" and choose Choose "Do Not Use"
    Manual Action    Select "Name" and enter the name "OQ Test Item 3"
    Manual Action    Select "Type" and Choose "OQ Test Type 3"
    Manual Action    Select "Create Equipment"
    Manual Action    Record date and time of test and the System ID value of "OQ Test Item 3".

IOQ-INV-4: Ability to search the items in the Search Inventory view by item metadata
    [Documentation]    User searches the displayed equipment items by the value "OQ Test Type 2"
    ...
    ...    The list of items displayed in the search contains only the following items:
    ...         "OQ Test Item 2"
    ...         "OQ Test Item 3"
    [Tags]
    Manual Action    Select "Search Equipment" and Enter "OQ Test Type 2"
    Manual Action    Press Enter

IOQ-INV-5: Ability to filter the items in the Search Inventory view by item metadata.
    [Documentation]    User searches the displayed equipment items by the value "Do Not Use":
    ...
    ...    The filter tags are displayed on the search page. The only item displayed in the search is "OQ Test Item 3".
    [Tags]
    Manual Action   Select "Filter Panel" and Choose "Do Not Use"

IOQ-INV-6: Ability to delete items from E-WorkBook Inventory
    [Documentation]    User deletes the item "OQ Test Item 3" from the system:
    ...
    ...    The item "OQ Test Item 3" is deleted from the application. The User is returned to the Search Inventory view.
    [Tags]
    Manual Action    Select "Option" and "Delete item"
    manual action    Click on "Delete"

IOQ-INV-7: Ability to edit an existing item in E-WorkBook Inventory
    [Documentation]    User edits the details of the item "OQ Test Item 1":
    ...
    ...    The updated name of "OQ Test Item 1 Edit" is displayed on the item card.
    ...    A notification is displayed confirming the success of this action.
    [Tags]
    Manual Action    Click on the pencil icon on the "OQ Test Item 1" card
    Manual Action    Select "Name" and Update the name to "OQ Test Item 1 Edit"
    Manual Action    Select "Save Equipment" and Record the date and time of the test.

IOQ-INV-8: Ability to view the item history for items in E-WorkBook Inventory
    [Documentation]    User is able to view the item history log:
    ...
    ...    History log opens and displays the history for "OQ Test Item 1 Edit".
    ...    There are entries in the history log for the following:
    ...
    ...    |Event                             |Username     |Date of Event |
    ...    |Name changed to:                  |             |              |
    ...    |OQ Test Item 1 Edit	              | <USERNAME>  |<DATE INV-7>  |
    ...    |Initial creation of OQ Test Item 1|             |              |
    ...    |Name: OQ Test Item 1              |             |              |
    ...    |Storage Location: No              |             |              |
    ...    |Type: Balance                     |             |              |
    ...    |Equipment Status: Available       |             |              |
    ...    |<USERNAME>	<DATE INV-3>          |             |              |
    ...
    ...    In all cases <USERNAME> should equal the username used during INV-1 step above.
    ...    In all cases <DATE INV-X> should equal the value inserted during the named step above.
    ...    The date and time entries for the items listed above are consistent with the times recorded as part of the test.
    [Tags]
    Manual Action   Select "Option" and Select "View history"

IOQ-INV-9: Create component links between items in E-WorkBook Inventory.
    [Documentation]    User creates a component link between “OQ Test Item 1” and “OQ Test Item 2”:
    ...
    ...    The Related Items tab is displayed. The table displays a link to “OQ Test Item 2” with a relationship of “Parent”.
    ...    A notification is displayed confirming the success of this action.
    [Tags]
    Manual Action    Select “Option” and Select “Link items”
    Manual Action    Select the input field and Enter the System ID of “OQ Test Item 2”.
    Manual Action    Click “Add” and Click “Create Links”

IOQ-INV-10: Ability to add attachments to an item record in E-WorkBook Inventory.
    [Documentation]    User adds the “Example Office Document.docx” as an attachment to the item record:
    ...
    ...    “Example Office Document.docx” is successfully added as an attachment to the item record.
    ...    A notification is displayed confirming the success of this action.
    [Tags]
    Manual Action    Select “Attachments” and Drag and drop “Example Office Document.docx” onto the highlighted area

IOQ-INV-11: Download and view attached documents in E-WorkBook Inventory.
    [Documentation]    User downloads the “Example Office Document.docx” file and opens it to view its contents:.
    ...
    ...    The word document is successfully downloaded.
    ...    The document contents appear exactly as when originally uploaded.
    [Tags]
    Manual Action    Select the “Example Office Document.docx” card and Select to open the downloaded file from the browser menu

#######################################################################################################################
#          OQ Test SCRIPT PART 2 - E-WorkBook Connection                                                              #
#                                                                                                                     #
#   This test is designed to be run on an E-WorkBook Inventory instance configured against an E-WorkBook instance     #
#   with no configuration changes from the installed product.                                                         #
#   The test requires the following E-WorkBook web spreadsheet document: IVM_Test.ewbss.                              #
#   An E-WorkBook experiment is created in the associated E-WorkBook instance called “Inventory OQ Test 1”.           #
#   An E-WorkBook experiment is created in the associated E-WorkBook instance called “Inventory OQ Test 2”. Within    #
#   this experiment the following steps must be performed:                                                            #
#           - Insert "IVM_Test.ewbss" into “Inventory OQ Test 2” and launch the Spreadsheet Designer.                 #
#           - Select the "Test Equipment Query" configuration on the Query tab of the Inventory panel.                #
#           - Set the Domain as ‘Equipment’ and the Type as ‘OQ Test Type 2’. Click Create background table.          #
#           - Select Back on the Inventory Panel and then select the Write tab.                                       #
#           - Select the "Test Equipment Write" configuration.                                                        #
#           - Set the Domain as ‘Equipment’ and the Type as ‘OQ Test Type 1’. Click Create write table.               #
#           - Save and close the Spreadsheet Designer.                                                                #
#           - Version save the experiment.                                                                            #
#######################################################################################################################


IOQ-INV-12: Automatic sign in to the associated E-WorkBook instance.
    [Documentation]    Test successful automatic sign in to E-WorkBook web application:
    ...
    ...    A successful sign in occurs without the need to re-enter user credentials. The user is presented with
    ...    the navigator view.
    [Tags]
    Manual Action    Open a new browser tab and Launch E-WorkBook


IOQ-INV-13: Ability to query inventory items into the E-WorkBook experiment.
    [Documentation]    User queries an item of Inventory from the E-WorkBook experiment:
    ...
    ...    The item details are displayed in the Inventory widget below the input field.
    ...    Selecting “OQ Test Item 1” displays an expanded set of information about the item, as entered in IOQ-INV-3.
    ...    The time and date are shown at the bottom of the dialog displaying the expanded set of item information. This
    ...    should match the time this test was performed.
    [Tags]
    Manual Action    Open the “Inventory OQ Test 1” experiment in E-WorkBook
    Manual Action    Insert item > Inventory item and Enter the System ID value for “OQ Test Item 1”
    Manual Action    Select apply
    Manual Action    Version save “Inventory OQ Test 1” experiment

IOQ-INV-14: Ability to query inventory items into the E-WorkBook web spreadsheet.
    [Documentation]    User queries an item of Inventory from the E-WorkBook experiment:
    ...
    ...    Equipment Query Table will be populated with the full set of information about the item, as entered in IOQ-INV-3.
    ...    The time and date are shown in the Query Time data dimension field. This should match the time this test was performed.
    [Tags]
    Manual Action    Open the “Inventory OQ Test 2” experiment in E-WorkBook
    Manual Action    Select to edit the spreadsheet Enter the System ID for “OQ Test Item 2” into the yellow highlighted cell
    Manual Action    Select Data > Inventory > Fetch data from Inventory.
    Manual Action    Record the date and time of the test.

IOQ-INV-15: Ability to write information on items into E-WorkBook Inventory from the E-WorkBook web spreadsheet.
    [Documentation]   User sends inventory item data from the E-WorkBook web spreadsheet to E-WorkBook Inventory to add a new item:
    ...
    ...    The link opens in a new browser tab to show the newly created "OQ Test Item 4" in E-WorkBook Inventory.
    ...    The registered details match the details recorded in the E-WorkBook web spreadsheet.
    [Tags]   TEST
    Manual Action    On the first row of the Test Equipment Write table enter the Equipment Status(1) as “Available”
    Manual Action    On the first row of the Test Equipment Write table enter the Name as “OQ Test Item 4”
    Manual Action    On the first row of the Test Equipment Write table enter Type as “OQ Test Type 1”
    Manual Action    On the first row of the Test Equipment Write table enter Conditional Write as “1” (note: this will auto-correct to ‘TRUE’)
    Manual Action    On the first row of the Test Equipment Write table Select Data > Inventory > Send changes to Inventory
    Manual Action    Select OK on the dialog confirming success in sending the data
    Manual Action    Select the Item Link hyperlink in the first row of the OQ Equipment Write table.

IOQ-INV-16: Confirming population of the item Usage Log from the E-WorkBook experiment.
    [Documentation]   User views the recorded usage for "OQ Test Item 1":
    ...
    ...    A reference to the experiment "Inventory OQ Test 1" is displayed.
    ...    The time documented against the reference matches the time recorded in test step IOQ-INV-13.
    [Tags]
    Manual Action    Return to E-WorkBook and save and close the Web Spreadsheet Editor.
    Manual Action    Version save Inventory OQ Test 2".
    Manual Action    Return to E-WorkBook Inventory search view.
    Manual Action    Click on "OQ Test Item 1" card and Select Usage Log

IOQ-INV-17: Confirming population of the item Usage Log from the E-WorkBook spreadsheet.
    [Documentation]    User views the recorded usage for "OQ Test Item 2":
    ...
    ...    A reference to the experiment "Inventory OQ Test 2" is displayed.
    ...    The time documented against the reference matches the time recorded in test step IOQ-INV-14.
    [Tags]
    Manual Action    Click on "OQ Test Item 2" card and select Usage Log


IOQ-INV-18: Ability to Sign Out from application
    [Documentation]  Perform a Sign Out event
    ...
    ...    User signs out of application and is presented with an acknowledgement that the sign off has occurred.
    [Tags]
    Manual Action    Select <User Name> on left bar and Select Sign Out





