;;; my-init-completion.el -*- lexical-binding: t; -*-

(straight-use-package 'company)
(straight-use-package 'company-box)
(straight-use-package 'cape)

(use-package company
    :defer t

    :init
    (setq company-minimum-prefix-length 2
          company-dabbrev-minimum-length 3
          company-tooltip-limit 14
          company-tooltip-align-annotations t
          company-require-match 'never
          company-files-exclusions '(".git/" ".DS_Store")
          company-global-modes '(not vterm-mode)
          company-frontends '(company-pseudo-tooltip-frontend
                              ;; always show candidates in overlay tooltip
                              company-echo-metadata-frontend)
          company-backends '((company-capf company-files :separate company-dabbrev
                                           :with company-yasnippet))
          company-auto-commit nil
          company-dabbrev-other-buffers nil
          company-dabbrev-ignore-case t
          company-dabbrev-downcase nil
          company-selection-wrap-around t)

    (my/run-hook-once evil-insert-state-entry-hook global-company-mode)
    (add-hook 'global-company-mode-hook #'company-tng-mode)

    :config
    (add-hook 'company-mode-hook #'evil-normalize-keymaps)
    (evil-make-overriding-map company-mode-map)

    (unless (display-graphic-p)
        ;; Don't persist company popups when switching back to normal mode.
        ;; `company-box' aborts on mode switch so it doesn't need this.
        (add-hook 'evil-normal-state-entry-hook
                  (defun my/company-abort ()
                      (when company-candidates
                          (company-abort)))))

    (with-eval-after-load 'company-files
        ;; Fix `company-files' completion for org file:* links
        (add-to-list 'company-files--regexps "file:\\(\\(?:\\.\\{1,2\\}/\\|~/\\|/\\)[^\]\n]*\\)"))

    (when (display-graphic-p)
        (add-hook 'company-mode-hook #'company-box-mode))

    (general-define-key :keymaps
                        'company-active-map
                        "C-e" #'company-abort)
    (general-define-key :keymaps
                        'company-mode-map
                        "M-i" #'company-complete)
    ;; We follow a suggestion by company maintainer u/hvis:
    ;; https://www.reddit.com/r/emacs/comments/nichkl/comment/gz1jr3s/
    (defun my/company-completion-styles (capf-fn &rest args)
        (let ((completion-styles '(basic partial-completion emacs22)))
            (apply capf-fn args)))

    (advice-add #'company-capf :around #'my/company-completion-styles))

(use-package company-box
    :defer t

    :config
    (setq company-box-max-candidates 50
          company-frontends '(company-tng-frontend company-box-frontend)
          company-box-icons-alist 'company-box-icons-all-the-icons))

(provide 'my-init-completion)
;;; my-init-completion.el ends here
