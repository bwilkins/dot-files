(setq --reading-text-width 82)
(defun --set-reading-margins ()
  "Disable line numbers and set margins to roughly centre text"
  (interactive)
  (display-line-numbers-mode 0)
  ;(set-window-margins nil 20 20)
  (let ((--new-margin (and --reading-text-width
                          (/ (max 0 (- (window-total-width)
                                       --reading-text-width))
                             2))))
    (setq left-margin-width --new-margin)
    (setq right-margin-width --new-margin)
    )
  )

(use-package nov
  :straight nov
  :config
  (setq nov-text-width 80)
  (setq nov-variable-pitch t)
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

  (defun --nov-font-setup ()
    (face-remap-add-relative 'variable-pitch :family "Baskerville"
                                           :height 1.0))
  (add-hook 'nov-mode-hook '--nov-font-setup)

  (defun --nov-margins ()
    (add-hook 'after-change-major-mode-hook '--set-reading-margins :append :local)
    ; I can't seem to get the following to work...
    ;(add-hook 'window-configuration-change-hook '--set-reading-margins :append :local)
    )
  (add-hook 'nov-mode-hook '--nov-margins)

  )

(if (eq system-type 'darwin)
    (setenv "PKG_CONFIG_PATH" "/usr/local/Cellar/zlib/1.2.8/lib/pkgconfig:/usr/local/lib/pkgconfig:/opt/X11/lib/pkgconfig")
  )
(use-package pdf-tools
  :straight pdf-tools
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install :no-query))
