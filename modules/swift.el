(add-to-list 'auto-mode-alist '("\\.swift\\'" . swift-mode))
(require 'company-sourcekit)
(add-to-list 'company-backends 'company-sourcekit)
