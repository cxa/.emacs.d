# emacs.d

My relocatable Emacs config with [Cask](https://github.com/cask/cask).

![screenshot](screenshot.png)

## Usage

Install Cask if you haven't, clone and run `cask`.

### `cask` gotchas

`cask` is rely on [package-build](https://github.com/melpa/package-build.git), which breaks things frequently after updated from ELPA. Manually download a stable version from github repo releases and replace related el files.

And don't forget to remove `cask` tmp dir, which can be retrived from evaling `(temporary-file-directory)` in `*scratch*`.

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

## For Erlang

```sh
cd ~/.emacs.d/.cask/_ver_/elpa/edts-*
make

brew install syntaxerl
```

## Personal macOS stuff

```sh
brew tap railwaycat/emacsmacport
brew install emacs-mac --with-gnutls --with-natural-title-bar #--HEAD #optional
defaults write org.gnu.Emacs TransparentTitleBar LIGHT
defaults write org.gnu.Emacs HideDocumentIcon YES
```
