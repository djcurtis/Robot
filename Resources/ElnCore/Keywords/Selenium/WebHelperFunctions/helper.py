from robot.libraries.BuiltIn import BuiltIn

class SeleniumInstanceHelper:
    
    def _get_selenium_instance(self):
        try:
            return BuiltIn().get_library_instance('IDBSSelenium2Library')
        except:
            BuiltIn.fail('Could not find IDBSSelenium2Library instance, is it imported?')    