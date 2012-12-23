#!/usr/bin/env python3
#-*- coding:utf-8 -*-

"""
A utility to capture the manager subcommands from a given instance of
django-admin (i.e., manage.py). Used with tab completion.

Place this file somewhere on the executable PATH.
"""

from subprocess import check_output
from sys import argv

def main(admin_command):
    admin_command_output = check_output(admin_command)
    lines = admin_command_output.decode('utf-8').split('\n')

    collecting_commands = False
    trigger_string = 'Available subcommands:'
    commands = []

    for line in lines:
        line = line.strip()
        if not collecting_commands and line == trigger_string:
            collecting_commands = True
            continue

        if collecting_commands:
            if line.startswith('[') and line.endswith(']'):
                continue
            if len(line) == 0:
                continue

            commands.append(line)

    return sorted(commands)

if __name__ == '__main__':
    admin_command = argv[1]
    sorted_commands = main(admin_command)
    print(' '.join(sorted_commands))
    exit(0)
