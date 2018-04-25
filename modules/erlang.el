(defvar
  erlang-root-dir
  (or (getenv "_KERL_ACTIVE_DIR") "/usr/local/opt/erlang/lib/erlang"))
(push
 (car (file-expand-wildcards (concat erlang-root-dir "/lib/tools-*/emacs")))
 load-path)
(require 'erlang-start)
(setq erlang-man-root-dir (concat erlang-root-dir "/man"))
(setq erlang-indent-level 2)

; define auto erlang mode for these files/extensions.
(add-to-list 'auto-mode-alist '(".*\\.app\\'"     . erlang-mode))
(add-to-list 'auto-mode-alist '(".*app\\.src\\'"  . erlang-mode))
(add-to-list 'auto-mode-alist '(".*\\.config\\'"  . erlang-mode))
(add-to-list 'auto-mode-alist '(".*\\.rel\\'"     . erlang-mode))
(add-to-list 'auto-mode-alist '(".*\\.script\\'"  . erlang-mode))
(add-to-list 'auto-mode-alist '(".*\\.escript\\'" . erlang-mode))
(add-to-list 'auto-mode-alist '(".*\\.es\\'"      . erlang-mode))
(add-to-list 'auto-mode-alist '(".*\\.xrl\\'"     . erlang-mode))
(add-to-list 'auto-mode-alist '(".*\\.yrl\\'"     . erlang-mode))
; add include directory to default compile path.
(defvar erlang-compile-extra-opts
  '(bin_opt_info debug_info (i . "../include") (i . "../deps") (i . "../../") (i . "../../../deps")))

; define where put beam files.
(setq erlang-compile-outdir "../ebin")

;;; flymake
(require 'flymake)
(require 'flymake-cursor) ; http://www.emacswiki.org/emacs/FlymakeCursor
(setq flymake-log-level 3)

(defun flymake-compile-script-path (path)
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list path (list local-file))))

(defun flymake-syntaxerl ()
  (flymake-compile-script-path "/usr/local/bin/syntaxerl"))

; see /usr/local/lib/erlang/lib/tools-<Ver>/emacs/erlang-flymake.erl
(defun erlang-flymake-only-on-save ()
  "Trigger flymake only when the buffer is saved (disables syntax
check on newline and when there are no changes)."
  (interactive)
  ;; There doesn't seem to be a way of disabling this; set to the
  ;; largest int available as a workaround (most-positive-fixnum
  ;; equates to 8.5 years on my machine, so it ought to be enough ;-) )
  (setq flymake-no-changes-timeout most-positive-fixnum)
  (setq flymake-start-syntax-check-on-newline nil))
(erlang-flymake-only-on-save)

;; EDTS
(add-to-list 'url-proxy-services '("no_proxy" . "^0.*"))
(require 'edts-start)

;; https://github.com/bodil/ohai-emacs/blob/master/modules/ohai-erlang.el
(defun stripwhite (str)
  "Remove any whitespace from STR."
  (let ((s (if (symbolp str) (symbol-name str) str)))
    (replace-regexp-in-string "[ \t\n]*" "" s)))

(defun erlang-forward-arg ()
  (forward-sexp))

;; Find the name of the function under the cursor.
(defun erlang-current-function ()
  (save-excursion
    (if (not (equal (point) (point-max))) (forward-char))
    (erlang-beginning-of-function)
    (let ((beg (point))
          (fun-name)
          (fun-arity)
          (result '()))
      (search-forward "(")
      (backward-char)
      (setq fun-name (stripwhite (buffer-substring beg (point))))
      (if (char-equal (char-after) ?\))
          (setq fun-arity 0)
        (forward-char)
        (setq fun-arity 0)
        (while (not (char-equal (char-after) ?\)))
          (erlang-forward-arg)
          (setq fun-arity (+ fun-arity 1))))
      (format "%s/%d" fun-name fun-arity))))

(defun erlang-move-to-export-insertion ()
  (interactive)
    (goto-char (point-max))
    (if (search-backward-regexp "^-export(.+)\\.$" 0 t)
    (end-of-line)
      (search-backward-regexp "^-" 0 t)
      (end-of-line)))

(defun erlang-export (fun-arity)
  (interactive
   (list (read-no-blanks-input "function/arity: " (erlang-current-function))))
  (save-excursion
    (erlang-move-to-export-insertion)
    (newline)
    (insert (format "-export([%s])." fun-arity))))

(add-hook 'erlang-mode-hook
          (lambda ()
            (company-mode 0)
            (imenu-add-to-menubar "Imenu")
            (local-set-key "\C-ce" 'erlang-export)
            (add-to-list 'flymake-allowed-file-name-masks
                         '("\\.erl\\'"     flymake-syntaxerl))
            (add-to-list 'flymake-allowed-file-name-masks
                         '("\\.hrl\\'"     flymake-syntaxerl))
            (add-to-list 'flymake-allowed-file-name-masks
                         '("\\.xrl\\'"     flymake-syntaxerl))
            (add-to-list 'flymake-allowed-file-name-masks
                         '("\\.yrl\\'"     flymake-syntaxerl))
            (add-to-list 'flymake-allowed-file-name-masks
                         '("\\.app\\'"     flymake-syntaxerl))
            (add-to-list 'flymake-allowed-file-name-masks
                         '("\\.app.src\\'" flymake-syntaxerl))
            (add-to-list 'flymake-allowed-file-name-masks
                         '("\\.config\\'"  flymake-syntaxerl))
            (add-to-list 'flymake-allowed-file-name-masks
                         '("\\.rel\\'"     flymake-syntaxerl))
            (add-to-list 'flymake-allowed-file-name-masks
                         '("\\.script\\'"  flymake-syntaxerl))
            (add-to-list 'flymake-allowed-file-name-masks
                         '("\\.escript\\'" flymake-syntaxerl))
            (add-to-list 'flymake-allowed-file-name-masks
                         '("\\.es\\'"      flymake-syntaxerl))
            (flymake-mode 1)
            (yas-minor-mode)))

