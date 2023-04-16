;;; my-init-colorscheme.el -*- lexical-binding: t; -*-

(straight-use-package 'doom-themes)
(straight-use-package 'spacemacs-theme)
(straight-use-package 'ef-themes)

(setq my$day-themes
      '(doom-solarized-light
        spacemacs-light
        doom-one-light
        ef-tritanopia-light
        ef-cyprus
        ef-light)
      my$night-themes
      '(spacemacs-dark
        doom-one
        doom-nord-aurora
        doom-opera
        ef-dark))

(when (display-graphic-p)
    (add-to-list 'my$night-themes 'modus-vivendi)
    (add-to-list 'my$day-themes 'modus-operandi))

(my:theme-set-dynamically)

(use-package doom-themes-ext-org
    :if (string-match-p "doom" (symbol-name my$selected-theme))
    :after org
    :demand t)

(provide 'my-init-colorscheme)
;;; my-init-colorscheme.el ends here
