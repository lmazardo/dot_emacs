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
(global-set-key [C-tab] 'other-window)
(global-set-key [C-return] 'kill-this-buffer)
(global-set-key [(control >)]    'bs-cycle-next)
(global-set-key [(control <)]   'bs-cycle-previous)
(global-set-key [f5]     'linum-mode)
(global-set-key [f6]     'menu-bar-mode)
(global-set-key [f7]     'anything)
(global-set-key [f8]     'next-error)
(global-set-key [f9]     'compile) ;;my-compile-or-tramp-compile)
(define-key global-map "\eg"    'goto-line)

(require 'highlight-current-line)
(highlight-current-line-on t)
 
(load-library "coding")

(require 'yasnippet)
(yas/initialize)
(setq yas/root-directory '("~/etc/emacs/snippets"
      "/usr/share/emacs/site-lisp/yasnippet/snippets/"))
(mapc 'yas/load-directory yas/root-directory)


(message "main is loaded")

