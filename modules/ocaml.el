(require 'oasis-mode)
(add-to-list 'auto-mode-alist '("/jbuild$" . lisp-mode))

(let ((opam-share (ignore-errors (car (process-lines "opam" "config" "var" "share")))))
  (when (and opam-share (file-directory-p opam-share))
    (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))

    ;; Register Tuareg
    (autoload 'tuareg-mode "tuareg" "Major mode for editing Caml code" t)
    (autoload 'camldebug "camldebug" "Run the Caml debugger" t)
    (autoload 'tuareg-imenu-set-imenu "tuareg-imenu"
      "Configuration of imenu for tuareg" t)
    (setq auto-mode-alist
    (append '(("\\.ml[ily]?$" . tuareg-mode)
        ("\\.topml$" . tuareg-mode))
      auto-mode-alist))

    ;; utop
    (autoload 'utop "utop" "Toplevel for OCaml" t)
    (setq utop-command "opam config exec -- utop -emacs")
    (autoload 'utop-minor-mode "utop" "Minor mode for utop" t)
    (add-hook 'tuareg-mode-hook 'utop-minor-mode)

    ;; Register Merlin
    (autoload 'merlin-mode "merlin" nil t nil)

    ;; Automatically start it in OCaml buffers
    (require 'ocp-indent)
    (add-hook 'tuareg-mode-hook
              '(lambda ()
                 (merlin-mode)
                 (setq indent-line-function 'ocp-indent-line)))

    (add-hook 'caml-mode-hook 'merlin-mode t)

    (setq tuareg-prettify-symbols-full t)

    ;; Make company aware of merlin
    (with-eval-after-load 'company
      (add-to-list 'company-backends 'merlin-company-backend))

    ;; Use opam switch to lookup ocamlmerlin binary
    (setq merlin-command 'opam)))
