function re {
    if [ -z "$1" ]; then
        echo 'Available targets: h (home), s (nixos-switch), t (nixos-test)'
        return 1
    fi

    if [ "$1" = 's' ]; then
        # Ask for password now so it's not prompted later (hopefully)
        sudo true
        nixos-rebuild --use-remote-sudo switch "${@:2}"
    elif [ "$1" = 't' ]; then
        # Ask for password now so it's not prompted later (hopefully)
        sudo true
        nixos-rebuild --use-remote-sudo "${@:2}" test
    else
        echo 'Available targets: h (home), s (nixos-switch), t (nixos-test)'
        return 1
    fi
}

function nixsh {
    nix-shell -p $1 --run $1
}

function yes_or_no {
    while true; do
        read "?[y/n]: "
        case $REPLY in
            [Yy]*) return 0  ;;
            [Nn]*) return  1 ;;
        esac
    done
}

function loudly {
    $@
    mpv /etc/nixos/home/zsh/bell.oga &> /dev/null
}

function ocrsnap() {
    outfile=${1:-/tmp/ocrsnap.txt}
    if [[ $WAYLAND_DISPLAY ]]; then
        slurp | grim -g - /tmp/ocrsnap.tmp.png && tesseract --dpi 122 /tmp/ocrsnap.tmp.png $outfile
    else
        import /tmp/ocrsnap.tmp.png && tesseract --dpi 122 /tmp/ocrsnap.tmp.png $outfile
    fi

    mv $outfile.txt $outfile
    if [[ $WAYLAND_DISPLAY ]]; then
        wl-copy < $outfile
        wl-copy -p < $outfile
    else
        xclip < $outfile
        xclip -selection c < $outfile
    fi
    echo "Created $outfile. Also copied file to clipboard."
}

function vid2mp3() {
    ffmpeg -i $1 -vn -c:a libmp3lame -y $2
}

function flakeinit() {
    if [[ -z "$1" ]]; then
        cp -r /etc/nixos/home/zsh/flakeinit/default/{*,.*} .
    elif [[ "$1" -eq "python" ]]; then
        cp -r /etc/nixos/home/zsh/flakeinit/python/{*,.*} .
    else
        echo "Unknown template: $1"
        return 1
    fi
    git add flake.nix
    direnv allow .
}

function nix() {
    if [[ "$1" == "repl" ]]; then
        # But this doesn't support additional flags to nix repl.
        expect -c 'spawn nix repl; expect "nix-repl> "; send "flake = builtins.getFlake \"/etc/nixos\"\rpkgs = flake.inputs.nixpkgs\r"; interact'
    else
        command nix $@
    fi
}

function scr-cap() {
    outfile=${1:-/tmp/foo.png}
    if [[ $WAYLAND_DISPLAY ]]; then
        slurp | grim -g - $outfile
        wl-copy -t image/png < $outfile
    else
        import $outfile
        xclip -t image/png -selection c < $outfile
    fi
}


function scr-record() {
    mostRecentFile=$(ls -Art /home/yutoo/Kooha | tail -n 1)
    kooha
    newRecentFile=$(ls -Art /home/yutoo/Kooha | tail -n 1)
    if [[ $mostRecentFile == $newRecentFile ]]; then
        shotcut /home/yutoo/Kooha/$mostRecentFile
    fi
}
