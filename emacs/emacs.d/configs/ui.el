(evil-leader/set-key "d" 'dired)

(defun indent-buffer ()
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))
(evil-leader/set-key "r" 'indent-buffer)

(global-display-line-numbers-mode)

(use-package grizzl
  :ensure t
  :config
  (setq projectile-completion-system 'grizzl))
(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  (use-package projectile
    :ensure t
    :init
    :defer 1
    :config
    (projectile-mode)
    (evil-leader/set-key "pf" 'projectile-find-file)
    (evil-leader/set-key "pg" 'projectile-grep)))

(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package spacemacs-theme
  :defer t
  :ensure t
  :init (load-theme 'spacemacs-dark t)
  )

(setq default-frame-alist
      '((fullscreen . fullheight) (fullscreen-restore . fullheight)))

(setq *bretts-face* "Dank Mono-18")
(add-to-list 'default-frame-alist
	     `(font . ,*bretts-face*))

(set-face-attribute
 'default nil
 :font *bretts-face*)
(set-face-attribute
 'default t
 :font *bretts-face*)
(set-face-attribute
 'variable-pitch nil
 :font "Libre Baskerville-16")
(set-face-attribute
 'variable-pitch t
 :font "Libre Baskerville-16")
