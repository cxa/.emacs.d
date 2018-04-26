;;; named to erlang_.erl to avoid conflicts

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
(require 'erlang-start)
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

(defun prettify-symbols ()
  (setq-local
   prettify-symbols-alist
   (append
    '(("->" . ?→)
      ("=>" . ?⇒)
      ("<-" . ?←)
      ("<=" . ?⇐)
      (">=" . ?≥)
      ("=<" . ?≤)
      ("=/=" . ?≠)
      ("fun" . ?ƒ))
    prettify-symbols-alist)))

(add-hook
 'erlang-mode-hook
 (lambda ()
   (prettify-symbols)
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
   (flymake-mode 1)))

