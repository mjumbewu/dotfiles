#!/usr/bin/env python3

# Usage: dcflower councilmatic

import sys
from subprocess import check_output, call

if __name__ == '__main__':
    app_name = sys.argv[1]

    env_bytes = check_output(['dotcloud', '--application', app_name, 'env', 'list'])
    env_str = env_bytes.decode('utf-8')
    env_vars = dict(line.split('=', 1) for line in env_str.split('\n') if line)

    print('Starting flower')
    call(['celery', 'flower', 
          '--broker', env_vars['DOTCLOUD_CACHE_REDIS_URL']])
