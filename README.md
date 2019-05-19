flycheck-janet - Flycheck for Janet
===============================

[![License GPL 3][badge-license]][license]

Flycheck-janet is a syntax checker definition for flycheck which supports
the [Janet][] programming language using the janet compiler as the backend.
Note that your version of Janet must support the `-k` option. Also, current
limitations in the 'compile only' feature of `janet` mean that imports will
not be considerd correctly, leading to erroneous errors in some situations.

Installation
------------

Obtain [Flycheck][] from [MELPA][] or your favorite source. Then, insure that
`flycheck-janet.el` is in your load-path and add

    (require 'flycheck-janet)

to your `init.el`.

[badge-license]: https://img.shields.io/badge/license-GPL_3-green.svg?dummy
[license]: https://github.com/ALSchwalm/flycheck-janet/blob/master/LICENSE
[Flycheck]: https://github.com/flycheck/flycheck
[Janet]: https://janet-lang.org/
[MELPA]: http://melpa.milkbox.net
