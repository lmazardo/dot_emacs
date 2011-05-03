;; remove {menu,tool}bar , display time using particular format
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq-default fill-column 72)
(setq auto-fill-mode 1)
(setq inhibit-startup-message t)
(setq column-number-mode t)
(setq line-number-mode t)
(defface my-display-time
  '((((type x w32 mac))
     (:foreground "pink" :background "black" : :inherit bold))
    (((type tty))
     (:foreground "blue")))
  "Face used to display the time in the mode line.")
(setq display-time-string-forms
      '((propertize (concat " " 24-hours ":" minutes " ")
 		    'face 'my-display-time)))

(display-time)


(which-func-mode)

(require 'color-theme)
(require 'icicles)


(load-library "my-color-theme")
(global-font-lock-mode 1)
(color-theme-ryan)

;; visual editing
(transient-mark-mode t)
(show-paren-mode t)
(setq show-paren-style 'expression)
(global-font-lock-mode t) ;; automatic colorization
(blink-cursor-mode 0)

;; ido mode configuration
(ido-mode t)
(setq ido-enable-regexp t)
(setq ido-enable-flex-matching t)
(setq ido-execute-command-cache nil)
(ido-everywhere t)

(when (require 'recentf)
  (setq recentf-auto-cleanup 'never) ;; évite de vérifier les fichiers distants au démarrage
  (recentf-mode 1))

; elscreen is screen for emacs (the key is C-z)
(require 'elscreen)

;; globals keys and mouse config
(mouse-wheel-mode t)
(load-library "keys")

(require 'highlight-current-line)
(highlight-current-line-on t)
 
(load-library "coding")

(require 'yasnippet)
(yas/initialize)
(setq yas/root-directory '("~/etc/emacs/snippets"
      "/usr/share/emacs/site-lisp/yasnippet/snippets/"))
(mapc 'yas/load-directory yas/root-directory)


(defun move-region (start end n)
  "Move the current region up or down by N lines."
  (interactive "r\np")
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (let ((start (point)))
      (insert line-text)
      (setq deactivate-mark nil)
      (set-mark start))))

(defun move-region-up (start end n)
  "Move the current line up by N lines."
  (interactive "r\np")
  (move-region start end (if (null n) -1 (- n))))

(defun move-region-down (start end n)
  "Move the current line down by N lines."
  (interactive "r\np")
  (move-region start end (if (null n) 1 n)))
(defun move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (setq col (current-column))
  (beginning-of-line) (setq start (point))
  (end-of-line) (forward-char) (setq end (point))
  (let ((line-text (delete-and-extract-region start end)))
    (forward-line n)
    (insert line-text)
    ;; restore point to original column in moved line
    (forward-line -1)
    (forward-char col)))

(defun move-line-up (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Move the current line down by N lines."
  (interactive "p")
  (move-line (if (null n) 1 n)))

(defun move-line-region-up (start end n)
  (interactive "r\np")
  (if (region-active-p) (move-region-up start end n) (move-line-up n)))

(defun move-line-region-down (start end n)
  (interactive "r\np")
  (if (region-active-p) (move-region-down start end n) (move-line-down n)))

(global-set-key [M-up] 'move-line-region-up)
(global-set-key [M-down] 'move-line-region-down)


(message "main is loaded")

