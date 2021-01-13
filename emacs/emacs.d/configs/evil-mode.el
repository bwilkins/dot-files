(use-package evil
	     :ensure t
	     :straight evil
             :config
	     ;; Enable evil mode! muahahahahah!
	     (evil-mode t)

	     ;; Treat wrapped line scrolling as single lines
	     (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
	     (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
	     ;; esc quits pretty much anything (like pending prompts in the minibuffer)
	     (define-key evil-normal-state-map [escape] 'keyboard-quit)
	     (define-key evil-visual-state-map [escape] 'keyboard-quit)
	     (define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
	     (define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
	     (define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
	     (define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
	     (define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
	     ;; Enable smash escape (ie 'jk' and 'kj' quickly to exit insert mode)
	     (define-key evil-insert-state-map "k" #'cofi/maybe-exit-kj)
	     (evil-define-command cofi/maybe-exit-kj ()
	       :repeat change
	       (interactive)
	       (let ((modified (buffer-modified-p)))
		 (insert "k")
		 (let ((evt (read-event (format "Insert %c to exit insert state" ?j)
					nil 0.5)))
		   (cond
		    ((null evt) (message ""))
		    ((and (integerp evt) (char-equal evt ?j))
		     (delete-char -1)
		     (set-buffer-modified-p modified)
		     (push 'escape unread-command-events))
		    (t (setq unread-command-events (append unread-command-events
							   (list evt))))))))
	     (define-key evil-insert-state-map "j" #'cofi/maybe-exit-jk)
	     (evil-define-command cofi/maybe-exit-jk ()
	       :repeat change
	       (interactive)
	       (let ((modified (buffer-modified-p)))
		 (insert "j")
		 (let ((evt (read-event (format "Insert %c to exit insert state" ?k)
					nil 0.5)))
		   (cond
		    ((null evt) (message ""))
		    ((and (integerp evt) (char-equal evt ?k))
		     (delete-char -1)
		     (set-buffer-modified-p modified)
		     (push 'escape unread-command-events))
		    (t (setq unread-command-events (append unread-command-events
							   (list evt))))))))

	     ;; Add some window movement
	     (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
	     (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
	     (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
	     (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)

	     ;; Anything that requires evil-mode should be setup under here
	     (use-package evil-leader
			  :ensure t
			  :straight evil-leader
                          :config
			  (global-evil-leader-mode)
			  (evil-leader/set-leader ";")
			  (evil-leader/set-key
			    "bb" 'switch-to-buffer
			    "bp" 'previous-buffer
			    "bn" 'next-buffer)))
