(push "/usr/local/opt/erlang/lib/erlang/lib/tools-2.11.2/emacs" load-path)
(require 'erlang-start)
(setq erlang-man-root-dir "/usr/local/opt/erlang/lib/erlang/man")
(setq erlang-indent-level 2)

(push "~/.emacs.d/distel/elisp" load-path)
(require 'distel)
(distel-setup)

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

(add-hook 'erlang-mode-hook
          (lambda ()
            (flycheck-select-checker 'erlang-otp)
                        (flycheck-mode)))
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
