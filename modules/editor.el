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

;; Editor Font
(set-face-attribute 'default nil
                    :family "Pitch Sans"
                    :height 160)
(dolist (charset '(han cjk-misc bopomofo symbol))
  (set-fontset-font (frame-parameter nil 'font) charset
                    (font-spec :family "PingFang SC" :weight 'light :size 14)))
(setq-default line-spacing 10)
(global-prettify-symbols-mode +1)

;; Mode line
(setq mode-line-position nil)
(setq line-number-mode nil)
(setq-default
 sml/modified-char "★"
 sml/read-only-char "☯︎"
 sml/show-remote nil
 sml/no-confirm-load-theme t
 sml/mule-info nil
 sml/theme 'smart-mode-line-light-powerline)
(setq-default sml/replacer-regexp-list '((".*" " ") ))
(sml/setup)

;; Frame size
(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if window-system
      (progn
        (defconst width 120)
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

;; Neotree
(require 'neotree)
(setq neo-theme 'custom)
(setq
 neo-theme-custom-open "▫︎"
 neo-theme-custom-close "▪︎")
(setq neo-autorefresh t)
(setq neo-smart-open t)
(setq neo-force-change-root t)
(setq neo-mode-line-type 'custom)

;; https://emacs.stackexchange.com/a/16660/16541
(defun jordon-fancy-mode-line-render (left center right &optional lpad rpad)
  "Return a string the width of the current window with
LEFT, CENTER, and RIGHT spaced out accordingly, LPAD and RPAD,
can be used to add a number of spaces to the front and back of the string."
  (condition-case err
      (let* ((left (if lpad (concat (make-string lpad ?\s) left) left))
             (right (if rpad (concat right (make-string rpad ?\s)) right))
             (width (apply '+ (window-width) (let ((m (window-margins))) (list (or (car m) 0) (or (cdr m) 0)))))
             (total-length (+ (length left) (length center) (length right) 2)))
        (when (> total-length width) (setq left "" right ""))
        (let* ((left-space (/ (- width (length center)) 2))
               (right-space (- width left-space (length center)))
               (lspaces (max (- left-space (length left)) 1))
               (rspaces (max (- right-space (length right)) 1 0)))
          (concat left (make-string lspaces  ?\s)
                  center
                  (make-string rspaces ?\s)
                  right)))
    (error (format "[%s]: (%s) (%s) (%s)" err left center right))))

(setq neo-mode-line-custom-format
      '((:eval
          (jordon-fancy-mode-line-render
           "❦"
           (let ((project-dir (ignore-errors (or (ffip-project-root) nil))))
             (if project-dir
                 (upcase (file-name-nondirectory (directory-file-name project-dir)))
               ""))
           ""
           1 1)
          )))

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
(set-face-attribute 'neo-dir-link-face nil :foreground "#999999")
(set-face-attribute 'neo-file-link-face nil :foreground "#999999")
(set-face-attribute 'neo-header-face nil :background "white" :foreground "white")

;; whitespace-cleanup-mode
(require 'whitespace-cleanup-mode)
(add-hook 'before-save-hook 'whitespace-cleanup)

;; Magit
(require 'magit)
(global-set-key (kbd "C-x C-g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch-popup)
