;
(package-initialize)

(require 'cask "/usr/local/share/emacs/site-lisp/cask/cask.el")
(cask-initialize)

(add-to-list 'load-path "~/.emacs.d/modules")

(load "common")
(load "editor")
(load "markdown")
(load "ocaml")
(load "reason")
(load "web")

(when (equal system-type 'darwin)
  (load "swift")
  (load "objc"))
