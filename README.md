emacs.d
=======

My relocatable Emacs config with [Cask](https://github.com/cask/cask).

Usage
-----

Install Cask if you haven't, clone and run `cask`.

External tools
--------------

```sh
opam install merlin tuareg ocp-indent
go get -u github.com/shurcooL/markdownfmt
npm i -g tern prettier
```

Personal macOS stuff
--------------------

```sh
brew tap railwaycat/emacsmacport
brew install emacs-mac --with-natural-title-bar
defaults write org.gnu.Emacs TransparentTitleBar LIGHT
defaults write org.gnu.Emacs HideDocumentIcon YES
```
