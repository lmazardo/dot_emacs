(defconst home-elisp-path
  (expand-file-name "~/etc/emacs")
    "Personal path for emacs stuff")

(add-to-list 'load-path home-elisp-path)
(load-library "main")
(message "dot emacs is loaded")
