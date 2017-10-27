'''
Created on 22 Aug 2013

@author: sjefferies
'''

import time
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
from helper import SeleniumInstanceHelper

class MenuHelperFunctions:
    
    def __init__(self):
        self._selenium_instance = None  
    
    #EWB Menu Actions

    def select_from_EWB_menu(self, menu_option_text, *args):
        """
        Selects an option from an E-WorkBook Web menu.
        
        Can be used on any menu following the standard menu format used within EWB Web.
        
        NOTE: Simulates events using native events. Currently no fallback for browsers where native 
        events are not supported in WebDriver (i.e. Safari).
        
        *Arguments*
        - _menu_option_text_ - the top level menu option to click on (if no *args are specified) 
        or hover over (if *args are specified)
        - _*args_ - optional additional sub menu item text
        
        *Example*
        | Open Insert Menu |
        | Select From Menu | Insert File | Other |
        """
        self._selenium_instance = SeleniumInstanceHelper()._get_selenium_instance()
        prev_menu = menu_option_text
        self._selenium_instance.wait_until_page_contains_element('ewb-popup-menu')
        self._menu_select('ewb-popup-menu', menu_option_text)
        for arg in args:
            ActionChains(self._selenium_instance._current_browser()).send_keys(Keys.ARROW_RIGHT).perform()
            self._selenium_instance.wait_until_page_contains_element('xpath=//div[contains(@class, "x-menu-item-active")]/a[text()="{0}"]'.format(prev_menu))
            #self._ensure_menu_selected(prev_menu)
            prev_menu = arg
            menu_id = self._selenium_instance.get_element_attribute('xpath=//a[text()="{0}"]/../../..@id'.format(arg))
            self._sub_menu_select(menu_id, arg)
        self._selenium_instance.wait_until_page_contains_element('xpath=//div[contains(@class, "x-menu-item-active")]/a[text()="{0}"]'.format(prev_menu))
        ActionChains(self._selenium_instance._current_browser()).send_keys(Keys.RETURN).perform()

    def _ensure_menu_selected(self, menu_text, timeout=30):
        #checks a menu item is selected - private
        self._selenium_instance = SeleniumInstanceHelper()._get_selenium_instance()
        base_time = time.time()
        menu_selected = False
        while not menu_selected and (((time.time()-base_time) < timeout)):
            try:
                self._selenium_instance.wait_until_page_contains_element('xpath=//a[text()="{0}"]/..[contains(@class, "x-menu-item-active")]'.format(menu_text))
                menu_selected = True
            except:
                self._selenium_instance._info("RETRYING ELEMENT LOCATION")
        if not menu_selected:
            raise AssertionError('Menu item "{0}" not selected'.format(menu_text))

    def select_new_entity_type(self, creation_type_text, entity_type):
        """
        Selects a new entity type from the E-WorkBook Web popup menu
        
        | Open Tile Header Tool Menu  |  Administrators |
        | Select New Entity Type | Create New | Project |
        """
        self._selenium_instance = SeleniumInstanceHelper()._get_selenium_instance()
        self._menu_select('ewb-popup-menu', creation_type_text)
        ActionChains(self._selenium_instance._current_browser()).send_keys(Keys.ARROW_RIGHT).perform()
        if creation_type_text=='Use Record to Create':
            self._sub_menu_select('ewb-popup-menu-submenu-ewb-entity-menu-template', entity_type)
        else:
            self._sub_menu_select('ewb-popup-menu-submenu-ewb-entity-menu-new', entity_type)
        ActionChains(self._selenium_instance._current_browser()).send_keys(Keys.RETURN).perform()

    def _menu_select(self, menu_id, menu_option_text, load_timeout=30):
        """
        Selects a menu option
        """
        self._selenium_instance = SeleniumInstanceHelper()._get_selenium_instance()
        row_number = 0
        number_of_rows = 0
        base_time = time.time()
        while ((number_of_rows == 0) and ((time.time()-base_time) < load_timeout)):
            number_of_rows = self._selenium_instance.get_matching_xpath_count('//*[@id="{0}"]/div/div'.format(menu_id))
            time.sleep(1)
        self._selenium_instance._info("Number of menu elements = '%s'" % number_of_rows)
        for index in range(1, int(number_of_rows)+1):
            try:
                if self._selenium_instance.get_text('xpath=//*[@id="{0}"]/div/div[{1}]/a'.format(menu_id, index)) == menu_option_text:
                    row_number= index
                    self._selenium_instance._info("Row number = '%s'" % row_number)
            except ValueError:
                pass
        self._selenium_instance._info("Row number = '%s'" % row_number)
        for i in range(int(row_number)):
            ActionChains(self._selenium_instance._current_browser()).send_keys(Keys.ARROW_DOWN).perform()
 
    def _sub_menu_select(self, menu_id, menu_option_text, load_timeout=30):
        """
        Selects a sub-menu option
        
        SJ - Is this really needed? A sub-menu is just another menu...
        """
        self._selenium_instance = SeleniumInstanceHelper()._get_selenium_instance()
        row_number = 0
        number_of_rows = 0
        number_of_unselectable_rows = 0
        base_time = time.time()
        while ((number_of_rows == 0) and ((time.time()-base_time) < load_timeout)):
            self._selenium_instance._info("Counting number of menu elements")
            number_of_rows = int(self._selenium_instance.get_matching_xpath_count('//*[@id="{0}"]/div/div'.format(menu_id)))
            number_of_selectable_rows = self._selenium_instance.get_matching_xpath_count('//*[@id="{0}"]/div/div/a'.format(menu_id))
            number_of_unselectable_rows = int(number_of_rows) - int(number_of_selectable_rows)
            time.sleep(1)
        self._selenium_instance._info("Number of menu elements = '%s'" % number_of_rows)
        for index in range(1, int(number_of_rows)+1):
            try:
                if self._selenium_instance.get_text('xpath=//*[@id="{0}"]/div/div[{1}]'.format(menu_id, index)) == menu_option_text:
                    row_number= index
                    self._selenium_instance._info("Row number = '%s'" % row_number)
            except ValueError:
                pass
        row_number = row_number - number_of_unselectable_rows
        self._selenium_instance._info("Row number = '%s'" % row_number)
        for i in range(int(row_number)-1):
            ActionChains(self._selenium_instance._current_browser()).send_keys(Keys.ARROW_DOWN).perform()  
        
    def menu_click(self, menu_locator, menu_option):
        self._selenium_instance = SeleniumInstanceHelper()._get_selenium_instance()
        menu_elem = self._selenium_instance._element_find(menu_locator, True, True)
        self._selenium_instance._info("Opening Menu '%s'" % menu_locator)
        ActionChains(self._selenium_instance._current_browser()).move_to_element(menu_elem).perform()
        self._selenium_instance._info("Selecting Menu Option '%s'" % menu_option)
        ActionChains(self._selenium_instance._current_browser()).click(self._selenium_instance._element_find(menu_option, True, True)).perform()