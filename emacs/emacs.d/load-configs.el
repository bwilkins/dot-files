(require 'package)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Have a few repositories here
(setq package-enable-at-startup nil)
(package-initialize)

(setq
 package-enable-at-startup nil
 package-archives
 '(("melpa-stable" . "http://stable.melpa.org/packages/")
   ("melpa" . "http://melpa.org/packages/")
   ("org"         . "http://orgmode.org/elpa/")
   ("gnu"         . "http://elpa.gnu.org/packages/")))


(straight-use-package 'use-package)

;; Update local package index
(unless package-archive-contents
  (package-refresh-contents))

(load-file "~/.emacs.d/configs/backups.el")
(load-file "~/.emacs.d/configs/evil-mode.el")
(load-file "~/.emacs.d/configs/ui.el")
(load-file "~/.emacs.d/configs/magit.el")
(load-file "~/.emacs.d/configs/org-mode.el")
(load-file "~/.emacs.d/configs/ruby.el")
(load-file "~/.emacs.d/configs/editorconfig.el")
(load-file "~/.emacs.d/configs/markdown.el")
(load-file "~/.emacs.d/configs/ebooks.el")
