;
(package-initialize)

(if (not (require 'cask "/usr/local/share/emacs/site-lisp/cask/cask.el" t))
  (require 'cask "~/.cask/cask.el"))

(cask-initialize)

(add-to-list 'load-path "~/.emacs.d/modules")
(add-to-list 'load-path "~/.emacs.d/vendor")

(load "common")
(load "editor")
(load "markdown")
(load "haskell")
(load "ocaml")
(load "standardml")
(load "reason")
(load "fsharp")
(load "web")
(load "java")
(load "rust")
(load "erlang_")
(load "elixir")
(load "docker")
(load "yaml")

(when (equal system-type 'darwin)
  (load "swift")
  (load "objc"))
