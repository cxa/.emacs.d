(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(defvaralias 'c-basic-offset 'tab-width)

(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(require 'helm-config)
(setq helm-ff-auto-update-initial-value nil)
(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-M-x-fuzzy-match t)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(helm-mode 1)

(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(defun my-indent-or-complete ()
    (interactive)
    (if (looking-at "\\_>")
        (company-complete-common)
      (indent-according-to-mode)))

(global-set-key "\t" 'my-indent-or-complete)
