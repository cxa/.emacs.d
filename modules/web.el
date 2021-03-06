(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.s?css\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.json\\'" . web-mode))

(defadvice company-tern (before web-mode-set-up-ac-sources activate)
  "Set `tern-mode' based on current language before running company-tern."
  (message "advice")
  (if (equal major-mode 'web-mode)
      (let ((web-mode-cur-language
             (web-mode-language-at-pos)))
        (if (or (string= web-mode-cur-language "javascript")
                (string= web-mode-cur-language "jsx")
                )
            (unless tern-mode (tern-mode))
          (if tern-mode (tern-mode -1))))))

(defvar js-prettify-symbols-alist
  '(("===" . ?≡)
    ("!==" . ?≢)
    ("!=" . ?≠)
    ("!" . ?¬)
    (">=" . ?≥)
    ("<=" . ?≤)
    ("&&" . ?∧)
    ("||" . ?∨)
    ("=>" . ?⇒)
    ("++" . ?⧺)
    ("--" . ?╌)
    ("for" . "∀")
    ("class" . ?𝑪)
    ("function" . ?ƒ)
    ("null" . ?∅)
    ("undefined" . ?⊥)))

(defun enable-minor-mode (my-pair)
  "Enable minor mode if filename match the regexp.  MY-PAIR is a cons cell (regexp . minor-mode)."
  (if (buffer-file-name)
      (if (string-match (car my-pair) buffer-file-name)
          (funcall (cdr my-pair)))))

(defun my-wm-hook ()
  (progn
    (setq-local
     prettify-symbols-alist
     (append prettify-symbols-alist js-prettify-symbols-alist))
    (setq web-mode-markup-indent-offset 2)
    (setq web-mode-css-indent-offset 2)
    (setq web-mode-code-indent-offset 2)
    (set (make-local-variable 'company-backends) '(company-tern company-web-html company-css))
    (enable-minor-mode '("\\.jsx?\\'" . prettier-js-mode))
    (enable-minor-mode '("\\.json\\'" . prettier-js-mode))
    (enable-minor-mode '("\\.s?css\\'" . prettier-js-mode))))
(require 'prettier-js)
(add-hook 'web-mode-hook 'my-wm-hook)
