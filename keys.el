;; ==================== INUTILE DEJA DEFINIES ====================
;; already bind via simple.el
;; (global-set-key [home] 'beginning-of-line)
;; (global-set-key [end] 'end-of-line) 
;; (global-set-key [backspace] 'backward-delete-char-untabify)
;; (global-set-key [(control space)] 'set-mark-command)
;; (global-set-key [(control insert)] 'kill-ring-save)
;; (global-set-key [(shift insert)] 'yank)
;; (global-set-key [(control home)] 'beginning-of-buffer)
;; (global-set-key [(control end)] 'end-of-buffer)
;; (global-set-key [(control left)] 'backward-word)
;; (global-set-key [(control right)] 'forward-word)
;; (global-set-key [(control o)] 'open-line)

;; already bind via paragraphs.el
;; (global-set-key [(control down)] 'forward-paragraph)
;; (global-set-key [(control up)] 'backward-paragraph)



(defun beginning-of-page () (interactive) (move-to-window-line 0))
(defun end-of-page () (interactive) (move-to-window-line -1))
(global-set-key [(control kp-begin)] 'move-to-window-line)
(global-set-key [(control kp-down)] 'end-of-page)
(global-set-key [(control kp-up)] 'beginning-of-page)

(defun delete-char-or-region() (interactive) (if mark-active (delete-region (point) (mark)) (delete-char 1)))
(global-set-key [delete] 'delete-char-or-region)

(global-set-key [(control return)] 'newline-and-indent)
(global-set-key [(control delete)] 'kill-region)


(global-set-key [?\e ?s] 'point-to-register)  ;; M-s
(global-set-key [?\e ?r] 'jump-to-register) ;;  M-r


(global-set-key [?\e backspace] 'backward-kill-word)
(global-set-key [?\e delete] 'kill-word)

(global-set-key [?\e ?g] 'goto-line)


(global-set-key [C-tab] 'other-window)
(global-set-key [M-return] 'kill-this-buffer)
(global-set-key [(control >)]    'bs-cycle-next)
(global-set-key [(control <)]   'bs-cycle-previous)
(global-set-key [f5]     'linum-mode)
(global-set-key [f6]     'menu-bar-mode)
(global-set-key [f8]     'next-error)
(global-set-key [f9]     'compile) ;;my-compile-or-tramp-compile)

