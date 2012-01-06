#!/usr/bin/env python

from distutils.core import setup
import glob
import os
from DistUtilsExtra.command import *

setup(name='clearcutter',
      version='0.1',
      description='ClearCutter Log Event Processor',
      author='Conrad Constantine',
      author_email='conrad@alienvault.com',
      url = 'http://http://code.google.com/p/alienvault-labs-garage/',
      py_modules = ['clusters'],
      scripts=[
               'clearcutter.py'
               ],
      cmdclass = { "build" : build_extra.build_extra}
      )
