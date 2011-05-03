;; Add support for HideShow visual
(autoload 'hideshowvis-enable "hideshowvis" "Highlight foldable regions")
(autoload 'hideshowvis-minor-mode
  "hideshowvis"
  "Will indicate regions foldable with hideshow in the fringe."
  'interactive)

(dolist (hook (list 'emacs-lisp-mode-hook
                    'c++-mode-hook
		    'js2-mode-hook))
  (add-hook hook 'hideshowvis-enable))


(defun toggle-hiding (column)
  (interactive "P")
  (if hs-minor-mode
      (if (condition-case nil
              (hs-toggle-hiding)
            (error t)) 
          (hs-show-all))
    (toggle-selective-display column)))


(setq tab-width 2)
(setq indent-tabs-mode nil)
(global-set-key (kbd "C-+") 'toggle-hiding)
(global-set-key (kbd "C-=") 'comment-or-uncomment-region)

;; ido-mode and imenu
(defun ido-goto-symbol (&optional symbol-list)
  "Refresh imenu and jump to a place in the buffer using Ido."
  (interactive)
  (unless (featurep 'imenu)
    (require 'imenu nil t))
  (cond
   ((not symbol-list)
    (let ((ido-mode ido-mode)
	  (ido-enable-flex-matching
	   (if (boundp 'ido-enable-flex-matching)
	       ido-enable-flex-matching t))
	  name-and-pos symbol-names position)
      (unless ido-mode
	(ido-mode 1)
	(setq ido-enable-flex-matching t))
      (while (progn
	       (imenu--cleanup)
	       (setq imenu--index-alist nil)
	       (ido-goto-symbol (imenu--make-index-alist))
	       (setq selected-symbol
		     (ido-completing-read "Symbol? " symbol-names))
	       (string= (car imenu--rescan-item) selected-symbol)))
      (setq position (cdr (assoc selected-symbol name-and-pos)))
      (cond
       ((overlayp position)
	(goto-char (overlay-start position)))
       (t
	(goto-char position)))))
   ((listp symbol-list)
    (dolist (symbol symbol-list)
      (let (name position)
	(cond
	 ((and (listp symbol) (imenu--subalist-p symbol))
	  (ido-goto-symbol symbol))
	 ((listp symbol)
	  (setq name (car symbol))
	  (setq position (cdr symbol)))
	 ((stringp symbol)
	  (setq name symbol)
	  (setq position
		(get-text-property 1 'org-imenu-marker symbol))))
	(unless (or (null position) (null name)
		    (string= (car imenu--rescan-item) name))
	  (add-to-list 'symbol-names name)
	  (add-to-list 'name-and-pos (cons name position))))))))

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

;; Javascript mode
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
 
(setq js2-basic-offset 2)
(setq js2-use-font-lock-faces t)

(add-hook 'js2-mode-hook 
	  '(lambda ()
	     (local-set-key (kbd "C-+") 'js2-mode-toggle-element)))


(message "coding.el is loaded")
