(add-to-list
 'magic-mode-alist
 `(,(lambda ()
      (and (string= (file-name-extension buffer-file-name) "h")
           (re-search-forward "@\\<interface\\>" 
                              magic-mode-regexp-match-limit t)))
   . objc-mode))

;; Company
(setq
 company-clang-executable
 (substring (shell-command-to-string "xcrun --find clang++") 0 -1)
 
 company-clang-arguments
 `("-isysroot"
   ;; If you target macOS
   ;; ,(substring (shell-command-to-string "xcrun --sdk macosx --show-sdk-path") 0 -1))
   ,(substring (shell-command-to-string "xcrun --sdk iphoneos --show-sdk-path") 0 -1))


 flycheck-c/c++-clang-executable
 (substring (shell-command-to-string "xcrun --find clang++") 0 -1)

 company-backends
 '(company-clang
   company-capf
   company-c-headers))

(add-to-list 'auto-mode-alist '("\\.x\\'" . objc-mode))
(add-to-list 'auto-mode-alist '("\\.xm\\'" . objc-mode))
(add-to-list 'auto-mode-alist '("\\.mm\\'" . objc-mode))
