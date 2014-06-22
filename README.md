# find-temp-file

This package allows you to quickly open a temporary file corresponding
to a given extension. No need to specify a name, just an extension or
better, just a keystroke.

## Installation

Install the ELPA package from MELPA with <kbd>M-x</kbd>
`package-install` <kbd>RET</kbd> `find-temp-file` or put
`find-temp-file.el` in you load path and require it somewhere in your
`.emacs`.

```lisp
(require 'find-temp-file)
```

## Settings

You may want to bind `find-temp-file' to a convenient keystroke. In my
setup, I bound it to <kbd>C-x C-t</kbd>. To quickly find a file, press
<kbd>C-x C-t</kbd> and type the extension of the temporary file you
want to open or just press <kbd>ENTER</kbd> to select the default
extension which is the extension of the currently visited file. You
can nonetheless specify the full filename if the extension you type
contains a dot.

## Examples

The following setting stores temporary files in
`~/Draft/<MODE-NAME>/<FILE-NAME>`. You can add your own spec with
`find-temp-custom-spec`.

```lisp
(setq find-temp-template-default "~/draft/%M/%N-%S.%E")
```
