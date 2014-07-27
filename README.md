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

You may want to bind `find-temp-file` to a convenient keystroke. In my
setup, I bound it to <kbd>C-x C-t</kbd>. To quickly find a file, press
<kbd>C-x C-t</kbd> and type the extension of the temporary file you
want to open or just press <kbd>ENTER</kbd> to select the default
extension which is the extension of the currently visited file. You
can nonetheless specify the full filename if the extension you type
contains a dot.

## Examples

The following setting stores temporary files in `~/drafts`. The file
name used is the next available in `find-temp-file-prefix` plus the
provided extension.
```lisp
(setq find-temp-file-directory "~/drafts")
(setq find-temp-template-default "%N.%E")
```
The generated names are maybe too simple and could clash with other
existing non-temporary files. We can then use the spec %T or %U that
provide 5-characters long.
```lisp
(setq find-temp-template-default "%N-%U.%E")
```
Some extensions might require their files having a special format.
This can be done with `find-temp-template-alist` that maps extensions
to file name templates.

With that setting, we might quite rapidly run out of automatically
generated names. To remedy this, we add a sub-directory named after
the current date.
```lisp
(setq find-temp-template-default "%D/%N-%U.%E")
```

We can also have our files to be sorted after the major mode they
trigger.
```lisp
(setq find-temp-template-default "%M/%D/%N-%U.%E")
```
For any other behaviour, custom specs can be added to
`find-temp-custom-spec`.
```lisp
(setq find-temp-custom-spec '((?D . (lambda () (format-time-string "%m"))))
```
