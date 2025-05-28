#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Setup script"""

import configparser
import setuptools

config = configparser.ConfigParser()
config.read('setup.cfg')

setuptools.setup(
    scripts=['__project_codename__/__project_codename__.py'],
    author="__author__",
    version=config['metadata']['version'],
    name=config['metadata']['name'],
    author_email="__author_email__",
    url="__url__",
    description="__description__",
    long_description="README.md",
    long_description_content_type="text/markdown",
    license="__license__",
    # keywords=["my", "script", "does", "things"]
)
