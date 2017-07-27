;; Env path
(exec-path-from-shell-initialize)

;; Theme
(defconst THEME "sanityinc-tomorrow-day-theme")
(load THEME t)

;; Editor UI
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

;; Editor Font
(when (eq window-system 'x)
  (defconst FONT "Nitti Pro SemiLight Slim-12"))

(when (memq window-system '(mac ns))
  (defconst FONT "Nitti Pro-14"))
  
(set-face-attribute 'default nil :font FONT)
(set-frame-font FONT nil t)

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
(global-nlinum-mode)
(defun my-nlinum-mode-hook ()
  (when nlinum-mode
    (setq-local nlinum-format
                (concat "% " (number-to-string
			      ;; Guesstimate number of buffer lines.
			      (ceiling (log (max 1 (/ (buffer-size) 80)) 10)))
                        "d "))))
(add-hook 'nlinum-mode-hook #'my-nlinum-mode-hook)
(set-face-foreground 'linum "#F1F1F1")

;; Key remap
(when (memq window-system '(mac ns))
  (setq mac-option-modifier 'alt)
  (setq mac-command-modifier 'meta))

(when (eq window-system 'x)
  (setq x-super-keysym 'meta))

;; Backups
(setq make-backup-files nil)
;; (setq backup-by-copying t
;;       backup-directory-alist '(("." . "~/.emacs-saves"))
;;       delete-old-versions t
;;       kept-new-versions 6
;;       kept-old-versions 2
;;       version-control t)

;;
(global-auto-revert-mode t)
