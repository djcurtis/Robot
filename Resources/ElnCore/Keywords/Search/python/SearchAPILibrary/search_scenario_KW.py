import string

from robot.api import logger

from search_result import SearchResult
from search_request import SearchAPIAdvanced




class SearchScenarioKW(SearchAPIAdvanced, SearchResult):

# free text search
    def execute_free_text_search_and_verify_data_by_name_and_count(self, text, expected_number, *expected_list):
        """
            1. execute free text search with no advanced search options

            2. verify result data by experiment's title

            3. verify result count be verifying count POST request

            *Arguments*

            text - text to search

            expectedNumber - expected result number is count query

            expectedList - list of expected record's  titles
        """
        res_data = self._execute_search_data(text)
        self._verify_search_result_data_by_names(res_data, list(expected_list))

        res_count = self._execute_search_count(text)
        self._verify_search_count(res_count, expected_number)

    def execute_free_text_search_and_verify_no_result(self, text):
        """
            1. execute free text search with no advanced search options

            2. verify result data is blank

            3. verify result count be verifying count POST request is 0

            *Arguments*

            text - text to search
        """
        res_data = self._execute_search_data(text)
        self._verify_search_result_blank(res_data)

        res_count = self._execute_search_count(text)
        self._verify_search_count(res_count, 0)

# search
    def execute_search_and_verify_no_result(self, text, option, *advanced_tiles):
        """
            1. execute search with text and advanced search options

            2. verify result data is blank

            3. verify result count

            *Arguments*

            text - text to search
            option - search option 'all' and 'any' options are supported
            advanced_tiles - list of advanced search tiles in following format:
            {navigator name}|{property name}|{operator}|{value}
            string value is advanced_tile should be in quotes. numbers should not be

            both catalog and navigator tiles should be taken from api requests
        """
        res_data = self._execute_search_data(text, option, advanced_tiles)
        self._verify_search_result_blank(res_data)

        res_count = self._execute_search_count(text, option, advanced_tiles)
        self._verify_search_count(res_count, 0)

    def execute_search_and_verify_data_name(self, expected_names, text, option, *advanced_tiles):
        """
            1. execute search with text and advanced search options

            2. verify result data is blank

            3. verify result count be verifying count POST request is 0

            *Arguments*

            expected_names - list of expected entity titles in following format:
            {entity1}|{entity2}|{entity3}|....

            text - text to search

            option - search option 'all' and 'any' options are supported

            advanced_tiles - list of advanced search tiles in following format:
            {navigator name}|{property name}|{operator}|{value}

            both catalog and navigator tiles should be taken from api requests
        """
        expected_list = string.split(expected_names, "|")
        res_data = self._execute_search_data(text, option, advanced_tiles)
        self._verify_search_result_data_by_names(res_data, expected_list)
        res_count = self._execute_search_count(text, option, advanced_tiles)
        self._verify_search_count(res_count, len(expected_list))

    def execute_search(self, text, option, *advanced_tiles):
        """
            execute search with text and advanced search options

            *Arguments*

            text - text to search
            option - search option 'all' and 'any' options are supported
            advanced_tiles - list of advanced search tiles in following format:
            {navigator name}|{property name}|{operator}|{value}
            string value is advanced_tile should be in quotes. numbers should not be

            both catalog and navigator tiles should be taken from api requests
        """
        return self._execute_search_data(text, option, advanced_tiles)

    def verify_search_result_data_by_names(self, res_json, *expected_list):
        """
            verify result data by experiment's title

            *Arguments*

            res_json - result search json

            expectedList - list of expected record's  titles
        """
        self._verify_search_result_data_by_names(res_json, list(expected_list))

