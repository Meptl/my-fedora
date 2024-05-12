# Design of this file is to `eval $(python THIS_FILE)`
import os
import sys

# This includes file name.
if len(sys.argv) < 2:
    print('git restore')
    exit(0)

staged = []
modified = []
for arg in sys.argv[1:]:
    stdout = os.popen(f'git status --porcelain {arg}').read()
    if not stdout:
        continue

    if stdout[0] != ' ':
      staged.append(arg)
    else:
      modified.append(arg)

if len(staged) > 0:
    print('git restore --staged ' + ' '.join(staged))
if len(modified) > 0:
    print('git restore ' + ' '.join(modified))
