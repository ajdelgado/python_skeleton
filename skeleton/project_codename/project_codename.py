#!/usr/bin/env python3
# -*- encoding: utf-8 -*-
#
# This script is licensed under GNU GPL version 2.0 or above
# (c) __authoring_date__ __author__
"""__description__"""

import sys
import os
import json
import time
import logging
from logging.handlers import SysLogHandler
import click
import click_config_file
import yaml


HOME_FOLDER = os.environ.get('HOME', os.environ.get('USERPROFILE', '/'))
if HOME_FOLDER == '/':
    CACHE_FOLDER = '/var/cache'
    LOG_FOLDER = '/var/log/'
else:
    CACHE_FOLDER = f"{HOME_FOLDER}/.local/"
    LOG_FOLDER = f"{HOME_FOLDER}/log/"


class __project_codename_camel__:
    """__description__"""

    def __init__(self, **kwargs):
        self.config = kwargs
        if 'log_file' not in kwargs or kwargs['log_file'] is None:
            self.config['log_file'] = os.path.join(
                os.environ.get(
                    'HOME',
                    os.environ.get(
                        'USERPROFILE',
                        os.getcwd()
                    )
                ),
                'log',
                '__project_codename__.log'
            )
        self._init_log()
        self._default_data = {
            "last_update": 0,
        }
        self.data = self._read_cached_data()

    def close(self):
        '''Close class and save data'''
        self._save_cached_data(self.data)

    def _read_cached_data(self):
        if os.path.exists(self.config['cache_file']):
            with open(self.config['cache_file'], 'r', encoding='utf-8') as cache_file:
                try:
                    cached_data = json.load(cache_file)
                    if (
                        'last_update' in cached_data and
                        cached_data['last_update'] + self.config['max_cache_age'] > time.time()
                    ):
                        cached_data = self._default_data
                except json.decoder.JSONDecodeError:
                    cached_data = self._default_data
                return cached_data
        else:
            return self._default_data

    def _save_cached_data(self, data):
        data['last_update'] = time.time()
        with open(self.config['cache_file'], 'w', encoding='utf-8') as cache_file:
            json.dump(data, cache_file, indent=2)
        self._debug(
            f"Saved cached data in '{self.config['cache_file']}'",
        )

    def _output(self, message):
        if self.config['output_format'] == 'JSON':
            return json.dumps(message, indent=2)
        elif self.config['output_format'] == 'YAML':
            return yaml.dump(message, Dumper=yaml.Dumper)
        elif self.config['output_format'] == 'PLAIN':
            return f"{message}"
        else:
            self._log.warning(
                "Output format '%s' not supported",
                self.config['output_format']
            )
            return message

    def _info(self, message):
        return self._log.info(self._output(message))

    def _warning(self, message):
        return self._log.warning(self._output(message))

    def _error(self, message):
        return self._log.error(self._output(message))

    def _debug(self, message):
        return self._log.debug(self._output(message))

    def _init_log(self):
        ''' Initialize log object '''
        self._log = logging.getLogger("__project_codename__")
        self._log.setLevel(logging.DEBUG)

        sysloghandler = SysLogHandler()
        sysloghandler.setLevel(logging.DEBUG)
        self._log.addHandler(sysloghandler)

        streamhandler = logging.StreamHandler(sys.stdout)
        streamhandler.setLevel(
            logging.getLevelName(self.config.get("debug_level", 'INFO'))
        )
        self._log.addHandler(streamhandler)

        if 'log_file' in self.config:
            log_file = self.config['log_file']
        else:
            home_folder = os.environ.get(
                'HOME', os.environ.get('USERPROFILE', '')
            )
            log_folder = os.path.join(home_folder, "log")
            log_file = os.path.join(log_folder, "__project_codename__.log")

        if not os.path.exists(os.path.dirname(log_file)):
            os.mkdir(os.path.dirname(log_file))

        filehandler = logging.handlers.RotatingFileHandler(
            log_file, maxBytes=102400000
        )
        # create formatter
        formatter = logging.Formatter(
            '%(asctime)s %(name)-12s %(levelname)-8s %(message)s'
        )
        filehandler.setFormatter(formatter)
        filehandler.setLevel(logging.DEBUG)
        self._log.addHandler(filehandler)
        return True


@click.command()
@click.option(
    "--debug-level",
    "-d",
    default="INFO",
    type=click.Choice(
        ["CRITICAL", "ERROR", "WARNING", "INFO", "DEBUG", "NOTSET"],
        case_sensitive=False,
    ),
    help='Set the debug level for the standard output.'
)
@click.option(
    "--output-format",
    "-o",
    default="JSON",
    type=click.Choice(
        ["JSON", "YAML", "CSV", "PLAIN"],
        case_sensitive=False,
    ),
    help='Set the output format.'
)
@click.option(
    '--log-file',
    '-l',
    default=f"{LOG_FOLDER}/__project_codename__.log",
    help="File to store all debug messages."
)
@click.option(
    '--cache-file',
    '-f',
    default=f"{CACHE_FOLDER}/__project_codename__.json",
    help='Cache file to store data from each run',
)
@click.option(
    '--max-cache-age',
    '-a',
    default=60*60*24*7,
    help='Max age in seconds for the cache'
)
# @click.option("--dummy","-n", is_flag=True,
# help="Don't do anything, just show what would be done.")
@click_config_file.configuration_option()
def __main__(**kwargs):
    obj = __project_codename_camel__(**kwargs)
    obj.close()

if __name__ == "__main__":
    __main__()
