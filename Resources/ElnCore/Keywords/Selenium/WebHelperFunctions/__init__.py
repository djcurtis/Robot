from menu_helper_functions import MenuHelperFunctions
from download_helper_functions import DownloadHelperFunctions
from quantrix_lite_spreadsheet_helper_functions import SpreadsheetHelperFunctions

class WebHelperFunctions(MenuHelperFunctions, DownloadHelperFunctions, SpreadsheetHelperFunctions):
    """
    Additional helper functions for EWB Web testing
    """
    
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    
    pass

