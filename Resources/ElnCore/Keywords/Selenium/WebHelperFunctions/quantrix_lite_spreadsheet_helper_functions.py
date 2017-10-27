'''
Created on 15 Jan 2014

@author: sjefferies
'''


from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
import time
from helper import SeleniumInstanceHelper

class SpreadsheetHelperFunctions:

    def __init__(self):
        self._selenium_instance = None  

    def select_cell_range(self, start_x, start_y, end_x, end_y):
        """
        Selects a cell range starting at cell (start_x,start_y) and ending at (end_x,end_y)
        """
        self._selenium_instance = SeleniumInstanceHelper()._get_selenium_instance()
        #click at start_x,start_y coordinates
        #self._selenium_instance.click_element("xpath=//*[@id='gwt-debug-cell{0},{1}']/../..".format(start_x,start_y))
        #hold shift and click at end_x,end_y coordinates
        try:
            start_cell = self._selenium_instance._element_find("xpath=//*[@id='gwt-debug-cell{0},{1}']/../..".format(start_y,start_x), True, True)
            end_cell = self._selenium_instance._element_find("xpath=//*[@id='gwt-debug-cell{0},{1}']/../..".format(end_y,end_x), True, True)
            ActionChains(self._selenium_instance._current_browser()).click_and_hold(start_cell).move_to_element(end_cell).release().perform()
        except:
            #Handle possible StaleElementReferenceException due to matrix reload on click
            time.sleep(1)
            start_cell = self._selenium_instance._element_find("xpath=//*[@id='gwt-debug-cell{0},{1}']/../..".format(start_y,start_x), True, True)
            end_cell = self._selenium_instance._element_find("xpath=//*[@id='gwt-debug-cell{0},{1}']/../..".format(end_y,end_x), True, True)
            ActionChains(self._selenium_instance._current_browser()).click_and_hold(start_cell).move_to_element(end_cell).release().perform()