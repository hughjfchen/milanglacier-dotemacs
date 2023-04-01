;;; my-org-autoloads.el -*- lexical-binding: t; -*-

;;;###autoload
(defun my/load-org-extensions-idly ()
    "Some important variables from other org extensions are not autoloaded.
You may feel annoying if you want to use them but find a void variable.
(e.g. you want to call `org-open-at-point' on a timestamp)"
    (let ((org-packages '(org-capture org-agenda)))
        (dolist (pkg org-packages)
            (require pkg))))

;;;###autoload
(defun my/org-capture-bubble-tea-template (letter desc headings template &rest properties)
    `(,letter ,desc table-line
              (file+olp ,my/org-capture-bubble-tea-live-file
                        ,@headings ,(format-time-string "%Y") ,(format-time-string "%B"))
              ,template ,@properties :unnarrowed t))
;; HACK: here without `:unnarrowed t', the org-capture will
;; automatically insert a new line after the table. That is, if you
;; use the org-capture to create `table-line' entries a lot, your file
;; will get more and more blank lines, which makes your file
;; unreadable.  Plus, if you have your table with `#+TBLFM', then this
;; new line inserted by org capture breaks your table structure such
;; that all of your fields that are calculated by the formula becomes
;; unreachable. Because there should be new line before a `#+TBLFM'
;; and the table itself.

;; TODO: I don't find a way to disable this behavior yet. Ask for the
;; mailing-list.

;;;###autoload
(defun my/org-agenda-visited-all-directories ()
    "Org agenda need to visted all files listed in `org-agenda-files'
to create the view, which is expensive. By default I will only list a
small portion of files to be searched.  This function searches all the
files in the org-directory to create the org-agenda view"
    (interactive)
    (let* ((default-directory org-directory)
           (directories-string (shell-command-to-string "find * -type d -print0"))
           ;; the literal null character will cause git to wrongly
           ;; consider this file as a binary file. Use the `kbd' to
           ;; get the internal representation of the null character
           (directories (split-string directories-string (kbd "^@") nil))
           (org-agenda-files (mapcar (lambda (x)
                                         (file-name-concat org-directory x))
                                     directories)))
        (call-interactively #'org-agenda)))

;;;###autoload
(defun my/org-bubble-tea-get-end-of-play-time (start)
    "After clocking in to record the start time of playing with bubble tea,
when clocking out, use this function to automatically update the table."
    (save-excursion
        (goto-char (org-find-olp
                    `(,(buffer-name) "play" ,(format-time-string "%Y")
                      ;; 5th element of org-heading-components is the
                      ;; text of current heading which is exactly the
                      ;; month current table entry is at.
                      ,(nth 4 (org-heading-components)))))
        (re-search-forward (replace-regexp-in-string "[][]" "" start)
                           ;; [ and ] are regex reserved identifers,
                           ;; need to escape them.
                           nil
                           t)
        (let ((start-of-end-time (1- (re-search-forward "\\[" nil t)))
              ;; when use `buffer-substring-no-properties', the point
              ;; is left exclusive but right inclusive, so need to subtract
              ;; the point of the start by 1.
              (end-of-end-time (re-search-forward "\\]" nil t)))
            (buffer-substring-no-properties start-of-end-time end-of-end-time))))

;;;###autoload
(defun my/exclude-org-agenda-buffers-from-recentf (old-fn &rest args)
    "Prevent `org-agenda' buffers from polluting recentf list."
    (let ((recentf-exclude '("\\.org\\'")))
        (apply old-fn args)))

;;;###autoload
(defun my/reload-org-agenda-buffers ()
    "`org-agenda' creates incomplete `org-mode' buffers to boost its startup speed. Reload those buffers
after `org-agenda' has finalized."
    (run-with-idle-timer
     4 nil
     (lambda ()
         (dolist (buf org-agenda-new-buffers)
             (when (buffer-live-p buf)
                 (with-current-buffer buf
                     (org-mode)))))))

;; Copied and simplified from doomemacs
;;;###autoload
(defun my/org-indent-maybe-h ()
    "Indent the current item (header or item), if possible.
Made for `org-tab-first-hook' in evil-mode."
    (interactive)
    (cond ((not (evil-insert-state-p))
           nil)
          ((or (org-inside-LaTeX-fragment-p)
               (org-inside-latex-macro-p))
           nil)
          ((org-at-item-p)
           (if (eq this-command 'org-shifttab)
                   (org-outdent-item-tree)
               (org-indent-item-tree))
           t)
          ((org-at-heading-p)
           (ignore-errors
               (if (eq this-command 'org-shifttab)
                       (org-promote)
                   (org-demote)))
           t)
          ((org-in-src-block-p t)
           (save-window-excursion
               (org-babel-do-in-edit-buffer
                (call-interactively #'indent-for-tab-command)))
           t)
          ((and (save-excursion
                    (skip-chars-backward " \t")
                    (bolp))
                (org-in-subtree-not-table-p))
           (call-interactively #'tab-to-tab-stop)
           t)))

;; Copied and simplified from doomemacs
;;;###autoload
(defun my/org-yas-expand-maybe-h ()
    "Expand a yasnippet snippet, if trigger exists at point or region is active.
Made for `org-tab-first-hook'."
    (let ((major-mode (cond ((org-in-src-block-p t)
                             (org-src-get-lang-mode
                              (org-element-property :language (org-element-at-point))))
                            ((org-inside-LaTeX-fragment-p)
                             'latex-mode)
                            (major-mode)))
          (org-src-tab-acts-natively nil)
          ;; causes breakages
          ;; Smart indentation doesn't work with yasnippet, and painfully slow
          ;; in the few cases where it does.
          (yas-indent-line 'fixed))
        (cond ((and (or (evil-insert-state-p)
                        (evil-emacs-state-p))
                    (gethash major-mode yas--tables)
                    (yas--templates-for-key-at-point))
               (yas-expand)
               t)
              ((use-region-p)
               (yas-insert-snippet)
               t))))

(defun my/toggle-org-settings-wrapper (org-marker)
    (set org-marker (not (eval org-marker)))
    (org-mode))

;;;###autoload
(defun my/org-toggle-org-emphasis-markers ()
    "toggle emphasis markers"
    (interactive)
    (my/toggle-org-settings-wrapper 'org-hide-emphasis-markers))

;;;###autoload
(defun my/org-toggle-org-drawer ()
    "toggle hide drawer. This function is effective only after org 9.6."
    (interactive)
    (my/toggle-org-settings-wrapper 'org-cycle-hide-drawer-startup))

(provide 'my-org-autoloads)
;;; my-org-autoloads.el ends here
