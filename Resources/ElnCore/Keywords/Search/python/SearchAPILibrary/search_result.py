import json
from JSONLibrary import JSONParse
from robot.api import logger


class SearchResult:

    def __init__(self):
        pass

    @staticmethod
    def _get_search_result_names(res):
        """
            parse JSON and return list of record's titles

            *Argument*

            res  - search result JSON
        """
        res = res.replace("/", "").replace("%", "")
        results = json.loads(res)
        names = []
        for result in results:
            names.append(JSONParse().get_json_string_value(result, "/IDBS-ApplicationsCoreBasicWith20Name#name"))

        return names

    @staticmethod
    def _get_search_count(res):
        return JSONParse().get_json_number_value(res, '/count')

    @staticmethod
    def _verify_search_result_data_by_names(res, expected_list):
        """
            verify that search result in res list is correct

            *Argument*
            res  - search result JSON

            expectedList - expected record's names
        """
        actualList = SearchResult._get_search_result_names(res)
        assert actualList == expected_list, \
            "Actual and expected list are not the same. Actual list is %s, expected list is %s" \
            % (actualList, expected_list)

    @staticmethod
    def _verify_search_result_blank(res):
        assert res == "[]", "Actual result is not blank, it is %s" % res

    @staticmethod
    def _verify_search_count(res, expected_number):
        actual_number = SearchResult._get_search_count(res)
        assert actual_number is int(expected_number), "actual search result count is %d, but expected is %d" % (
        actual_number, int(expected_number))
        return
