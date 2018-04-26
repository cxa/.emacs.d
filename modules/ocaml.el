(require 'oasis-mode)

(let
    ((opam-share
      (ignore-errors (car (process-lines "opam" "config" "var" "share")))))
  (when (and opam-share (file-directory-p opam-share))
    (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))
    (load "tuareg-site-file")

    ;; utop
    (autoload 'utop "utop" "Toplevel for OCaml" t)
    (setq utop-command "opam config exec -- utop -emacs")
    (autoload 'utop-minor-mode "utop" "Minor mode for utop" t)
    (add-hook 'tuareg-mode-hook 'utop-minor-mode)

    ;; Register Merlin
    (setq merlin-ac-setup nil)
    (autoload 'merlin-mode "merlin" nil t nil)

    ;; Automatically start it in OCaml buffers
    (require 'ocp-indent)
    (add-hook 'tuareg-mode-hook
              '(lambda ()
                 (merlin-mode)
                 (setq tuareg-prettify-symbols-full t)
                 (setq indent-line-function 'ocp-indent-line)))

    ;; Use opam switch to lookup ocamlmerlin binary
    (setq merlin-command 'opam)))
