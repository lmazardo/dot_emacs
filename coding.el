(setq tab-width 2)
(setq indent-tabs-mode nil)

(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
 
(setq js2-basic-offset 2)
(setq js2-use-font-lock-faces t)

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

(add-hook 'python-mode-hook 
	  '(lambda ()
	     (local-set-key [C-prior] 'py-beginning-of-def-or-class)
	     (local-set-key [C-next] 'py-end-of-def-or-class)
	     (local-set-key [C-return] 'ido-goto-symbol)
	     (hs-minor-mode t)))
(require 'pymacs)
(pymacs-load "ropemacs" "rope-")

(setq ropemacs-enable-autoimport t)
(defun toggle-hiding (column)
  (interactive "P")
  (if hs-minor-mode
      (if (condition-case nil
              (hs-toggle-hiding)
            (error t)) 
          (hs-show-all))
    (toggle-selective-display column)))
(defcustom py-hide-show-keywords '("class" "def" "elif" "else" "except"
  "for" "if" "while" "finally" "try" "with")
   "*Keywords used by hide-show"
   :type '(repeat string)
   :group 'python)

(defcustom py-hide-show-hide-docstrings t
  "*If doc strings shall be hidden"
  :type 'boolean
  :group 'python)

;;(python-python-command-arg 
;;(defcustom python-python-command-args '("-i")

;; Add support for HideShow
(add-to-list 'hs-special-modes-alist (list
                'python-mode (concat (if py-hide-show-hide-docstrings "^\\s-*\"\"\"\\|" "") (mapconcat 'identity (mapcar #'(lambda (x) (concat "^\\s-*" x "\\>")) py-hide-show-keywords ) "\\|")) nil "#"
                (lambda (arg)
                 (py-goto-beyond-block)
                 (skip-chars-backward " \t\n"))
                nil))


(global-set-key (kbd "C-+") 'toggle-hiding)
(global-set-key (kbd "C-=") 'comment-or-uncomment-region)


(autoload 'hideshowvis-enable "hideshowvis" "Highlight foldable regions")

(autoload 'hideshowvis-minor-mode
  "hideshowvis"
  "Will indicate regions foldable with hideshow in the fringe."
  'interactive)


(dolist (hook (list 'emacs-lisp-mode-hook
                    'c++-mode-hook 'python-mode-hook) )
  (add-hook hook 'hideshowvis-enable))


(message "coding.el is loaded")
