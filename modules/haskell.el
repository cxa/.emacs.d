(intero-global-mode 1)

(defvar haskell-prettify-symbols-alist
  ;; https://raw.githubusercontent.com/cpitclaudel/.emacs.d/master/lisp/prettify-alists/haskell-prettify.el
  '(;; Double-struck letters
    ("|A|" . ?𝔸)
    ("|B|" . ?𝔹)
    ("|C|" . ?ℂ)
    ("|D|" . ?𝔻)
    ("|E|" . ?𝔼)
    ("|F|" . ?𝔽)
    ("|G|" . ?𝔾)
    ("|H|" . ?ℍ)
    ("|I|" . ?𝕀)
    ("|J|" . ?𝕁)
    ("|K|" . ?𝕂)
    ("|L|" . ?𝕃)
    ("|M|" . ?𝕄)
    ("|N|" . ?ℕ)
    ("|O|" . ?𝕆)
    ("|P|" . ?ℙ)
    ("|Q|" . ?ℚ)
    ("|R|" . ?ℝ)
    ("|S|" . ?𝕊)
    ("|T|" . ?𝕋)
    ("|U|" . ?𝕌)
    ("|V|" . ?𝕍)
    ("|W|" . ?𝕎)
    ("|X|" . ?𝕏)
    ("|Y|" . ?𝕐)
    ("|Z|" . ?ℤ)
    ("|gamma|" . ?ℽ)
    ("|Gamma|" . ?ℾ)
    ("|pi|" . ?ℼ)
    ("|Pi|" . ?ℿ)

    ;; Types
    ("::" . ?∷)

    ;; Quantifiers
    ("forall" . ?∀)
    ("exists" . ?∃)

    ;; Arrows
    ("->" . ?→)
    ("-->" . ?⟶)
    ("<-" . ?←)
    ("<--" . ?⟵)
    ("<->" . ?↔)
    ("<-->" . ?⟷)

    ("=>" . ?⇒)
    ("==>" . ?⟹)
    ("<==" . ?⟸)
    ("<=>" . ?⇔)
    ("<==>" . ?⟺)

    ("|->" . ?↦)
    ("|-->" . ?⟼)
    ("<-|" . ?↤)
    ("<--|" . ?⟻)

    ("|=>" . ?⤇)
    ("|==>" . ?⟾)
    ("<=|" . ?⤆)
    ("<==|" . ?⟽)

    ("~>" . ?⇝)
    ("<~" . ?⇜)

    (">->" . ?↣)
    ("<-<" . ?↢)
    ("->>" . ?↠)
    ("<<-" . ?↞)

    (">->>" . ?⤖)
    ("<<-<" . ?⬻)

    ("<|-" . ?⇽)
    ("-|>" . ?⇾)
    ("<|-|>" . ?⇿)

    ("<-/-" . ?↚)
    ("-/->" . ?↛)

    ("<-|-" . ?⇷)
    ("-|->" . ?⇸)
    ("<-|->" . ?⇹)

    ("<-||-" . ?⇺)
    ("-||->" . ?⇻)
    ("<-||->" . ?⇼)

    ("-o->" . ?⇴)
    ("<-o-" . ?⬰)

    ;; Boolean operators
    ("not" . ?¬)
    ("&&" . ?∧)
    ("||" . ?∨)

    ;; Relational operators
    ("==" . ?≡)
    ("/=" . ?≠)
    ("<=" . ?≤)
    (">=" . ?≥)
    ("/<" . ?≮)
    ("/>" . ?≯)

    ;; Containers / Collections
    ("++" . ?⧺)
    ("+++" . ?⧻)
    ("|||" . ?⫴)
    ("empty" . ?∅)
    ("elem" . ?∈)
    ("notElem" . ?∉)
    ("member" . ?∈)
    ("notMember" . ?∉)
    ("union" . ?∪)
    ("intersection" . ?∩)
    ("isSubsetOf" . ?⊆)
    ("isProperSubsetOf" . ?⊂)

    ;; Other
    ("<<" . ?≪)
    (">>" . ?≫)
    ("<<<" . ?⋘)
    (">>>" . ?⋙)
    ("<|" . ?⊲)
    ("|>" . ?⊳)
    ("><" . ?⋈)
    ("mempty" . ?∅)
    ("mappend" . ?⊕)
    ("<*>" . ?⊛)
    ("undefined" . ?⊥)
    (":=" . ?≔)
    ("=:" . ?≕)
    ("=def" . ?≝)
    ("=?" . ?≟)
    ("..." . ?…)))

(add-hook
 'haskell-mode-hook
 '(lambda ()
    (setq-local
     prettify-symbols-alist
     (append prettify-symbols-alist haskell-prettify-symbols-alist))))
