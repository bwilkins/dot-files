(use-package magit
  :ensure t
  :defer 1
  :config
  (evil-leader/set-key "gs" 'magit-status))
