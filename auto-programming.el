;;; auto-programming.el --- The Auto Programming Solution

;; Copyright (C) 2015 hitode909

;; Author: hitode909 <hitode909@gmail.com>
;; Version: 0.1
;; URL: https://github.com/hitode909/emacs-auto-programming
;; Package-Requires: ((deferred "0.5.0"))

;; This program is free software; you can redistribute it and/or modify
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

;; How To Use
;;
;; Write some code and execute `auto-programming`.
;; You will get candidates of next line of your program.
;;
;; How It Works
;;
;; For example, when you write `(defun` and execute `auto-programming`,
;; 1. git grep (defun
;; 2. Collect the result of git grep
;; 3. Show the result in editor
;; 4. Replace the current line with the selected result
;; 5. Do same thing for the selected result

;;; Code:

(require 'popup)

(defun auto-programming:root ()
  (expand-file-name (concat (find-lisp-object-file-name 'auto-programming 'defun) "/../")))

(defun auto-programming:candidates (script word)
  (split-string-and-unquote (shell-command-to-string (format "perl %s %s" (concat (auto-programming:root) script) (shell-quote-argument word))) "\n")
  )

(defun auto-programming:select (candidates)
  (popup-menu*
   candidates
   :scroll-bar t
   )
  )

(defun auto-programming ()
  (interactive)
  (let* (
         (word (replace-regexp-in-string "^\\s-+\\|\n+" "" (thing-at-point 'line)))
         (candidates (auto-programming:candidates "horizontal.pl" word))
         )
    (if candidates
        (let (
              (selected-word (auto-programming:select candidates))
              )
          (when selected-word
            (delete-backward-char (length word))
            (insert selected-word)
            (auto-programming:vertical)
            )
          )
      (auto-programming:vertical)
      )
    )
  )

(defun auto-programming:vertical ()
  (interactive)
  (let* (
         (word (replace-regexp-in-string "^\\s-+\\|\n+" "" (thing-at-point 'line)))
         (candidates (auto-programming:candidates "vertical.pl" word))
         )
    (if candidates
        (let (
              (selected-word (auto-programming:select candidates))
              )
          (when selected-word
            (newline-and-indent)
            (insert selected-word)
            (auto-programming:vertical)
            )
          )
      (popup-tip "not found")
      )
    )
  )

(provide 'auto-programming)

;;; auto-programming.el ends here
