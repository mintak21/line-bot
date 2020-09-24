import os

# Sever Socket
host = '0.0.0.0'  # Flaskは外部公開を許していないので、基本これ
port = os.getenv('PORT', 5000)

bind = str(host) + ':' + str(port)

# Debugging
reload = True

# Logging
accesslog = '-'
loglevel = 'info'

# Proc Name
proc_name = 'Line-Bot-Practice'

# Worker Processes
workers = 1
worker_class = 'sync'
