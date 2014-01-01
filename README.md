# find-temp-file

This library allows you to open quickly a temporary file of a given
extension. No need to specify a name, just an extension.

## Installation

Just put this file in your load path and require it:
```lisp
(require 'find-temp-file)
```

You may want to bind `find-temp-file' to a convenient keystroke. In my
setup, I bind it to "C-x C-t".

## Examples

The following setting stores temporary files in
`~/Draft/<MODE-NAME>/<FILE-NAME>`. You can add your own spec with
`find-temp-custom-spec`.

```lisp
(setq find-temp-template-default "~/draft/%M/%N-%S.%E")
```
