(require 'eclim)
(setq eclimd-autostart t)
(setq eclimd-default-workspace "~/.eclipse-workspace")
(define-key eclim-mode-map (kbd "C-c C-c") 'eclim-problems-correct)

(add-hook 'java-mode-hook
    '(lambda ()
       (setq c-basic-offset 2
             tab-width 2
             indent-tabs-mode nil)
       (eclim-mode t)
       (require 'company-emacs-eclim)
       (company-emacs-eclim-setup)
       (gradle-mode 1)))

(defun build-and-run ()
  (interactive)
  (gradle-run "build run"))
(require 'gradle-mode)
(define-key gradle-mode-map (kbd "C-c C-r") 'build-and-run)
