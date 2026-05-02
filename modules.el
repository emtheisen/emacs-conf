;;; modules.el --- Packages File -*- mode: emacs-lisp; lexical-binding: t; -*-

;;; Commentary:
;;; Bring in most of the main packages.

;;; Code:

(eval-when-compile (defvar completion-preview-sort-function)
                   (defvar undo-tree-auto-save-history)
                   (defvar yas-fallback-behavior)
                   (defvar yas-minor-mode)
                   (defvar company-idle-delay)
                   (defvar company-tooltip-idle-delay)
                   (defvar company-require-match)
                   (defvar company-frontends)
                   (defvar company-backends)
                   (defvar vertico--index)
                   (defvar vertico-map)
                   (defvar projectile-project-search-path)
                   (defvar projectile-enable-caching)
                   (defvar projectile-mode-map)
                   (defvar ffip-use-rust-fd)
                   (defvar pdf-view-restore-filename)
                   (defvar hl-todo-keyword-faces))

(declare-function global-ligature-mode "ligature")
(declare-function whole-line-or-region-global-mode "whole-line-or-region")
(declare-function helpful-callable "helpful")
(declare-function helpful-variable "helpful")
(declare-function helpful-key "helpful")
(declare-function helpful-command "helpful")
(declare-function helpful-at-point "helpful")
(declare-function helpful-function "helpful")
(declare-function company-mode "company")
(declare-function company-complete-common "company")
(declare-function yas-expand "yasnippet")
(declare-function nerd-icons-completion-mode "nerd-icons-completion")
(declare-function prescient-completion-sort "prescient")
(declare-function vertico-prescient-mode "vertico-prescient")
(declare-function vertico-mode "vertico")
(declare-function vertico-directory-enter "vertico-directory")
(declare-function vertico-directory-delete-char "vertico-directory")
(declare-function vertico-directory-delete-word "vertico-directory")
(declare-function vertico-directory-tidy "vertico-directory")
(declare-function marginalia-mode "marginalia")
(declare-function projectile-mode "projectile")
(declare-function pdf-tools-install "pdf-tools")
(declare-function yas-reload-all "yasnippet")

;;
;; General appearance
;;

