(menu-bar-mode -1)
(tool-bar-mode -1)
(global-linum-mode t)
(global-hl-line-mode t)
(fringe-mode -1)

(evil-leader/set-key "d" 'dired)

(defun indent-buffer ()
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))
(evil-leader/set-key "r" 'indent-buffer)


(defadvice linum-update-window (around linum-dynamic activate)
  (let* ((w (length (number-to-string
                     (count-lines (point-min) (point-max)))))
         (linum-format (concat " %" (number-to-string w) "d ")))
    ad-do-it))

(use-package hlinum
  :ensure f
  :config
  (hlinum-activate))


(use-package grizzl
  :ensure f
  :config
  (setq projectile-completion-system 'grizzl))
(use-package ivy
  :ensure f
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

(use-package spacemacs-theme
  :ensure f)
(load-theme 'spacemacs-dark t)

(setq default-frame-alist
      '((fullscreen . maximized) (fullscreen-restore . fullheight)))

(setq *bretts-face* "Fira Code Retina-18")
(add-to-list 'default-frame-alist
             `(font . ,*bretts-face*))

(set-face-attribute
 'default nil
 :font *bretts-face*)
(set-face-attribute
 'default t
 :font *bretts-face*)
