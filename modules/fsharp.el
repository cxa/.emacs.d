(add-to-list 'auto-mode-alist '(".fsproj\\'" . xml-mode))
(setq fsharp-ac-use-popup nil)
(setq inferior-fsharp-program "fsharpi --readline-")
(setq-default fsharp-indent-offset 2)
;; https://github.com/ocaml/tuareg/blob/a6d1589e256d861bfb51c59756b0aa25e88dfb89/tuareg.el#L527
(defvar fsharp-prettify-symbols-basic-alist
  (cond ((fboundp 'decode-char) ;; use a unicode font.
         `(("sqrt" . ,(decode-char 'ucs 8730))
           ("&&" . ,(decode-char 'ucs 8743)); 'LOGICAL AND' (U+2227)
           ("||" . ,(decode-char 'ucs 8744)); 'LOGICAL OR' (U+2228)
           ("+." . ,(decode-char 'ucs 8724));DOT PLUS (U+2214)
           ("-." . ,(decode-char 'ucs 8760));DOT MINUS (U+2238)
           ;;("*." . ,(decode-char 'ucs 215))
           ("*." . ,(decode-char 'ucs 8729)); BULLET OPERATOR
           ("/." . ,(decode-char 'ucs 247))
           ("<-" . ,(decode-char 'ucs 8592))
           ("<=" . ,(decode-char 'ucs 8804))
           (">=" . ,(decode-char 'ucs 8805))
           ("<>" . ,(decode-char 'ucs 8800))
           ("==" . ,(decode-char 'ucs 8801))
           ("!=" . ,(decode-char 'ucs 8802))
           ("<=>" . ,(decode-char 'ucs 8660))
           ("infinity" . ,(decode-char 'ucs 8734))
           ;; Some greek letters for type parameters.
           ("'a" . ,(decode-char 'ucs 945))
           ("'b" . ,(decode-char 'ucs 946))
           ("'c" . ,(decode-char 'ucs 947))
           ("'d" . ,(decode-char 'ucs 948))
           ("'e" . ,(decode-char 'ucs 949))
           ("'f" . ,(decode-char 'ucs 966))
           ("'i" . ,(decode-char 'ucs 953))
           ("'k" . ,(decode-char 'ucs 954))
           ("'m" . ,(decode-char 'ucs 956))
           ("'n" . ,(decode-char 'ucs 957))
           ("'o" . ,(decode-char 'ucs 969))
           ("'p" . ,(decode-char 'ucs 960))
           ("'r" . ,(decode-char 'ucs 961))
           ("'s" . ,(decode-char 'ucs 963))
           ("'t" . ,(decode-char 'ucs 964))
           ("'x" . ,(decode-char 'ucs 958))))
        ((and (fboundp 'make-char) (fboundp 'charsetp) (charsetp 'symbol))
         `(("sqrt" . ,(make-char 'symbol 214))
           ("&&" . ,(make-char 'symbol 217))
           ("||" . ,(make-char 'symbol 218))
           ("*." . ,(make-char 'symbol 183))
           ("/." . ,(make-char 'symbol 184))
           ("<=" . ,(make-char 'symbol 163))
           ("<-" . ,(make-char 'symbol 172))
           (">=" . ,(make-char 'symbol 179))
           ("<>" . ,(make-char 'symbol 185))
           ("==" . ,(make-char 'symbol 186))
           ("<=>" . ,(make-char 'symbol 219))
           ("=>" . ,(make-char 'symbol 222))
           ("infinity" . ,(make-char 'symbol 165))
           ;; Some greek letters for type parameters.
           ("'a" . ,(make-char 'symbol 97))
           ("'b" . ,(make-char 'symbol 98))
           ("'c" . ,(make-char 'symbol 103)) ; sic! 99 is chi, 103 is gamma
           ("'d" . ,(make-char 'symbol 100))
           ("'e" . ,(make-char 'symbol 101))
           ("'f" . ,(make-char 'symbol 102))
           ("'i" . ,(make-char 'symbol 105))
           ("'k" . ,(make-char 'symbol 107))
           ("'m" . ,(make-char 'symbol 109))
           ("'n" . ,(make-char 'symbol 110))
           ("'o" . ,(make-char 'symbol 111))
           ("'p" . ,(make-char 'symbol 112))
           ("'r" . ,(make-char 'symbol 114))
           ("'s" . ,(make-char 'symbol 115))
           ("'t" . ,(make-char 'symbol 116))
           ("'x" . ,(make-char 'symbol 120))))))

(defvar fsharp-prettify-symbols-extra-alist
  (cond ((fboundp 'decode-char) ;; use a unicode font.
         `(("fun" . ,(decode-char 'ucs 955))
           ("not" . ,(decode-char 'ucs 172))
           ;;("or" . ,(decode-char 'ucs 8744)); should not be used as ||
           ("[|" . ,(decode-char 'ucs 12314)) ;; 〚
           ("|]" . ,(decode-char 'ucs 12315)) ;; 〛
           ("->" . ,(decode-char 'ucs 8594))
           (":=" . ,(decode-char 'ucs 8656))))
         ((and (fboundp 'make-char) (fboundp 'charsetp) (charsetp 'symbol))
          `(("fun" . ,(make-char 'symbol 108))
            ("not" . ,(make-char 'symbol 216))
            ;;("or" . ,(make-char 'symbol 218))
            ("->" . ,(make-char 'symbol 174))
            (":=" . ,(make-char 'symbol 220))))))
(add-hook
 'fsharp-mode-hook
 (lambda ()
   (setq prettify-symbols-alist
         (append fsharp-prettify-symbols-basic-alist
                 fsharp-prettify-symbols-extra-alist))))
