;; Env path
(exec-path-from-shell-initialize)

;; Theme
(defconst THEME "sanityinc-tomorrow-day-theme")
(load THEME t)

;; Fringe
(set-face-attribute 'fringe nil :background "white")
(define-fringe-bitmap 'right-curly-arrow
  [#b00000000
   #b00000000
   #b00000000
   #b00000000
   #b01110000
   #b00010000
   #b00010000
   #b00000000])
(define-fringe-bitmap 'left-curly-arrow
  [#b00000000
   #b00001000
   #b00001000
   #b00001110
   #b00000000
   #b00000000
   #b00000000
   #b00000000])

(and (fboundp 'menu-bar-mode)   (menu-bar-mode   -1))
(and (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(and (fboundp 'tool-bar-mode)   (tool-bar-mode   -1))
(and (fboundp 'tooltip-mode)    (fboundp 'x-show-tip) (tooltip-mode -1))

;; `defaults write org.gnu.Emacs HideDocumentIcon YES` to remove title icon for mac
(setq frame-title-format "")

(setq initial-buffer-choice 'recentf-open-files)

;; Editor Font
(set-face-attribute 'default nil
                    :family "Courier Prime Sans"
                    :height 160)
(dolist (charset '(han cjk-misc bopomofo symbol))
  (set-fontset-font (frame-parameter nil 'font) charset
                    (font-spec :family "PingFang SC" :weight 'normal :size 14)))
(setq-default line-spacing 12)
(global-prettify-symbols-mode +1)

(require 'all-the-icons)
(setq all-the-icons-scale-factor 0.6)
;; Mode line
(set-face-attribute 'mode-line nil
                    :weight 'bold
                    :foreground "#999999"
                    :background "#f7f7f7"
                    :box '(:line-width 4 :color "#f7f7f7"))
(set-face-attribute 'mode-line-inactive nil
                    :weight 'bold
                    :foreground "#999999"
                    :background "#f7f7f7"
                    :box '(:line-width 4 :color "#f7f7f7"))

;; Frame size
(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if window-system
      (progn
        (defconst width 110)
        (add-to-list 'default-frame-alist (cons 'top 0))
        (add-to-list 'default-frame-alist (cons 'left (/ (- (x-display-pixel-width) (* (frame-char-width) width)) 2)))
        (add-to-list 'default-frame-alist (cons 'width width))
        (add-to-list 'default-frame-alist (cons 'height (/ (x-display-pixel-height) (frame-char-height)))))))
(set-frame-size-according-to-resolution)

;; Line number
;;(global-nlinum-mode)
(require 'nlinum)
(add-hook 'text-mode-hook 'nlinum-mode)
(add-hook 'prog-mode-hook 'nlinum-mode)
(set-face-attribute 'linum nil :foreground "#F3F3F3" :background "white")
(defun my-nlinum-mode-hook ()
  (when nlinum-mode
    (setq-local nlinum-format
                (concat "% " (number-to-string
                              ;; Guesstimate number of buffer lines.
                              (ceiling (log (max 1 (/ (buffer-size) 80)) 10)))
                        "d "))))
(add-hook 'nlinum-mode-hook #'my-nlinum-mode-hook)

;; Window separator
(set-face-background 'vertical-border "#FAFAFA")
(set-face-foreground 'vertical-border (face-background 'vertical-border))

;; Key remap
(when (memq window-system '(mac ns))
  (setq mac-option-modifier 'alt)
  (setq mac-command-modifier 'meta))

(when (eq window-system 'x)
  (setq x-super-keysym 'meta))

;; Backups
(setq make-backup-files nil)
(setq backup-by-copying t
      backup-directory-alist '(("." . "~/.emacs-saves"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;;
(global-auto-revert-mode t)

;; Auto save
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Indent
(defun indent-buffer ()
  "Indent the currently visited buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

(defun indent-region-or-buffer ()
  "Indent a region if selected, otherwise the whole buffer."
  (interactive)
  (save-excursion
    (if (region-active-p)
        (progn
          (indent-region (region-beginning) (region-end))
          (message "Indented selected region."))
      (progn
        (indent-buffer)
        (message "Indented buffer.")))))
(global-set-key (kbd "C-M-\\") 'indent-region-or-buffer)

;; Netroee
(require 'neotree)
;;(setq neo-theme 'custom)
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(setq neo-autorefresh t)
(setq neo-smart-open t)
(setq neo-force-change-root t)
(setq neo-show-slash-for-folder nil)
(setq neo-mode-line-type 'custom)
(defun neotree-startup ()
  (interactive)
  (neotree-show)
  (call-interactively 'other-window))

(if (daemonp)
    (add-hook 'server-switch-hook #'neotree-startup)
  (add-hook 'after-init-hook #'neotree-startup)
  )

(require 'nyan-mode)
(setq nyan-minimum-window-width neo-window-width)
(setq neo-mode-line-custom-format
      (list
       '(:eval (list (nyan-create)))
       ))

(defun neotree-project-dir ()
    "Open NeoTree using the git root."
    (interactive)
    (let ((project-dir (ignore-errors (or (ffip-project-root) nil)))
          (file-name (buffer-file-name)))
      (if project-dir
          (progn
            (neotree-dir project-dir)
            (neotree-find file-name)
            (other-window 1))
        (message "Could not find git project root."))))
(global-set-key (kbd "C-x C-n") 'neotree-project-dir)
(set-face-attribute 'neo-dir-link-face nil :foreground "#999999" :height 140)
(set-face-attribute 'neo-file-link-face nil :foreground "#999999" :height 140)
(set-face-attribute 'neo-header-face nil :background "white" :foreground "white" :height 140)

;; whitespace-cleanup-mode
(require 'whitespace-cleanup-mode)
(add-hook 'before-save-hook 'whitespace-cleanup)

;; Magit
(require 'magit)
(global-set-key (kbd "C-x C-g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)
