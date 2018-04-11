(defvar
  erlang-root-dir
  (or (getenv "_KERL_ACTIVE_DIR") "/usr/local/opt/erlang/lib/erlang"))
(push (concat erlang-root-dir "/lib/tools-2.11.2/emacs") load-path)
(require 'erlang-start)
(setq erlang-man-root-dir (concat erlang-root-dir "/man"))
(setq erlang-indent-level 2)

(push "~/.emacs.d/distel/elisp" load-path)

(require 'distel)
(distel-setup)

(require 'flycheck-rebar3)
(flycheck-rebar3-setup)
(add-hook 'erlang-mode-hook 'rebar-mode)

(require 'company-distel)
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-distel))
(add-hook 'erlang-mode-hook
          (lambda ()
            (setq company-backends '(company-distel))))

(require 'flycheck)
(flycheck-define-checker
    erlang-otp
  "An Erlang syntax checker using the Erlang interpreter."
  :modes (erlang-mode)
  :command ("erlc" "-o" temporary-directory "-Wall"
            "-I" "../include" "-I" "../../include"
            "-I" "../../../include" source)
  :error-patterns
  ((warning line-start (file-name) ":" line ": Warning:" (message) line-end)
   (error line-start (file-name) ":" line ": " (message) line-end)))

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
    (if (search-backward-regexp "^-export" 0 t)
    (end-of-line)
      (search-backward-regexp "^-" 0 t)
      (end-of-line)))

(defun erlang-export (fun-arity)
  (interactive
   (list (read-no-blanks-input "function/arity: " (erlang-current-function))))
  (save-excursion
    (erlang-move-to-export-insertion)
    (newline)
    (insert (format "-export ([%s])." fun-arity))))

(add-hook 'erlang-mode-hook
          (lambda ()
            (flycheck-select-checker 'erlang-otp)
            (flycheck-mode)
            (local-set-key "\C-ce" 'erlang-export)))
;; prevent annoying hang-on-compile
(defvar inferior-erlang-prompt-timeout t)
;; default node name to emacs@localhost
(setq inferior-erlang-machine-options '("-sname" "emacs"))
;; tell distel to default to that node
(setq erl-nodename-cache
      (make-symbol
       (concat
        "emacs@"
        ;; Mac OS X uses "name.local" instead of "name", this should work
        ;; pretty much anywhere without having to muck with NetInfo
        ;; ... but I only tested it on Mac OS X.
                (car (split-string (shell-command-to-string "hostname"))))))
