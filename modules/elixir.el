(require 'elixir-mode)
(require 'elixir-format)

(setq elixir-format-mix-path "/usr/local/bin/mix")
(add-to-list 'elixir-mode-hook 'alchemist-mode)
(add-hook 'elixir-mode-hook
          (lambda () (add-hook 'before-save-hook 'elixir-format-before-save)))
