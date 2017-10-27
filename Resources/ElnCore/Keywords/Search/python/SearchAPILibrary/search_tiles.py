
class AdvancedSearchTile:
    def __init__(self, navigator, property, operator, value):
        self.property = property
        self.navigator = navigator
        self.operator = operator
        self.value = value
        self.deep_level = True

    def __str__(self):
        return "property:%s, navigator:%s, operator:%s, value:%s, deep_level:%s" % (self.property, self.navigator, self.operator, self.value, self.deep_level)

class Filters(dict):
    def __init__(self, section_name, *values):
        self.section_name = section_name
        self.values = values