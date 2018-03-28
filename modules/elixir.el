(require 'elixir-mode)
(require 'elixir-format)
(require 'flycheck-mix)
(require 'projectile)

(setq elixir-format-mix-path "/usr/local/bin/mix")
(add-to-list 'elixir-mode-hook 'alchemist-mode)
(add-hook
 'elixir-mode-hook
 (lambda ()
   (progn
     (add-hook 'before-save-hook 'elixir-format-before-save)
     (flycheck-mix-setup)
     (prettify-elixir-symbols)
     (if (projectile-project-p)
         (setq
          elixir-format-arguments
          (list "--dot-formatter"
                (concat (projectile-project-root) "/.formatter.exs")))
       (setq elixir-format-arguments nil)))))

(defun prettify-elixir-symbols ()
  (setq-local
   prettify-symbols-alist
   (append
    '(;; Syntax
      ("*" . ?×)
      ("/" . ?÷)
      ("==" . #x2a75)
      ("!=" . #x2260)
      ;; ("->" . #x27f6)
      ;; ("<-" . #x27f5)
      ;; ("<=" . #x2a7d)
      ;; (">=" . #x2a7e)
      ("::" . #x2e2c)
      ("<>" . (?≺ (Br Bl -24 0) ?≻))
      ("<<" . (?≺ (Br Bl -45 0) ?≺ (Br Bl -100 0) ?\s))
      (">>" . (?\s (Br Bl -100 0) ?≻ (Br Bl -45 0) ?≻))
      ("++" . (?+ (Br Bl -35 0) ?+))
      ("--" . (?- (Br Bl -33 0) ?-))
      ;; ("|>" . #x2b9a)
      ("not" . #x2757)
      ("in" . #x2208)
      ("not in" . #x2209)
      ("fn" . #x1d6cc)
      ("for" . ?∀)
      ("raise" . ?🔥)
      ("when" . #x2235)
      ;;              ("do" . (?\s (Bl Bl 35 25) ?：))
      ;;              ("end" . ?·)

      ;; messages
      ("self" . (?𝔰
                 (Br . Bl)
                 ?𝔢 (Br . Bl)
                 ?𝔩 (Br . Bl)
                 ?𝔣))
      ("send" . (?𝔰
                 (Br . Bl)
                 ?𝔢 (Br . Bl)
                 ?𝔫 (Br . Bl)
                 ?𝔡))
      ;; ("send" . ?⟼)
      ("receive" . (?𝔯
                    (Br . Bl)
                    ?𝔢 (Br . Bl)
                    ?𝔠 (Br . Bl)
                    ?𝔢 (Br . Bl)
                    ?𝔦 (Br . Bl)
                    ?𝔳 (Br . Bl)
                    ?𝔢))
      ;; ("receive" . ?⟻)
      ("pid" . (?𝔭
                (Br . Bl)
                ?𝔦 (Br . Bl)
                ?𝔡))

      ;; Defs
      ;; ("def" . ?ℱ)
      ;; ("defp" . (?ℱ (Br Bl 50 0) ?➖))
      ;; ("defmodule" . ?ℳ)
      ;; ("defprotocol" . ?𝒫)
      ;; ("defimpl" . ?𝒥)
      ;; ("defexception" . ?ℰ)
      ;; ("defstruct" . ?𝑺)
      ;; ("defmacro" . ?𝒎)
      ;; ("defmacrop" . (?𝒎 (Br Bl 50 0) ?➖))

      ;; ;; quote unquote
      ;; ("quote" . ?𝔔)
      ;; ("unquote" . ?𝔘)

      ;; ;; modules
      ;; ("alias" . ?α)
      ;; ("import" . ?𝜾)
      ;; ("use" . ?μ)
      ;; ("require" . ?ρ)

      ;; Base Types
      ("true" . #x1d54b)
      ("false" . #x1d53d)
      ("nil" . #x2205)

      ;; types
      ("any" . #x2754))
    prettify-symbols-alist)))
