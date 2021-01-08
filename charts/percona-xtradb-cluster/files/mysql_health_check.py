import traceback
import os
import pymysql
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

os.environ["MYSQL_ROOT_PASSWORD"] = os.getenv("MYSQL_ROOT_PASSWORD", "")
MYSQL_ROOT_PASSWORD = os.environ["MYSQL_ROOT_PASSWORD"]


class MysqlHealthCheck(BaseHTTPRequestHandler):

    protocol_version = 'HTTP/1.1'

    def do_GET(self):
        db = None
        try:
            db = pymysql.connect("127.0.0.1", "root", MYSQL_ROOT_PASSWORD, "mysql")
            cursor = db.cursor()
            cursor.execute("show status like 'wsrep_local_state_comment';")
            data = cursor.fetchone()
            if data[1] != "Synced":
                raise Exception("Galera cluster not in Synced state, current state: {}".format(data[1]))

            cursor = db.cursor()
            cursor.execute("show status like 'wsrep_cluster_size';")
            data = cursor.fetchone()

            if data[1] == "1":
                raise Exception("wsrep_cluster_size is 1, it is must to be 1> ")

            message = "Synced"
            code = 200
        except:
            code = 500
            message = traceback.format_exc()
        finally:
            if db:
                db.close()

        self.send_response_only(code)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        self.wfile.write(bytes(message, "utf-8"))


def run():
    print('starting server...')
    server_address = ('0.0.0.0', 8081)
    server = ThreadingHTTPServer(server_address, MysqlHealthCheck)
    print('running server...')
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    server.server_close()


run()
