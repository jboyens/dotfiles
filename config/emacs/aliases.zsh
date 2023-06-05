#!/usr/bin/env zsh

e()     { emacsclient -c -n -a 'emacs' "$@" }
ediff() { e --eval "(ediff-files \"$1\" \"$2\")"; }
eman()  { e --eval "(switch-to-buffer (man \"$1\"))"; }
ekill() { emacsclient --eval '(kill-emacs)'; }
