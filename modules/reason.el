(add-to-list 'auto-mode-alist '("\\.rei?$\\'" . reason-mode))

(add-hook
 'reason-mode-hook
 (lambda ()
   (add-hook 'before-save-hook 'refmt-before-save)
   (merlin-mode)))

