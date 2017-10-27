from robot.api import logger

from enums import SearchMatchMode
from global_vars import record_types, ancestral_types, document_types
from search_tiles import AdvancedSearchTile


class JsonCreator:
    def __init__(self):
        pass

    HINTS = '"hints":{"enableParallelQueryRunner":true,"enableFreeTextInEntityData":false,"enableFreeTextInAttributes":false,"enableUseGroupBy":true},'
    FILTER_TEMPLATE_ALL = '"filter": [{0}{1}]'
    FILTER_TEMPLATE_ANY = '"filter": [{0}[{1}]]'
    TEXT_TEMPLATE = '{{"@deep": {{"/System/Tuple#text": {{"likenocase": "{0}"}}}}}}'
    DEEP_TEMPLATE = '{{"@deep": {{{0}}}}}'
    CATALOG_JSON_TEMPLATE = '{{"@deep": {{"{0}#{1}":{{"{2}":{3}}}}}}}'
    DATA_JSON_TEMPLATE = '{{{0}{1},"limit": 26,"start": 0,"order": "/Flexible%20Hierarchy/Core/Entity#timestamp desc",' \
                         '"select": {{"@id": "@id","/System/Tuple#text": "/System/Tuple#text",' \
                         '"/System/Tuple#type": "/System/Tuple#type",' \
                         '"/IDBS-Applications/Core/Basic/With%20Name#name":' \
                         ' "/IDBS-Applications/Core/Basic/With%20Name#name",' \
                         '"/Flexible%20Hierarchy/Core/Entity#lastUpdater /Flexible%20Hierarchy/Security/User#name": ' \
                         '"/Flexible%20Hierarchy/Core/Entity#lastUpdater /Flexible%20Hierarchy/Security/User#name",' \
                         '"/Flexible%20Hierarchy/Core/Entity#path": "/Flexible%20Hierarchy/Core/Entity#path",' \
                         '"/Flexible%20Hierarchy/Core/Entity#timestamp": "/Flexible%20Hierarchy/Core/Entity#timestamp",' \
                         '"/Flexible%20Hierarchy/Core/Entity#uri": "/Flexible%20Hierarchy/Core/Entity#uri"}}}}'
    COUNT_JSON_TEMPLATE = '{{{0}{1}, "limit": 1001,"count": true}}'

    @staticmethod
    def generate_request_json(text, option, string_advances_tiles):
        advanced_tiles = JsonCreator._parse_string_tiles(string_advances_tiles)
        return JsonCreator.DATA_JSON_TEMPLATE.format(JsonCreator.HINTS, JsonCreator._generate_filter_json(text, option, advanced_tiles))

    @staticmethod
    def generate_count_json(text, option, string_advances_tiles):
        advanced_tiles = JsonCreator._parse_string_tiles(string_advances_tiles)
        return JsonCreator.COUNT_JSON_TEMPLATE.format(JsonCreator.HINTS, JsonCreator._generate_filter_json(text, option, advanced_tiles))

    @staticmethod
    def _parse_string_tiles(string_advanced_tiles):
        res = []
        for st in string_advanced_tiles:
            a = st.split("|")
            if len(a) is not 4:
                raise ValueError("Expected number of advanced search tile (%s) options should be %d, but was %d"
                                 % (st, 4, len(a)))
            else:
                adv = AdvancedSearchTile(a[0], a[1], a[2], a[3])
                if adv.navigator in record_types:
                    adv.deep_level = False
                res.append(adv)
        return res

    @staticmethod
    def _transform_record_tile_to_json(advanced_search_tile):
        res = ""
        if advanced_search_tile.property in ["createdTime", "timestamp"]:
            res = '{{"/Flexible%20Hierarchy/Core/{0}#Entity:{1}":{{"{2}": {3}}}}}'
        elif advanced_search_tile.property in ["comment", "tag"]:
            res = '{{"/Flexible%20Hierarchy/Solutions/{0}#Entity:{1}":{{"{2}": {3}}}}}'
        elif advanced_search_tile.property in ["reference", "keywords", "uniqueVisId"]:
            res = '{{"/Flexible%20Hierarchy/Solutions/{0}#{1}": {{"{2}": {3}}}}}'
        elif advanced_search_tile.property in ["creator", "lastUpdater"]:
            res = '{{"/Flexible%20Hierarchy/Solutions/{0}#Entity:{1}": ' \
                  '{{"/Flexible%20Hierarchy/Security/User#name": {{"{2}": {3}}}}}}}'
        elif advanced_search_tile.property in ["statusName"]:
            res = '{{"/Flexible%20Hierarchy/Solutions/{0}#{1}": ' \
                  '{{"/{0}%20Dictionaries/{0}%20Statuses#status":{{"{2}": {3}}}}}}}'
        elif advanced_search_tile.property in ["title"]:
            res = '{{"/Flexible%20Hierarchy/Solutions/{0}#{1}": ' \
                  '{{"/{0}%20Dictionaries/{0}%20Titles#title":{{"{2}": {3}}}}}}}'
        elif advanced_search_tile.property in ["versionType"]:
            res = '{{"/Flexible%20Hierarchy/Solutions/{0}#Entity:{1}": ' \
                  '{{"/Flexible%20Hierarchy/Core/Entity%20Version%20Type#name": {{"{2}": {3}}}}}}}'
        else:
            raise "property %s does not exist" % advanced_search_tile.property

        return res.format(advanced_search_tile.navigator, advanced_search_tile.property,
                          advanced_search_tile.operator, advanced_search_tile.value)

    @staticmethod
    def _transform_ancestral_tile_to_json(advanced_search_tile):
        res = ""
        if advanced_search_tile.property in ["name", "title"]:
            res = '"/Flexible%20Hierarchy/Solutions/{0}#{1}":{{"{2}":{3}}}'
        else:
            raise ValueError(
                "property %s does not exist in %s" % (advanced_search_tile.property, advanced_search_tile.navigator))

        return JsonCreator.DEEP_TEMPLATE.format(res.format(
            advanced_search_tile.navigator, advanced_search_tile.property,
            advanced_search_tile.operator, advanced_search_tile.value))

    @staticmethod
    def _transform_document_tile_to_json(advanced_search_tile):
        res = ""
        if advanced_search_tile.property in ["annotations", "caption", "itemType", "preregisteredids","registeredids",
                                             "signatureComment", "signatureCount"]:
            res = '"/Flexible%20Hierarchy/Solutions/{0}#{1}": {{"{2}": {3}}}'
        elif advanced_search_tile.property in ["comment", "tag"]:
            res = '"/Flexible%20Hierarchy/Solutions/{0}#Entity:{1}": {{"{2}": {3}}}'
        elif advanced_search_tile.property in ["publishingState"]:
            res = '"/Flexible%20Hierarchy/Solutions/{0}#{1}": ' \
                  '{{"/Experiment%20Dictionaries/Publishing%20Status#status": {{"{2}": {3}}}}}'
        elif advanced_search_tile.property in ["signatureReason"]:
            res = '"/Flexible%20Hierarchy/Solutions/{0}#{1}": ' \
                  '{{"/Experiment%20Dictionaries/Experiment%20Signoff%20Reasons#reason": {{"{2}": {3}}}}}'
        elif advanced_search_tile.property in ["signedOffBy"]:
            res = '"/Flexible%20Hierarchy/Solutions/{0}#{1}": ' \
                  '{{"/Flexible%20Hierarchy/Security/User#name": {{"{2}": {3}}}}}'
        elif advanced_search_tile.property in ["signedOffAt"]:
            res = '"/Flexible%20Hierarchy/Solutions/{0}#{1}": {{"{2}": {3}}}'
        elif advanced_search_tile.property in ["signedRole"]:
            res = '"/Flexible%20Hierarchy/Solutions/{0}#{1}": ' \
                  '{{"/Experiment%20Dictionaries/Task%20Roles#role": {{"{2}": {3}}}}}'
        else:
            raise ValueError("property %s does not exist in %s" %
                             (advanced_search_tile.property, advanced_search_tile.navigator))

        return JsonCreator.DEEP_TEMPLATE.format(res.format(
            advanced_search_tile.navigator, advanced_search_tile.property,
            advanced_search_tile.operator, advanced_search_tile.value))

    @staticmethod
    def _transform_catalog_tile_to_json(advanced_search_tile):
        return JsonCreator.CATALOG_JSON_TEMPLATE.format(advanced_search_tile.navigator, advanced_search_tile.property,
                                                        advanced_search_tile.operator, advanced_search_tile.value)

    @staticmethod
    def _generate_filter_json(text, option, advanced_tiles):
        st = st_text = ""
        if text not in (None, ""):
            st_text = JsonCreator._transform_text_to_json(text) + ","
        if advanced_tiles not in (None, ""):
            for advanced_tile in advanced_tiles:
                if advanced_tile.deep_level is False:
                    if advanced_tile.navigator in record_types:
                        st += JsonCreator._transform_record_tile_to_json(advanced_tile) + ","
                    else:
                        raise ValueError("There is no '%s' type supported by this library" % advanced_tile.navigator)
                else:
                    if advanced_tile.navigator in ancestral_types:
                        st += JsonCreator._transform_ancestral_tile_to_json(advanced_tile) + ","
                    elif advanced_tile.navigator in document_types:
                        st += JsonCreator._transform_document_tile_to_json(advanced_tile) + ","
                    elif advanced_tile.navigator[0] == "/":
                        st += JsonCreator._transform_catalog_tile_to_json(advanced_tile) + ","
                    else:
                        raise ValueError("There is %s type supported by this library" % advanced_tile.navigator)
        if option == SearchMatchMode.MATCH_ALL:
            return JsonCreator.FILTER_TEMPLATE_ALL.format(st_text, st)
        elif option == SearchMatchMode.MATCH_ANY:
            return JsonCreator.FILTER_TEMPLATE_ANY.format(st_text, st)
        else:
            raise ValueError("There is no search option '%s', available options are '%s':" % (option, str(SearchMatchMode())))

    @staticmethod
    def _transform_text_to_json(text):
        return JsonCreator.TEXT_TEMPLATE.format(text)
