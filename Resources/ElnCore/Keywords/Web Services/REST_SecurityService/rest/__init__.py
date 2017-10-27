############################################################################
#
# Copyright (C) 1993-2011 ID Business Solutions Limited
# All rights reserved
# 
# __init__.py
#
############################################################################

from config import settings
import urllib2


# Sets the password manager for each url request to ensure authentication 
# details are supplied
#passwordManager = urllib2.HTTPPasswordMgrWithDefaultRealm()

# The values to supply here are imported from config.settings
#passwordManager.add_password(None, settings['base_address'], settings['username'], settings['password'])
#handler = urllib2.HTTPBasicAuthHandler(passwordManager)
#opener = urllib2.build_opener(handler)

# Install the opener for all url requests
#urllib2.install_opener(opener)

