from RestAPILibrary import RestApiLibrary
from robot.api import logger

from enums import SearchMatchMode
from json_creator import JsonCreator
from search_api import SearchAPI


class SearchAPIAdvanced(RestApiLibrary, SearchAPI):
    """
    Robot Framework Library for controlling the EWB Search Service
    NOTE: THIS LIBRARY USES A PRIVATE EWB REST SERVICE

    *Environment Variables*
    """

    def _execute_search_count(self, text, option=SearchMatchMode.MATCH_ALL, advanced_tiles=[]):
        request_json = JsonCreator.generate_count_json(text, option, advanced_tiles)
        logger.info("Executing count request: %s" % request_json)
        res_json = self._execute_search(request_json)
        logger.info("Search data result json in: %s " % res_json)
        return res_json

    def _execute_search_data(self, text, option=SearchMatchMode.MATCH_ALL, advanced_tiles=[]):
        request_json = JsonCreator.generate_request_json(text, option, advanced_tiles)
        logger.info("Executing search data request: %s" % request_json)
        res_json = self._execute_search(request_json)
        logger.info("Search data result json in: %s " % res_json)
        return res_json


