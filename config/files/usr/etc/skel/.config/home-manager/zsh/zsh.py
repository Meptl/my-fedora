# Call this file like so:
# python zsh.py FUNC_NAME ARGS...
import os
import subprocess
import sys
import shlex

def rgf(args):
    search = '*' + '*'.join(args) + '*'
    # No color because sometimes I pipe things.
    os.system(f'rg --color never --glob {search} --files')


def stamp(args):
    from datetime import datetime
    if not args:
        print(int(datetime.now().timestamp()))
        return
    for arg in args:
        try:
            print(datetime.utcfromtimestamp(int(arg)).strftime('%Y-%m-%d %H:%M:%S UTC'))
        except ValueError:
            parse_formats = [
                # Jun 25 2020 20:09
                '%b %d %Y %H:%M',
                # Thu, 25 Jun 2020 20:09:34 GMT
                '%a, %d %b %Y %H:%M:%S %Z',
                # 2021-01-14 19:08:10 UTC
                '%Y-%m-%d %H:%M:%S UTC',
            ]
            parsed = False
            for format in parse_formats:
                try:
                    print(int(datetime.strptime(arg.strip(), format).timestamp()))
                    parsed = True
                    break
                except ValueError:
                    pass
            if not parsed:
                print(f'Failed to parse: {arg}')

def vimfd(args):
    """Open vim for all files of an 'rg' command"""
    if len(args) < 1:
        print('USAGE: vimfd SEARCH')
        return 1
    search = os.popen('fd -H ' + ' '.join(args)).read()
    search = search.strip()
    if not search:
        return 0

    files = ' '.join(search.split('\n'))
    os.system(f'vim -p {files}')




def vimrg(args):
    """Open vim for all files of an 'rg' command"""
    # Although technically this is unneeded if we used argument based subprocess
    # commands, but I prefer the readability of os.system and the following
    # popen call.
    args = map(shlex.quote, args)
    # Note that because we are piping there is no easy way to see if the command failed.
    # This command will return lines fit for vim e.g. some/foo.txt:139
    search = os.popen("rg --vimgrep " + ' '.join(args) + " | awk -F: '{print $1\":\"$2}' | sort --unique --field-separator=: --key=1,1").read()
    search = search.strip()
    if not search:
        return 0


    # Goal from here is some vim command to open all files and navigate to the
    # relavant line. Some command like: vim -c ':edit file1|:3|:tabnew file2|:5'
    entries = map(lambda s: s.split(':'), search.split("\n"))
    vi_commands = []
    for i, entry in enumerate(entries):
        # Couldn't find a file name escaping tool. Because we are passing this
        # to vim it's not a simple shell escape.
        fname = entry[0].replace(' ', '\ ').replace('+', '\+')
        if i == 0:
            vi_commands.append(f':edit {fname}')
        else:
            vi_commands.append(f':tabnew {fname}')
        vi_commands.append(f':silent {entry[1]}')

    # 1gt to return to first tab.
    vi_command = '|'.join(vi_commands) + '|:normal 1gt'

    os.system(f'vim -c "{vi_command}"')


def unzip(args):
    for arg in args:
        extraction_dir = arg[:-4] if arg.endswith('.zip') else arg + '.d'
        subprocess.run(['unzip', '-d', extraction_dir, arg])


def sedrg(args):
    if len(args) < 2:
        print('USAGE: sedrg EXPR REPLACEMENT')
        return 1

    replacement = args[-1]
    search = args[-2]

    replacement.replace('/', '\\/')

    files = subprocess.run(['rg', '-l', *args[:-1]], text=True, capture_output=True)
    for f in files.stdout.split():
        os.popen("sed -i 's/" + search + '/' + replacement + "/g' " + f)


function_name = sys.argv[1]
locals()[function_name](sys.argv[2:])
