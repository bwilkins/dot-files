; (use-package org-gcal
;   :after org
;   :straight org-gcal
;   :config
;   (setq org-gcal-client-id ""
;         org-gcal-client-secret ""
;         org-gcal-file-alist '(
; 			      ("brett@brett.geek.nz" . "~/org/brett@brett.geek.nz.org")
; 			      ("brett@cogent.co" . "~/org/brett@cogent.co.org")
; 			      )
;         org-gcal-header-alist '(("brett@brett.geek.nz" . "#+PROPERTY: TIMELINE_FACE \"pink\"\n"))
;         org-gcal-auto-archive nil
;         org-gcal-notify-p nil
; 	org-gcal-recurring-events-mode t
; 	)
;
;   (add-hook 'org-agenda-mode-hook 'org-gcal-fetch)
;   (add-hook 'org-capture-after-finalize-hook 'org-gcal-fetch))
