import os
import version
from search_scenario_KW import SearchScenarioKW

THIS_DIR = os.path.dirname(os.path.abspath(__file__))
execfile(os.path.join(THIS_DIR, 'version.py'))


class SearchAPILibrary(SearchScenarioKW):
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    ROBOT_LIBRARY_VERSION = version.VERSION

    pass
