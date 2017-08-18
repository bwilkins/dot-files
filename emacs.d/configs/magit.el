(use-package magit
  :ensure f
  :defer 1
  :config
  (evil-leader/set-key "gs" 'magit-status))
