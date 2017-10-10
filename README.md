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
brew edit emacs-mac
```

Add follow before `def install`:

```sh
patch do
  url "https://gist.github.com/lululau/90dbffb613c216f046ff14ed37b586b5/raw/32dceaf9a45e8dbdfe793852f88e15cbaedec8d8/emacs-mac-title-bar.patch"
  sha256 '30c89405541f4383bb1bb9fa54f22b82d5144f9cdef8f313a72271ef72bf51ed'
end
```

```sh
brew install emacs-mac
defaults write org.gnu.Emacs TransparentTitleBar LIGHT
defaults write org.gnu.Emacs HideDocumentIcon YES
```
