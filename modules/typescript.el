(defvar js-prettify-symbols-alist
  '(("===" . ?≡)
    ("!==" . ?≢)
    (">=" . ?≥)
    ("<=" . ?≤)
    ("&&" . ?∧)
    ("||" . ?∨)
    ("=>" . ?⇒)
    ("true" . #x1d54b)
    ("false" . #x1d53d)
    ("for" . "∀")
    ("class" . ?𝑪)
    ("function" . ?𝒇)
    ("null" . ?∅)
    ("undefined" . ?⊥)))

(defun ts-hook ()
  (progn (setq-local
          prettify-symbols-alist
          (append prettify-symbols-alist js-prettify-symbols-alist))))
(add-hook 'typescript-mode-hook 'ts-hook)

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (setq typescript-indent-level tab-width)
  (setq tide-format-options `(:tabSize ,tab-width :indentSize ,tab-width nil))
  (enable-minor-mode '("\\.tsx?\\'" . prettier-js-mode))
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(setq company-tooltip-align-annotations t)
(add-hook 'typescript-mode-hook #'setup-tide-mode)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))
