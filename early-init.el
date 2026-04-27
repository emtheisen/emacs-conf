;;; early-init.el --- Intialization File -*- mode: emacs-lisp; lexical-binding: t; -*-

;;; Commentary:
;;; This is loaded prior to .emacs or .init.el.

;;; Code:

;; We're using straight for packages. Don't fetch duplicates from melpa/elpa.
(setq package-enable-at-startup nil)

(provide 'early-init)
;;; early-init.el ends here
