class SearchAPI:
    def __init__(self):
        pass

    ENTITY_LOCK_SERVICE_URL = '/ewb/services/1.0/data/jsonld'

    def _execute_search(self, request_payload):
        self._configure_request()
        self._set_authentication_credentials()
        self._set_json_request_headers()
        self.HTTPLib.HTTPLib.set_request_body(request_payload)
        self.HTTPLib.HTTPLib.POST(self.ENTITY_LOCK_SERVICE_URL)

        return self.HTTPLib.HTTPLib.get_response_body()