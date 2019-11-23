#!/bin/sh

# Version of script
version="0.1.2"

help() {
    echo "Usage: $(basename $0) [-h] [-v] [-g] [-x] [-U]
      
    Run the Emacs calculator.

        -h    Show this help
        -v    Show version
        -g    Open in graphical window, not the terminal
        -x    Disable CUA mode (Emacs default, less novice-friendly)
        -U    Load users' Emacs configuration (slower startup)"
    exit
}

version() {
    echo "emacscalc (Emacs Calculator) version $version"
    echo "Copyright (c) kqr 2018"
    echo
    printf "Tapping into the power of "
    emacs --version | head -n 2
    exit
}


# Default options
nw="-nw"
cua="+1"
user="-Q"

while getopts "hgxvU" name; do
    case "$name" in
        h) help ;;
        g) nw="";;
        x) cua="-1";;
        v) version ;;
        U) user="";;
        *) help ;;
    esac
done

emacs=emacs
# This is not reliably in $PATH, yet is the program we want to run on macOS.
emacs_macos=/Applications/Emacs.app/Contents/MacOS/Emacs
if [ -f $emacs_macos ]; then
    emacs=$emacs_macos
fi

$emacs $nw $user --eval="(progn
  (when (display-graphic-p)
    (tool-bar-mode -1)
    (scroll-bar-mode -1))
  (menu-bar-mode -1)
  
  (setq
     select-enable-primary t
     help-window-select t)
  
  (cua-mode $cua)
  (when cua-mode
     (defun calc-mode? ()
        (eq major-mode (quote calc-mode)))
  
     (define-advice cua-paste (:before-while (arg))
       (and (calc-mode?) (calc-yank arg))))
  
  (full-calc)
  
  (define-key calc-mode-map [?q]
    (quote save-buffers-kill-terminal))
  
  (define-advice calc-full-help (:after nil)
    (switch-to-buffer-other-window \"*Help*\")
    (message \"Press q to go back to calc\")))"