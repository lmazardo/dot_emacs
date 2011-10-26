;; Python setup
(defcustom py-hide-show-keywords '("class" "def" "elif" "else" "except"
  "for" "if" "while" "finally" "try" "with")
   "*Keywords used by hide-show"
   :type '(repeat string)
   :group 'python)

(defcustom py-hide-show-hide-docstrings t
  "*If doc strings shall be hidden"
  :type 'boolean
  :group 'python)

(add-to-list 'hs-special-modes-alist (list
                'python-mode (concat (if py-hide-show-hide-docstrings "^\\s-*\"\"\"\\|" "") (mapconcat 'identity (mapcar #'(lambda (x) (concat "^\\s-*" x "\\>")) py-hide-show-keywords ) "\\|")) nil "#"
                (lambda (arg)
                 (py-goto-beyond-block)
                 (skip-chars-backward " \t\n"))
                nil))

(defun lookup-pydoc () ;; was hohe2-lookup-pydoc
  (interactive)
  (let ((curpoint (point)) (prepoint) (postpoint) (cmd))
    (save-excursion
      (beginning-of-line)
      (setq prepoint (buffer-substring (point) curpoint)))
    (save-excursion
      (end-of-line)
      (setq postpoint (buffer-substring (point) curpoint)))
    (if (string-match "[_a-z][_\\.0-9a-z]*$" prepoint)
        (setq cmd (substring prepoint (match-beginning 0) (match-end 0))))
    (if (string-match "^[_0-9a-z]*" postpoint)
        (setq cmd (concat cmd (substring postpoint (match-beginning 0) (match-end 0)))))
    (if (string= cmd "") nil
      (let ((max-mini-window-height 0))
        (shell-command (concat "pydoc " cmd))))))

(require 'pymacs)
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)

(when (load "flymake" t)
  (defun flymake-pylint-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "epylint" (list local-file))))
  
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pylint-init)))

(add-hook 'python-mode-hook 
	  '(lambda ()
	     (local-set-key [C-prior] 'py-beginning-of-def-or-class)
	     (local-set-key [C-next] 'py-end-of-def-or-class)
	     (local-set-key [C-return] 'ido-goto-symbol)
	     (local-set-key (kbd "C-'") 'hippie-expand)
	     (local-set-key (kbd "C-h f") 'lookup-pydoc)
	     (local-set-key [f7] 'flymake-mode)
	     (hs-minor-mode t)
	     (hideshowvis-enable)))

(message "python.el configuration is loaded")