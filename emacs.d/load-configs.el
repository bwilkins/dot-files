(require 'package)

;; Have a few repositories here
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Update local package index
(unless package-archive-contents
  (package-refresh-contents))

(load-file "~/.emacs.d/configs/backups.el")
(load-file "~/.emacs.d/configs/evil-mode.el")
(load-file "~/.emacs.d/configs/ui.el")
(load-file "~/.emacs.d/configs/floobits.el")
(load-file "~/.emacs.d/configs/magit.el")
(load-file "~/.emacs.d/configs/org-mode.el")
(load-file "~/.emacs.d/configs/ruby.el")
(load-file "~/.emacs.d/configs/editorconfig.el")
