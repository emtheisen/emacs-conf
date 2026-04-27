;;; .emacs --- Intialization File -*- mode: emacs-lisp; lexical-binding: t; -*-

;;; Commentary:
;;; Use straight for package management

;;; Code:

(eval-when-compile (defvar config-base-directory)
                   (defvar straight-use-package-by-default)
                   (defvar my-init-file)
                   (defvar my-custom-file)
                   (defvar my-modeline-file)
                   (defvar my-modules-file)
                   (defvar my-consult-file)
                   (defvar my-org-file)
                   (defvar my-pragmatapro-file) ;; This is a proprietary font. Remove if not purchased
                   (defvar my-languages-file))

(declare-function straight-use-package "straight" (f))

;; This init file bootstraps use-package + straight if necessary,
;; before continuing initialization.
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

(setq straight-use-package-by-default t)

(straight-use-package 'use-package)

;; Files to load
(setq config-base-directory "~/proj/emacs-conf")

(setq my-init-file (expand-file-name "init.el" config-base-directory))
(setq my-custom-file (expand-file-name "custom.el" config-base-directory))
(setq my-modeline-file (expand-file-name "modeline.el" config-base-directory))
(setq my-modules-file (expand-file-name "modules.el" config-base-directory))
(setq my-consult-file (expand-file-name "my-consult.el" config-base-directory))
(setq my-org-file (expand-file-name "my-org.el" config-base-directory))
(setq my-pragmatapro-file (expand-file-name "pragmatapro.el" config-base-directory)) ;; This is a propritary font. Remove if not purchased.
(setq my-languages-file (expand-file-name "languages.el" config-base-directory))


(load my-custom-file)
(load my-modeline-file)
(load my-modules-file)
(load my-consult-file)
(load my-org-file)
(load my-pragmatapro-file)  ;; This is a propritary font. Remove if not purchased.
(load my-languages-file)

(provide '.emacs)
;;; init.el ends here
