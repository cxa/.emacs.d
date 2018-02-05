(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(setq-default
 indent-tabs-mode nil
 tab-width 2
 c-basic-offset 'tab-width)

(require 'recentf)
(setq recentf-exclude '("ido.last"
                        "recentf"))
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-x" 'recentf-open-files)

(ido-mode)
(setq ido-enable-flex-matching t)
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

;; ffip
(global-set-key (kbd "M-p") 'find-file-in-project)

(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(defun my-indent-or-complete ()
    (interactive)
    (if (looking-at "\\_>")
        (company-complete-common)
      (indent-according-to-mode)))

(global-set-key "\t" 'my-indent-or-complete)
(define-key company-active-map (kbd "C-n") 'company-select-next-or-abort)
(define-key company-active-map (kbd "C-p") 'company-select-previous-or-abort)

(defun prev-window ()
  (interactive)
  (other-window -1))
(global-set-key (kbd "C-.") 'other-window)
(global-set-key (kbd "C-,") 'prev-window)

(electric-pair-mode 1)
