# emacs.d

My relocatable Emacs config with [Cask](https://github.com/cask/cask).

## Usage

Install Cask if you haven't, clone and run `cask`.

## External tools

```sh
opam install merlin tuareg ocp-indent
npm i -g tern prettier

```

### For Java

```sh
brew cask install eclipse-ide
```

Install [eclim](http://eclim.org) to `/Applications/Eclipse.app/Contents/Eclipse` and add its bin dir to `$PATH`.

## Personal macOS stuff

```sh
brew tap railwaycat/emacsmacport
brew install emacs-mac --with-gnutls --with-natural-title-bar #--HEAD #optional
defaults write org.gnu.Emacs TransparentTitleBar LIGHT
defaults write org.gnu.Emacs HideDocumentIcon YES
```
