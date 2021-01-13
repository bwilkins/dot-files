(use-package js3-mode
  :ensure t
  :straight js3-mode
  :config
  (use-package handlebars-mode
    :straight handlebars-mode
    :ensure nil)
  (use-package handlebars-sgml-mode
    :ensure nil
    :straight handlebars-sgml-mode
    :config
    (handlebars-use-mode 'minor)))
