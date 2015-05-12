import os

BASEDIR = os.path.abspath(os.path.dirname(__file__))

# If BASE is https these has to be specified
SERVER_CERT = "%s/certificates/server.crt" % BASEDIR
SERVER_KEY = "%s/certificates/server.key" % BASEDIR
#CERT_CHAIN = None

CA_BUNDLE = None
VERIFY_SSL = False
