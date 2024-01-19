#!/usr/bin/env python3
# -*- encoding: utf-8 -*-
#
# This script is licensed under GNU GPL version 2.0 or above
# (c) __authoring_date__ __author__
"""__description__"""

import sys
import os
import logging
from logging.handlers import SysLogHandler
import click
import click_config_file


class __project_codename_camel__:

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
@click.option('--log-file', '-l', help="File to store all debug messages.")
# @click.option("--dummy","-n", is_flag=True,
# help="Don't do anything, just show what would be done.")
@click_config_file.configuration_option()
def __main__(**kwargs):
    return __project_codename__(**kwargs)


if __name__ == "__main__":
    __main__()
