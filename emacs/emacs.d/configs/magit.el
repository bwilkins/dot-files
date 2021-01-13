(use-package magit
  :ensure t
  :straight magit
  :config
  (evil-leader/set-key "gs" 'magit-status))
