;;; init.el -*- lexical-binding: t; -*-

;; increase gc threshold to speedup starting up
(setq gc-cons-percentage 0.6)
(setq gc-cons-threshold most-positive-fixnum)

(defvar my/config-dir (file-name-concat user-emacs-directory "lisp")
    "the directory of my configuration.")
(defvar my/autoloads-dir (file-name-concat my/config-dir "autoloads")
    "the directory of my autoloded functions.")
(defvar my/autoloads-file (file-name-concat my/autoloads-dir "my-loaddefs.el")
    "the file of my autoloded functions.")
(defvar my/site-lisp-dir (file-name-concat user-emacs-directory "site-lisp")
    "the directory of third-party lisp files.")
(defvar my/site-lisp-autoloads-file
    (file-name-concat my/site-lisp-dir "my-site-lisp-loaddefs.el")
    "the file of third-party autoloaded functions.")

(push my/config-dir load-path)
(push my/autoloads-dir load-path)
(push my/site-lisp-dir load-path)
(setq custom-file (file-name-concat user-emacs-directory "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

(setq use-package-expand-minimally t
      ;; use-package is a macro. Don't let the macro expands into
      ;; codes with too much of irrelevant checks.
      ;; Straight is my package manager, don't let package.el get
      ;; involved.
      use-package-always-defer t
      ;; This is a useful trick to speed up your startup time. Only
      ;; use `require' when it's necessary. By setting the
      ;; `use-package-always-defer' option to t, use-package won't
      ;; call `require' in all cases unless you explicitly include
      ;; :demand t'. This will prevent unnecessary package loading and
      ;; speed up your Emacs startup time.
      straight-check-for-modifications nil ;;'(find-at-startup)
      ;; This is a useful trick to further optimize your startup
      ;; time. Instead of using `straight-check-for-modifications' to
      ;; check if a package has been modified, you can manually
      ;; rebuild the package by `straight-rebuild-package' when you
      ;; know its source code has changed. This avoids the overhead of
      ;; the check. Make sure you know what you are doing here when
      ;; setting this option.
      debug-on-error t)

;; bootstrap straight.el, copied from
;; URL: `https://github.com/radian-software/straight.el#getting-started'
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
    (unless (file-exists-p bootstrap-file)
        (with-current-buffer
                (url-retrieve-synchronously
                 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
                 'silent 'inhibit-cookies)
            (goto-char (point-max))
            (eval-print-last-sexp)))
    (load bootstrap-file nil 'nomessage))

(require 'my-loaddefs)
(require 'my-site-lisp-loaddefs)

(require 'my-init-utils)
(require 'my-basics)
(require 'my-init-ui)
(require 'my-init-colorscheme)
(require 'my-init-evil)
(require 'my-init-completion)
(require 'my-init-minibuffer)
(require 'my-init-vcs)
(require 'my-init-elisp)
(require 'my-init-org)
(require 'my-init-langs)
(require 'my-init-langtools)
(require 'my-init-os)
(require 'my-init-apps)
(require 'my-init-email)
(require 'my-misc)

;; I personally HATE custom.el. But I don't think I have a better
;; place to store the API key for codeium.
(when (file-exists-p custom-file)
  (load custom-file))

(setq debug-on-error nil)

;; after started up, reset GC threshold to normal.
(run-with-idle-timer 4 nil
                     (lambda ()
                         "Clean up gc."
                         (setq gc-cons-threshold  67108864) ; 64M
                         (setq gc-cons-percentage 0.1) ; original value
                         (garbage-collect)))

(provide 'init)
;;; init.el ends here
