;;; flycheck-janet.el --- Defines a flycheck syntax checker for Janet

;; Copyright (c) 2019 Adam Schwalm

;; Author: Adam Schwalm <adamschwalm@gmail.com>
;; Version: 0.1.0
;; URL: https://github.com/ALSchwalm/flycheck-janet
;; Package-Requires: ((dash "2.4.0") (flycheck "0.20"))

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Adds Janet support to flycheck

;;; Code:

(require 'flycheck)

(defun flycheck-janet-position-to-error-pos (errors)
  "Convert the ERRORS from janet to column and line positions.
This function assume the line and column values are start and
end point positions for the error."
  (seq-do (lambda (err)
            (let* ((start-point (flycheck-error-line err))
                  (file-name (flycheck-error-filename err))
                  (buffer (get-file-buffer file-name)))
              (when (and start-point buffer)
                (with-current-buffer buffer
                 (save-excursion
                   (goto-char start-point)
                   (setf (flycheck-error-column err)
                         (current-column))
                   (setf (flycheck-error-line err)
                         (1+ (count-lines 1 (point)))))))))
          errors)
  errors)

(flycheck-def-args-var flycheck-janet-args janet)

(flycheck-define-checker janet
  "A syntax checker for the janet programming language.

See http://janet-lang.org"
  :command ("janet" "-k"
            (eval flycheck-janet-args)
            ;; Must use source-inplace so relative imports and
            ;; qualified references to local variables resolve correctly
            source-inplace)
  :error-patterns
  ((error line-start "compile error:" (one-or-more space)
          (message (one-or-more not-newline))
          " at (" line ":" column ") while compiling " (file-name) line-end)
   (error line-start "parse error in " (file-name) " around byte " line ":"
          (message) line-end))
  :error-filter
  (lambda (errors)
    (flycheck-sanitize-errors (flycheck-janet-position-to-error-pos errors)))
  :modes (janet-mode)
  :predicate (lambda () (buffer-file-name)))

(add-to-list 'flycheck-checkers 'janet)

(provide 'flycheck-janet)
;;; flycheck-janet.el ends here
