(use-package js3-mode
  :ensure t
  :defer 1
  :config
  (use-package handlebars-mode
    :ensure nil)
  (use-package handlebars-sgml-mode
    :ensure nil
    :config
    (handlebars-use-mode 'minor)))
