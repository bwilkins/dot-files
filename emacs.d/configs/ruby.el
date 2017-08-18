(use-package enh-ruby-mode
  :ensure f
  :defer 1
  :config

  (use-package rspec-mode
    :ensure f
    :defer 1)

  (use-package robe
    :ensure f
    :defer 1)

  (use-package ruby-end
    :ensure f
    :defer 1)

  (use-package rbenv
    :ensure f
    :defer 1
    :config
    (global-rbenv-mode))
  (use-package inf-ruby
    :ensure t
    :defer 1
    :config
    
    (defun comint-goto-end-and-insert ()
      (interactive)
      (if (not (comint-after-pmark-p))
	  (progn (comint-goto-process-mark)
		 (evil-append-line nil))
	(evil-insert 1)))
    (evil-define-key 'normal comint-mode-map "i" 'comint-goto-end-and-insert)
    (evil-define-key 'normal inf-ruby-mode-map "i" 'comint-goto-end-and-insert)

    (evil-define-key 'insert comint-mode-map
      (kbd "<up>") 'comint-previous-input
      (kbd "<down>") 'comint-next-input)))

(add-hook 'enh-ruby-mode-hook 'robe-mode)
(add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode)
(add-hook 'compilation-filter-hook 'inf-ruby-auto-enter)
(add-hook 'dired-mode-hook 'rspec-dired-mode)

(setenv "CAPYBARA_INLINE_SCREENSHOT" "artifact")
