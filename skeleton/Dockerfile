FROM python:3

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN pip install .
VOLUME config

CMD [ "python", "/usr/local/bin/discover_mastodon_servers.py", "--config", "/config/config.conf" ]
