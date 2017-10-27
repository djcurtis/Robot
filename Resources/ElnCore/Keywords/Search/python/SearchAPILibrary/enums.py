class Const(object):
    def __setattr__(self, name, value):
        raise self.ConstError, "Editing (%s) is not possible" %name

class SearchMatchMode(Const):
    MATCH_ALL = 'all'
    MATCH_ANY = 'any'
    MATCH_ALL_IN_RECORD = 'allinrecord'
    MATCH_ALL_IN_MEASURE = 'allinmeasure'

    def __str__(self):
        return self.MATCH_ALL + ", " + self.MATCH_ALL_IN_MEASURE+", "+self.MATCH_ANY+", "+self.MATCH_ALL_IN_RECORD

class FilterSections(Const):
    RECORD_TYPE = "/System/Tuple#type"
    LAST_EDITED_BY = "/Flexible%20Hierarchy/Core/Entity#lastUpdater"
    LAST_EDITED_DATE = "/Flexible%20Hierarchy/Core/Entity#timestamp"
    CREATED_BY = "/Flexible%20Hierarchy/Core/Entity#creator"
    CREATED_DATE = "/Flexible%20Hierarchy/Core/Entity#createdTime"
    STATUS = "/Flexible%20Hierarchy/Core/Record#statusName"
    VERSION = "/Flexible%20Hierarchy/Core/Entity#versionType"