;;
;; Theme
;;
(use-package tokyo-night
  :straight t
  :config
  (setq tokyo-night-override-colors-alist
        '(("tokyo-comment" . "#636da6") ; brighter comments
          ("tokyo-bg-line" . "#292e42"))  ; same as tokyo-bg-highlight
        )
  (load-theme 'tokyo-night t))

;; Set the point, aka cursor, for high visibility
(set-cursor-color "red")

;; We want all the icons for different modes
(use-package all-the-icons :straight t)
(use-package all-the-icons-completion :straight t)
(use-package all-the-icons-dired :straight t)
(use-package all-the-icons-ivy :straight t)
(use-package all-the-icons-nerd-fonts  :straight t)
(use-package treemacs-all-the-icons :straight t)
(use-package treemacs-icons-dired :straight t)
(use-package treemacs-nerd-icons :straight t)

;; Emojis...
(use-package emojify :straight t)

;; Enables font ligatures globally in all buffers.
(use-package ligature
  :straight t
  :config
  (global-ligature-mode))

;; which-key will show you options for partially completed keybindings
;; It's extremely useful for packages with many keybindings like Projectile.
(use-package which-key
 :straight t
 :config
 (which-key-mode +1))

;; Treat kill/copy of current unmarked line as if marked as a region
(use-package whole-line-or-region
  :straight t
  :init
  (whole-line-or-region-global-mode))

;; Dictionary
(global-set-key (kbd "M-#") 'dictionary-lookup-definition)

;; Perspective, organize Emacs buffers
(use-package perspective
  :straight t
  :bind (("C-x k" . persp-kill-buffer*))
  :init
  (setq persp-suppress-no-prefix-key-warning t)
  (persp-mode))

;;
;; [NOTE] I use PragmataPro's ligatures to highlight todos.
;;
;; Highlight todos
;; (use-package hl-todo
;;   :straight t
;;   :config
;;   (setq hl-todo-keyword-faces
;;         '(("TODO"   . "#DAA520")
;;           ("DONE"   . "#32CD32")
;;           ("INFO"   . "#7777FF")
;;           ("NOTE"   . "#7777FF")
;;           ("FIXME"  . "#FF0000")))
;;   (global-hl-todo-mode))

;; Breadcrumbs
(use-package breadcrumb :straight t)

;; Undo across file opens/closes
(use-package undo-tree
  :straight t
  :config
  (setq undo-tree-auto-save-history t
        undo-tree-history-directory-alist
        '(("." . "~/.emacs.d/undo")))
  (global-undo-tree-mode))

;; Helpful, enhance Emacs help system
(use-package helpful
  :straight t
  :config
  (global-set-key (kbd "C-h f") #'helpful-callable)
  (global-set-key (kbd "C-h v") #'helpful-variable)
  (global-set-key (kbd "C-h k") #'helpful-key)
  (global-set-key (kbd "C-h x") #'helpful-command)
  (global-set-key (kbd "C-c C-d") #'helpful-at-point)
  (global-set-key (kbd "C-h F") #'helpful-function))

;; Use ripgrep
(use-package rg :straight t)

;; GNU plotting
(use-package gnuplot :straight t)
(use-package gnuplot-mode :straight t)

;; Embark Emacs minibuffer actions
(use-package embark
  :straight t
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  ;; Show the Embark target at point via Eldoc. You may adjust the
  ;; Eldoc strategy, if you want to see the documentation from
  ;; multiple providers. Beware that using this can be a little
  ;; jarring since the message shown in the minibuffer can be more
  ;; than one line, causing the modeline to move up and down:

  ;; (add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
  ;; (setq eldoc-documentation-strategy #'eldoc-documentation-compose-eagerly)

  ;; Add Embark to the mouse context menu. Also enable `context-menu-mode'.
  ;; (context-menu-mode 1)
  ;; (add-hook 'context-menu-functions #'embark-context-menu 100)
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :straight t ; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))


;;
;; Auto completion and code snippets
;;

;; YA Snippets
(use-package yasnippet
 :straight t
 :config
 (yas-reload-all)
 (add-hook 'prog-mode-hook 'yas-minor-mode)
 (add-hook 'text-mode-hook 'yas-minor-mode))


;;
;; Company completion framework
;;
(use-package company
  :straight t
  :config
  (company-prescient-mode)
  :bind
  (:map company-active-map
        ("C-n". company-select-next)
        ("C-p". company-select-previous)
        ("M-<". company-select-first)
        ("M->". company-select-last))
  (:map company-mode-map
        ("<tab>". tab-indent-or-complete)
        ("TAB". tab-indent-or-complete)))

(defun company-yasnippet-or-completion ()
  "Use either yasnippet to complete or company."
  (interactive)
  (or (do-yas-expand)
      (company-complete-common)))

(defun check-expansion ()
  "Backup if special characters are at the end of expansion."
  (save-excursion
    (if (looking-at "\\_>") t
      (backward-char 1)
      (if (looking-at "\\.") t
        (backward-char 1)
        (if (looking-at "::") t nil)))))

(defun do-yas-expand ()
  "Perform yas expansion."
    (yas-expand))

(defun tab-indent-or-complete ()
  "Company completion in minibuffer."
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (not yas-minor-mode)
            (null (do-yas-expand)))
        (if (check-expansion)
            (company-complete-common)
          (indent-for-tab-command)))))

(setq company-idle-delay 0
      company-tooltip-idle-delay 0.2
      company-require-match nil
      company-frontends
      '(company-pseudo-tooltip-unless-just-one-frontend-with-delay
        company-preview-frontend
        company-echo-metadata-frontend)
      company-backends '(company-capf))

;; Fuzzy completion
(use-package fzf
  :straight t
  :bind
    ;; Don't forget to set keybinds!
  :config
  (setq fzf/args "-x --color bw --print-query --margin=1,0 --no-hscroll"
        fzf/executable "fzf"
        fzf/git-grep-args "-i --line-number %s"
        ;; command used for `fzf-grep-*` functions
        ;; example usage for ripgrep:
        fzf/grep-command "rg --no-heading -nH"
        ;;fzf/grep-command "grep -nrH"
        ;; If nil, the fzf buffer will appear at the top of the window
        fzf/position-bottom t
        fzf/window-height 15))

;;
;; Vertico selection framework
;;

;; Use Prescient to sort and filter candidate completions
(use-package prescient :straight t)
(use-package vertico-prescient :straight t)
(use-package company-prescient :straight t)

;; Use Prescient with Emacs 30+ completion framework
(when (version< emacs-version "30")
  (setq completion-preview-sort-function #'prescient-completion-sort))

;; Vertico...
(use-package vertico
  :straight t
  ;;:custom

  ;; (vertico-scroll-margin 0) ;; Different scroll margin
  ;; (vertico-count 20) ;; Show more candidates
  ;; (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  ;; (vertico-cycle t) ;; Enable cycling for `vertico-next/previous'
  :config
  (vertico-prescient-mode)
  :init
  (vertico-mode +1))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :straight t
  :init
  (savehist-mode))

;; Enable rich annotations using Marginalia
(use-package marginalia
  :straight t
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  (marginalia-mode))

;; Use the `orderless' completion style.
(use-package orderless
  :straight t
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil) ;; Disable defaults, use our settings
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

;; Nerd icon completions
(use-package nerd-icons-completion
  :straight t
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup)
  :config
  (nerd-icons-completion-mode))

;; Add an ▶ to the current vertico candidate
(defvar +vertico-current-arrow t)
(cl-defmethod vertico--format-candidate
  :around
  (cand prefix suffix index start &context ((and +vertico-current-arrow
                                                 (not (bound-and-true-p vertico-flat-mode)))
                                            (eql t)))
  "Add arrow to current vertico candidate."
  (setq cand (cl-call-next-method cand prefix suffix index start))
  (if (bound-and-true-p vertico-grid-mode)
      (if (= vertico--index index)
          (concat #("▶" 0 1 (face vertico-current)) cand)
        (concat #("_" 0 1 (display " ")) cand))
    (if (= vertico--index index)
        (concat
         #(" " 0 1 (display (left-fringe right-triangle vertico-current)))
         cand)
      cand)))

;; Vertico directory editing
(use-package vertico-directory
  :after vertico
  :straight nil
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))
(keymap-set vertico-map "RET" #'vertico-directory-enter)
(keymap-set vertico-map "DEL" #'vertico-directory-delete-char)
(keymap-set vertico-map "M-DEL" #'vertico-directory-delete-word)
(add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)

;; Real time spelling correction
(use-package flyspell-correct
  :straight t)


;;
;; Projectile
;;

;; Use ripgrep with Projectile
(use-package projectile-ripgrep :straight t)

;; Optional: ag is nice alternative to using grep with Projectile
(use-package ag :straight t)

(use-package projectile
 :straight t
 :init
 (setq projectile-project-search-path '(("~/proj" 1)))
 ;; Enable caching in large projects
 (setq projectile-enable-caching t)
 :config
 ;; I typically use this keymap prefix on macOS
 (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
 ;; On Linux, however, I usually go with another one
 (define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)
 (global-set-key (kbd "C-c p") 'projectile-command-map)
 (projectile-mode +1))

;; Use "fd" to find files in project
(setq ffip-use-rust-fd t)

;;
;; Treemacs
;;

(use-package treemacs
  :straight t)

(use-package treemacs-projectile
  :straight t)

(use-package treemacs-tab-bar
  :straight t)


;;
;; Documentation
;;

;; PDF
(use-package pdf-tools
  :straight t
  :init
  (pdf-tools-install))

(use-package pdf-view-restore
  :after pdf-tools
  :straight t
  :config
  (add-hook 'pdf-view-mode-hook 'pdf-view-restore-mode))
(setq pdf-view-restore-filename "~/.emacs.d/.pdf-view-restore")

;; ePub
(use-package nov
  :straight t
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))


;;
;; Documention modes
;;

;; ePub (nov.el)
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

;; PDF
(use-package pdf-tools
  :straight t
  :init
  (pdf-tools-install))

(use-package pdf-view-restore
  :after pdf-tools
  :straight t
  :config
  (add-hook 'pdf-view-mode-hook 'pdf-view-restore-mode))
(setq pdf-view-restore-filename "~/.emacs.d/.pdf-view-restore")

(provide 'modules)
;;; modules.el ends here
