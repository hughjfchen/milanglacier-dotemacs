;;; my-init-evil.el -*- lexical-binding: t; -*-

(straight-use-package 'evil)
(straight-use-package 'evil-goggles)
(straight-use-package 'evil-escape)
(straight-use-package 'better-jumper)
(straight-use-package 'evil-anzu)
(straight-use-package 'evil-surround)
(straight-use-package 'evil-embrace)
(straight-use-package 'evil-snipe)
(straight-use-package 'evil-traces)
(straight-use-package 'evil-exchange)
(straight-use-package 'evil-nerd-commenter)
(straight-use-package 'evil-visualstar)
(straight-use-package 'evil-replace-with-register)
(straight-use-package 'evil-args)
(straight-use-package 'exato)
(straight-use-package 'evil-lion)
(straight-use-package 'evil-vimish-fold)
(straight-use-package 'evil-indent-plus)
(straight-use-package 'evil-numbers)
(straight-use-package 'expand-region)
(straight-use-package 'evil-collection)
(straight-use-package 'evil-matchit)

(use-package evil-goggles
    :init
    (setq evil-goggles-duration 0.5
          evil-goggles-pulse nil
          evil-goggles-enable-delete nil
          evil-goggles-enable-change nil))

(use-package evil-escape
    :init
    (setq evil-escape-key-sequence "jk"))

(use-package evil-embrace
    :commands (embrace-add-pair embrace-add-pair-regexp)
    :hook ((LaTeX-mode . embrace-LaTeX-mode-hook)
           (org-mode . embrace-org-mode-hook)
           (emacs-lisp-mode . embrace-emacs-lisp-mode-hook)))

(use-package evil-nerd-commenter
    :commands (evilnc-comment-operator
               evilnc-inner-commenter
               evilnc-outer-commenter)
    :config
    (general-define-key
     [remap comment-line] #'evilnc-comment-or-uncomment-lines))

(use-package evil-snipe
    :init
    (setq evil-snipe-smart-case t
          evil-snipe-scope 'buffer
          evil-snipe-use-vim-sneak-bindings t
          evil-snipe-repeat-keys nil
          evil-snipe-char-fold t)
    )

(use-package evil-vimish-fold
    :init
    (setq evil-vimish-fold-target-modes '(prog-mode conf-mode text-mode)))

(use-package evil-anzu
    :demand t
    :after anzu)

(use-package better-jumper
    :config
    (general-create-definer my/jump-map
        :prefix "SPC j"
        :non-normal-prefix "M-SPC j"
        :prefix-map 'my/jump-map)
    (my/jump-map
        :states '(motion insert normal)
        :keymaps 'override
        "" '(:ignore t :which-key "jump")
        "o" #'better-jumper-jump-backward
        "i" #'better-jumper-jump-forward)
    )

(use-package evil-collection
    :init
    (setq evil-collection-mode-list
          '(arc-mode bm bookmark consult comint compile eldoc daemons
                     debug diff-hl diff-mode dired dired-sidebar
                     docker doc-view elisp-refs embark eldoc eshell
                     eww flymake grep help helpful ibuffer imenu
                     macrostep magit-sections magit magic-todos man
                     markdown-mode mu4e mu4e-conversation notmuch org
                     org-roam osx-dictionary pdf python replace rg
                     ripgrep tab-bar term vertico vterm wdired wgrep
                     which-key xref xwidget)
          evil-collection-key-blacklist '("SPC" "gj" "gk")
          evil-collection-want-unimpaired-p nil))
;; I used SPC SPC as my local leader key. So SPC shouldn't be occupied
;; even in local mode map.

(use-package evil
    :init
    (setq evil-want-C-i-jump t
          evil-want-C-u-scroll nil
          evil-want-Y-yank-to-eol t
          evil-want-C-u-delete t
          ;; in insert mode use C-o C-u instead or M-SPC u instead
          evil-want-C-h-delete t
          ;; In insert mode use M-SPC u instead
          evil-want-C-w-delete t
          evil-want-keybinding nil
          evil-want-abbrev-expand-on-insert-exit t
          evil-visual-update-x-selection-p nil
          evil-mode-line-format nil
          evil-ex-search-vim-style-regexp t
          evil-ex-visual-char-range t
          evil-mode-line-format nil
          evil-normal-state-cursor 'box
          evil-insert-state-cursor 'bar
          evil-emacs-state-cursor 'box
          evil-visual-state-cursor 'hollow
          evil-ex-interactive-search-highlight 'selected-window
          ;; It's infuriating that innocuous "beginning of line" or "end of line"
          ;; errors will abort macros, so suppress them:
          evil-kbd-macro-suppress-motion-error t
          evil-undo-system 'undo-redo
          evil-ex-hl-update-delay 0.1)

    ;; NOTE: `evil-mode' must be enabled here.  otherwise those
    ;; autoloaded function will try to load `my-evil-autoloads' before
    ;; evil is loaded, which results in error since I used macros from
    ;; `evil' there. The reason may be that `eval-after-load' form
    ;; needs to evaluate macros before the execution. And I defined an
    ;; autoloaded macro in my autoload files, which results in my
    ;; autoload files being loaded which contains an
    ;; `evil-define-operator` command from evil.
    (evil-mode 1)

    :config
    ;; TODO: lazy load these evil modules
    ;; (reference from doomemacs)

    (evil-select-search-module 'evil-search-module 'evil-search)
    (evil-goggles-mode)
    (evil-escape-mode)
    (global-evil-surround-mode)
    (evil-embrace-enable-evil-surround-integration)
    (evil-traces-mode)
    (evil-exchange-install)
    (evil-snipe-mode)
    (evil-snipe-override-mode)
    (global-evil-visualstar-mode)
    (better-jumper-mode)
    (global-evil-vimish-fold-mode)
    (global-anzu-mode)
    (global-evil-matchit-mode)
    (evil-collection-init)

    ;; TODO: doom hacks a lot of advices. However I don't really understand them.
    ;; (Maybe I don't face the situations where I need those advices).  Leave this
    ;; comment for the purpopse of future reminder.  If one day I met those
    ;; situations, I could still go to doom for references.

    ;; save-excursion before making indentation
    (advice-add #'evil-indent :around #'my/save-excursion-before-indenting)

    (general-define-key
     :states 'visual
     "@" #'my/evil-apply-macro-line-by-line
     "Z" #'evil-snipe-S)

    (general-define-key
     :states '(motion normal)
     [remap evil-jump-backward] #'better-jumper-jump-backward
     [remap evil-jump-forward] #'better-jumper-jump-forward
     "]a" #'evil-forward-arg
     "[a" #'evil-backward-arg
     ;; compilation is similiar to vim's quickfix list.
     "]q" #'next-error
     "[q" #'previous-error
     "[b" #'evil-prev-buffer
     "]b" #'evil-next-buffer
     "[n" #'my/previous-SCM-conflict-marker
     "]n" #'my/next-SCM-conflict-marker)

    (general-define-key
     :states '(normal visual)
     "gc" #'evilnc-comment-operator
     "gd" #'xref-find-definitions
     "gr" #'xref-find-references
     "C-w gd" #'xref-find-definitions-other-window
     "ga" #'evil-lion-left
     "gA" #'evil-lion-right
     "C-a" #'evil-numbers/inc-at-pt
     "C-q" #'evil-numbers/dec-at-pt ;; C-x is so important in emacs
     "g C-a" #'evil-numbers/inc-at-pt-incremental
     "g C-x" #'evil-numbers/dec-at-pt-incremental
     "RET" #'er/expand-region
     "gs" #'evil-replace-with-register
     "g@" #'my/evil-apply-macro-line-by-line)

    (general-define-key
     :states 'insert
     "C-a" #'move-beginning-of-line
     "C-e" #'move-end-of-line
     "C-p" #'previous-line
     "C-n" #'next-line
     "C-k" #'kill-line)

    (general-define-key
     :keymaps 'in
     ;; TODO: configure emacs-lisp mode to use space as args delimiter.
     "a" #'evil-inner-arg
     "#" #'evilnc-inner-commenter
     "i" #'evil-indent-plus-i-indent
     "j" #'evil-indent-plus-i-indent-up-down
     "k" #'evil-indent-plus-i-indent-up
     "x" #'evil-inner-xml-attr)

    (general-define-key
     :keymaps 'out
     "a" #'evil-outer-arg
     "#" #'evilnc-outer-commenter
     "i" #'evil-indent-plus-i-indent
     "j" #'evil-indent-plus-i-indent-up-down
     "k" #'evil-indent-plus-i-indent-up
     "x" #'evil-outer-xml-attr)

    (my/define-and-bind-paren-text-object "$" "\\$" "\\$")
    (my/define-and-bind-paren-text-object "|" "|" "|")
    (my/define-and-bind-paren-text-object "=" "=" "=")
    (my/define-and-bind-paren-text-object "~" "~" "~")

    (general-define-key
     :keymaps '(evil-ex-completion-map evil-ex-search-keymap)
     "C-p" #'previous-complete-history-element
     "C-n" #'next-complete-history-element
     "C-k" #'kill-line
     "C-b" #'backward-char
     "C-f" #'forward-char
     "C-a" #'move-beginning-of-line)

    (my/open-map
        :keymaps 'override
        :states '(motion visual insert normal)
        ":" #'evil-command-window-ex)

    (my/toggle-map
        :keymaps 'override
        :states '(motion insert normal)
        "h" #'evil-ex-nohighlight)

    (general-create-definer my/window-map
        :prefix "SPC w"
        :non-normal-prefix "M-SPC w"
        :prefix-map 'my/window-map)

    (my/window-map
        :states '(motion insert normal)
        :keymaps 'override
        "" '(:ignore t :which-key "window")
        "w" #'evil-window-next
        "p" #'evil-window-mru
        "W" #'evil-window-prev
        "s" #'evil-window-split
        "v" #'evil-window-vsplit
        "h" #'evil-window-left
        "j" #'evil-window-down
        "k" #'evil-window-up
        "l" #'evil-window-right
        "q" #'evil-quit
        "o" #'delete-other-windows
        "=" #'balance-windows
        "+" #'evil-window-increase-height
        "-" #'evil-window-decrease-height
        ":" #'evil-ex
        "<" #'evil-window-increase-width
        ">" #'evil-window-increase-width
        "_" #'evil-window-set-height
        "|" #'evil-window-set-width
        "c" #'evil-window-delete
        "gd" #'xref-find-definitions-other-window
        "x" #'evil-window-exchange
        "r" #'evil-window-rotate-downwards
        "R" #'evil-window-rotate-upwards
        "H" #'evil-window-move-far-left
        "J" #'evil-window-move-very-bottom
        "K" #'evil-window-move-very-top
        "L" #'evil-window-move-far-right)

    (general-create-definer my/buffer-map
        :prefix "SPC b"
        :non-normal-prefix "M-SPC b"
        :prefix-map 'my/buffer-map)

    (my/buffer-map
        :states '(motion insert normal)
        :keymaps 'override
        "" '(:ignore t :which-key "buffer")
        "d" #'evil-delete-buffer
        "[" #'previous-buffer
        "]" #'next-buffer
        "s" #'consult-buffer
        "i" #'ibuffer
        "SPC" #'display-buffer
        "s" #'switch-to-buffer
        "o" #'display-buffer)

    )

(provide 'my-init-evil)
;;; my-init-evil.el ends here
