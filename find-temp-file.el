;;; find-temp-file.el --- Open quickly a temporary file

;; Copyright (C) 2012-2013 Sylvain Rousseau <thisirs at gmail dot com>

;; Author: Sylvain Rousseau <thisirs at gmail dot com>
;; Maintainer: Sylvain Rousseau <thisirs at gmail dot com>
;; URL: https://github.com/thisirs/find-temp-file.git
;; Keywords: convenience

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

;; This library allows you to open quickly a temporary file of a given
;; extension. No need to specify a name, just an extension.

;;; Installation:

;; Just put this file in your load path and require it:
;; (require 'find-temp-file)

;; You may want to bind `find-temp-file' to a convenient keystroke. In
;; my setup, I bind it to "C-x C-t".

;;; Examples:

;; (require 'find-temp-file)
;; (global-set-key (kbd "C-x C-t") 'find-temp-file)
;; (setq find-temp-file-directory "~/deathrow/drafts/")
;; (setq find-temp-template-default "%D/%M/%N-%S.%E")

;;; Code

(require 'format-spec)

(defvar find-temp-file-directory "/tmp/"
  "Directory where temporary files are created.")

(defvar find-temp-file-prefix
  '("alpha" "bravo" "charlie" "delta" "echo" "foxtrot" "golf" "hotel"
    "india" "juliet" "kilo" "lima" "mike" "november" "oscar" "papa"
    "quebec" "romeo" "sierra" "tango" "uniform" "victor" "whiskey"
    "x-ray" "yankee" "zulu")
  "Successive names of temporary files.")

(defvar find-temp-template-alist
  '(("m" . "%N_%S.%E"))
  "Alist with file extensions and corresponding file name
template.

%N: prefix taken from `find-temp-file-prefix'
%S: shortened sha-1 of the extension
%E: extension
%M: replace by mode name associated with the extension
%D: date with format %Y-%m-%d

The default template is stored in `find-temp-template-default'.")

(defvar find-temp-template-default
  "%N-%S.%E"
  "Default template for temporary files.")

(defvar find-temp-custom-spec ()
  "Additionnal specs that supersede default ones.")

(defvar find-temp-add-to-history t
  "Add containing folder to file name history when a temporary
file is created.")

;;;###autoload
(defun find-temp-file (extension)
  "Open a file temporary file.

EXTENSION is the extension of the temporary file. If EXTENSION
contains a dot, use EXTENSION as the full file name."
  (interactive
   (let* ((default (concat (if buffer-file-name
                               (file-name-extension
                                buffer-file-name))))
          (default-prompt (if (equal default "") ""
                            (format " (%s)" default)))
          choice)
     (setq choice
           (read-string
            (format "Extension%s: " default-prompt)))
     (list (if (equal "" choice)
               default
             choice))))
  (setq extension (or extension ""))
  (let ((file-path (find-temp-file--filename extension)))
    (make-directory (file-name-directory file-path) :parents)
    (if find-temp-add-to-history
        (add-to-history 'file-name-history (file-name-directory file-path)))
    (find-file file-path))
  (basic-save-buffer))

(defun find-temp-file--filename (&optional extension-or-file)
  "Return a full path of a temporary file to be opened. If
EXTENSION-OR-FILE contains a dot, it is used as file-name. If
not, it assumes it is the extension of the temporary file, a
unique and recognizable name is automatically constructed."
  (let (file-name extension file-template template)
    (if (memq ?. (string-to-list extension-or-file))
        (setq file-name extension-or-file
              extension (file-name-extension extension-or-file))
      (setq extension extension-or-file))

    (setq template
          (or
           (and extension
                (assoc-default extension find-temp-template-alist 'string-match))
           find-temp-template-default))

    (setq file-template
          (expand-file-name
           (format-spec
            template
            (append
             find-temp-custom-spec
             `((?E . ,extension)
               (?S . ,(substring (sha1 extension) 0 5))
               (?M . ,(symbol-name
                       (assoc-default (concat "." extension)
                                      auto-mode-alist
                                      'string-match)))
               (?D . ,(format-time-string "%Y-%m-%d"))
               (?N . "%N"))))
           find-temp-file-directory))

    (if file-name
        (expand-file-name file-name (file-name-directory file-template))
      (catch 'found
        (mapc (lambda (prefix)
                (setq file-name
                      (format-spec
                       file-template
                       `((?N . ,prefix))))

                (unless (file-exists-p file-name)
                  (throw 'found file-name)))
              find-temp-file-prefix)))))

(provide 'find-temp-file)

;;; find-temp-file.el ends here
