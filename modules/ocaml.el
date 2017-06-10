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

    ;; Register Merlin
    (autoload 'merlin-mode "merlin" nil t nil)

    ;; Automatically start it in OCaml buffers
    (add-hook 'tuareg-mode-hook 'merlin-mode t)
    (add-hook 'caml-mode-hook 'merlin-mode t)

    ;; Make company aware of merlin
    (with-eval-after-load 'company
      (add-to-list 'company-backends 'merlin-company-backend))

    ;; Use opam switch to lookup ocamlmerlin binary
    (setq merlin-command 'opam)))
