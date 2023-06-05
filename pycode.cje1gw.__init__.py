#
# cje1gw - a gateway like reverse-proxy inspired by ngrok service
#	by saka@slis.tsukuba.ac.jp
#       $Id: __init__.py,v 2.0 2023/06/05 01:03:13 saka Exp $
#

from subprocess import Popen, PIPE
import atexit
import time
from wsgiref.simple_server import make_server, WSGIServer

user_host = "example@example.com"
id_rsa = "/root/.ssh/id_rsa-cje1"

def _test():
    print("This is a test.")
    print("$Id: __init__.py,v 2.0 2023/06/05 01:03:13 saka Exp $")

def _get_port_and_url():
    with Popen(["ssh", "-i", id_rsa, user_host, "port"], stdout=PIPE) as sp:
        status = sp.stdout.readline().strip()
        if status[0] != ord('+'):
            raise Exception('GET PORT', status)
        host = sp.stdout.readline().strip().decode('ascii')
        port = sp.stdout.readline().strip().decode('ascii')
    url = 'http://' + host + '.gw.example.com/'
    return (port, url)

def _run_gateway(src_port, port):
    forward = str(src_port) + ':127.0.0.1:' + str(port)
    gw = Popen(["ssh", "-N", "-R", forward, "-i", id_rsa, user_host])
    atexit.register(gw.terminate)

def run_with(app):
    old_run = app.run

    def new_run(*args, **kwargs):
        port = kwargs.get('port', 5000)
        host = kwargs.get('host', '127.0.0.1')
        src_port, url = _get_port_and_url()
        _run_gateway(src_port, port)
        time.sleep(1)
        print(f" * Running on {url}")
        WSGIServer.allow_reuse_address = True
        server = make_server(host, port, app)
        try:
            server.serve_forever()
        except KeyboardInterrupt:
            print("Detect KeyboardInterrupt. Stop.")
        finally:
            server.server_close()
    app.run = new_run

