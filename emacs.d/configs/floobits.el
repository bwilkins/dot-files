(use-package floobits
  :ensure t
  :defer 1
  :config
  (evil-leader/set-key
    "Pt" 'floobits-follow-mode-toggle
    "Pj" 'floobits-join-workspace
    "Pl" 'floobits-leave-workspace
    "Pf" 'floobits-follow-user
    "Ps" 'floobits-summon
    )
  )
