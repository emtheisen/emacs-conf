;;; languages.el --- Languages File -*- mode: emacs-lisp; lexical-binding: t; -*-

;;; Commentary:
;;; Programming language support

;;; Code:
(eval-when-compile (defvar treesit-language-source-alist)
                   (defvar magit-mode-map)
                   (defvar magit-no-confirm)
                   (defvar magit-display-buffer-function)
                   (defvar Info-directory-list)
                   (defvar custom-c-tab-stop)
                   (defvar c-ts-mode-indent-style)
                   (defvar c-ts-mode-indent-offset))

(declare-function global-tree-sitter-mode "tree-sitter")
(declare-function global-flycheck-mode "flycheck")
(declare-function info-initialize "info")
(declare-function diff-hl-mode "diff-hl")
(declare-function smartparens-global-mode "smartparens")
(declare-function sp-with-modes "smartparens")
(declare-function sp-local-pair "smartparens")
(declare-function highlight-doxygen-mode "highlight-doxygen")
(declare-function company-mode "company")
(declare-function dumb-jump-xref-activate "dumb-jump")


;;
;; Bitbake
;;
(use-package bitbake
  :straight t)

;; Make Emacs recognize Bitbake files
(add-to-list 'auto-mode-alist '("\\.bb\\'" . bitbake-mode))
(add-to-list 'auto-mode-alist '("\\.inc\\'" . bitbake-mode))
(add-to-list 'auto-mode-alist '("\\.bbappend\\'" . bitbake-mode))
(add-to-list 'auto-mode-alist '("\\.bbclass\\'" . bitbake-mode))
(add-to-list 'auto-mode-alist '("\\.conf\\'" . bitbake-mode))

;;
;; Tree-sitter syntax analysis
;;
(use-package tree-sitter
  :init
  (setq treesit-language-source-alist
      '(
	(bash "https://github.com/tree-sitter/tree-sitter-bash")
	(bitbake "https://github.com/tree-sitter-grammars/tree-sitter-bitbake")
	(c "https://github.com/tree-sitter/tree-sitter-c")
	(cmake "https://github.com/uyha/tree-sitter-cmake")
	(cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (css "https://github.com/tree-sitter/tree-sitter-css")
        (dart "https://github.com/nielsenko/tree-sitter-dart")
	(elisp "https://github.com/Wilfred/tree-sitter-elisp")
	(json "https://github.com/tree-sitter/tree-sitter-json")
	(make "https://github.com/alemuller/tree-sitter-make")
	(markdown "https://github.com/ikatyang/tree-sitter-markdown")
	(python "https://github.com/tree-sitter/tree-sitter-python")
        (rust "https://github.com/tree-sitter/tree-sitter-rust")
	(toml "https://github.com/tree-sitter/tree-sitter-toml")
	(yaml "https://github.com/ikatyang/tree-sitter-yaml")
	))
  :config
  :if (executable-find "tree-sitter")
  :hook (((
           bitbake-ts-mode
           c-mode
           c++-mode
           conf-toml-mode
           cpp-mode
           css-mode
           dart-mode
           json-mode
           makefile-mode
           makefile-gmake-mode
           markdown-mode
           python-mode
           rust-mode
           toml-mode
           yaml-mode
           ) . tree-sitter-mode)
         ((
           bitbake-ts-mode
           c-mode
           c++-mode
           conf-toml-mode
           cpp-mode
           css-mode
           dart-mode
           json-mode
           makefile-mode
           makefile-gmake-mode
           markdown-mode
           python-mode
           rust-mode
           toml-mode
           yaml-mode
           ) . tree-sitter-hl-mode)))

;; Remap programming major modes to Tree-Sitter
(setq major-mode-remap-alist
      '(
        (bash-mode . bash-ts-mode)
        (bitbake . bitbake-ts-mode)
        (c-mode . c-ts-mode)
        (cpp-mode . c++-ts-mode)
        (c++-mode . c++-ts-mode)
        (conf-toml-mode . toml-ts-mode)
        (json-mode . json-ts-mode)
        (python-mode . python-ts-mode)
        (rust-mode . rust-ts-mode)
        (sh-mode . bash-ts-mode)
        (toml-mode . toml-ts-mode)
        (yaml-mode . yaml-ts-mode)))

;; Enable Tree-Sitter in any available buffers
(global-tree-sitter-mode 1)

;; Tree-Sitter Language bundle
(use-package tree-sitter-langs
  :if (executable-find "tree-sitter")
  :after tree-sitter)

;;
;; Mickey's Combobulate
;;
(straight-use-package '(dotcrafter :host github
                                   :repo "mickeynp/combobulate"
                                   :branch "master"))

;;
;; Magit - a git porcelain
;;
(use-package magit
  :config
  (with-eval-after-load 'magit
    (define-key magit-mode-map (kbd "<SPC>") nil))
  (add-to-list 'magit-no-confirm 'stage-all-changes)
  (setq magit-display-buffer-function
        (lambda (buffer)
          (display-buffer
           buffer (if (and (derived-mode-p 'magit-mode)
                           (memq (with-current-buffer buffer major-mode)
                                 '(magit-process-mode
                                   magit-revision-mode
                                   magit-diff-mode
                                   magit-stash-mode
                                   magit-status-mode)))
                      nil
                    '(display-buffer-same-window))))))

;; Magit docs
(with-eval-after-load 'info
  (info-initialize)
  (add-to-list 'Info-directory-list
               "~/.emacs.d/straight/build/magit"))

;; Magit auto-completes filenames in current git repository
;;  fails back to regular find-file outside of repo
(global-set-key (kbd "C-x f") 'find-file-in-repository)

;; Magit refresh after save
(with-eval-after-load 'magit-mode
  (add-hook 'after-save-hook 'magit-after-save-refresh-status t))

;; Treemacs magit
(use-package treemacs-magit :straight t)

;; git history views and git blame
(use-package git-timemachine)

;; Use diff-hl to display diffs in gutter
(use-package diff-hl
  :straight t
  :config
  (setq-default left-fringe-width  10)
  (setq-default right-fringe-width 10))
(add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)


;;
;; Inline error checking
;;
(use-package flycheck
  :straight t
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

;; Format all languages
(use-package format-all
  :straight t)


;;
;; Eglot client for the Language Server Protocol (LSP)
;;
(use-package eglot
  :straight (:type built-in)
  :custom-face
  (eglot-highlight-symbol-face ((t (:inherit secondary-selection))))
  :config
  (setq eglot-events-buffer-config 0
        eglot-ignored-server-capabilities '(:inlayHintProvider)
        eglot-confirm-server-edits nil))


;; Smart paren handling
(use-package smartparens
  :config
  (require 'smartparens-config)
  (smartparens-global-mode)
  (sp-with-modes
      '(c-mode c++-mode cpp-mode conf-toml-mode dar-mode emacs-lisp-mode jason-mode markdown-mode python-mode rustic-mode typescript-mode yaml-mode)
    (sp-local-pair "[" nil :post-handlers '(:add ("||\n[i]" "RET")))
    (sp-local-pair "(" nil :post-handlers '(:add ("||\n[i]" "RET")))
    (sp-local-pair "{" nil :post-handlers '(:add ("||\n[i]" "RET")))))


;;
;; Common programming modes
;;

;; Doxygen
(use-package highlight-doxygen :straight t)

(defun my-prog-mode-hook ()
  "Programming modes customization hook."

  ;; I love PragmataPro for source code...
  (face-remap-add-relative 'default :family "PragmataPro Mono Liga" :height 105)

  ;; Italicize comments
  (custom-set-faces '(font-lock-comment-face ((t (:slant italic)))))
  (custom-set-faces '(font-lock-doc-face ((t (:slant italic)))))

  ;; Highlight Doxygen comments
  (highlight-doxygen-mode)

  ;; Line numbers
  (display-line-numbers-mode)
  (column-number-mode)

  ;; Show the highlight line
  (hl-line-mode)

  ;; On the fly checking of spelling in strings and comments
  (flyspell-prog-mode)

  ;; Undo prettifying symbols under point, "cursor," or just before point
  (setq prettify-symbols-unprettify-at-point 'right-edge)

  ;; Company completion
  (company-mode)

  ;; Make sure files end in a newline
  (setq require-final-newline t)

  ;; Show git diff in gutter
  (diff-hl-mode))
(add-hook 'prog-mode-hook 'my-prog-mode-hook)
(add-hook 'yaml-mode-hook 'my-prog-mode-hook)

(defun languages-tab-stops (x)
  "Create list of X tab stops."
  (number-sequence x 160 x))


;;
;; C/C++
;;

;; My customization for all of c-mode, c++-mode, and objc-mode
(defun my-c-ts-mode-hook ()
  "C/C++ customization hook."
 (setq c-ts-mode-indent-style 'bsd)

 (setq c-ts-mode-indent-offset custom-c-tab-stop)

 ;; this will make sure spaces are used instead of tabs
 (setq tab-width 8 indent-tabs-mode nil)

 ;; Soft tab-stops on X spaces - M-i
 (setq tab-stop-list (languages-tab-stops custom-c-tab-stop))

 (setq comment-column 60)
 (setq comment-fill-column 60)
 (setq comment-style 'extra-line)

 ;; other customization
 (electric-indent-mode)
 ;;(electric-pair-mode) ;; using smartparens in lieu of
 )
(add-hook 'c-ts-mode-hook 'my-c-ts-mode-hook)
(add-hook 'cpp-ts-mode-hook 'my-c-ts-mode-hook)
(add-hook 'c++-ts-mode-hook 'my-c-ts-mode-hook)

;; Setup hideshow mode for C/C++/Rust/Lisp/Java
(add-hook 'c-mode-hook 'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'rustic-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook 'hs-minor-mode)

;; Jump to definition
(use-package dumb-jump
  :straight t)

;; Use dumb-jump for xref
(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)


;;
;; Rust
;;
(use-package rust-mode
  :straight t
  :init
  (setq rust-mode-treesitter-derive t))

(use-package lsp-mode
 :straight t
 :commands lsp
 :custom
 ;; what to use when checking on-save. "check" is default, I prefer clippy
 (lsp-rust-analyzer-cargo-watch-command "clippy")
 (lsp-eldoc-render-all t)
 (lsp-idle-delay 0.6)
 ;; enable / disable the hints as you prefer:
 (lsp-inlay-hint-enable t)
 ;; These are optional configurations. See https://emacs-lsp.github.io/lsp-mode/page/lsp-rust-analyzer/#lsp-rust-analyzer-display-chaining-hints for a full list
 (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
 (lsp-rust-analyzer-display-chaining-hints t)
 (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
 (lsp-rust-analyzer-display-closure-return-type-hints t)
 (lsp-rust-analyzer-display-parameter-hints nil)
 (lsp-rust-analyzer-display-reborrow-hints nil)
 (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package lsp-ui
 :straight t
 :commands lsp-ui-mode
 :custom
 ;; Bad wrapping with sideline when you don't set this.
 (custom-set-faces '(markdown-code-face ((t (:inherit default :height 100)))))
 (lsp-ui-peek-always-show t)
 ;;(lsp-ui-sideline-show-hover t)
 (lsp-ui-doc-enable nil))

(use-package rustic
 :straight t
 :bind (:map rustic-mode-map
             ("M-j" . lsp-ui-imenu)
             ("M-?" . lsp-find-references)
             ("C-c C-c l" . flycheck-list-errors)
             ("C-c C-c a" . lsp-execute-code-action)
             ("C-c C-c r" . lsp-rename)
             ("C-c C-c q" . lsp-workspace-restart)
             ("C-c C-c Q" . lsp-workspace-shutdown)
             ("C-c C-c s" . lsp-rust-analyzer-status))
 :config
 ;; uncomment for less flashiness
 ;; (setq lsp-eldoc-hook nil)
 ;; (setq lsp-enable-symbol-highlighting nil)
 ;; (setq lsp-signature-auto-activate nil)

 ;; Enable electric pairing of delimiters
 ;;(electric-pair-mode nil)  ;; using smartparens in lieu of

 ;; comment to disable rustfmt on save
 (setq rustic-format-on-save t)
 (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook)
 :after(rust-mode))

(defun rk/rustic-mode-hook ()
  "Rustic mode customization hook."

  ;; Treat snake case as one word
  (superword-mode)

  ;; this will make sure spaces are used instead of tabs
  (setq tab-width 8 indent-tabs-mode nil)

  ;; Soft tabstops on 4 spaces - M-i
  (setq tab-stop-list (languages-tab-stops 4))

  ;; so that run C-c C-c C-r works without having to confirm, but don't try to
  ;; save rust buffers that are not file visiting. Once
  ;; https://github.com/brotzeit/rustic/issues/253 has been resolved this should
  ;; no longer be necessary.
  (when buffer-file-name
    (setq-local buffer-save-without-query t))
  (add-hook 'before-save-hook 'lsp-format-buffer nil t))

;; Create / Cleanup Rust scratch projects quickly
(use-package rust-playground :straight t)

;; Cargo.toml and other config files
(use-package toml-mode :straight t)

;; Set up debugging support with dap-mode

(use-package exec-path-from-shell
  :straight t
  :init (exec-path-from-shell-initialize))

(use-package dap-mode
  :straight t
  :config
  (require 'dap-lldb)
  (require 'dap-cpptools)
  (setq dap-lldb-debug-program '("/usr/bin/lldb-dap-19"))
  ;; installs .extension/vscode
  (dap-cpptools-setup)
  (dap-register-debug-template
   "Rust::LLDB Run Configuration"
   (list :type "lldb-vscode"
         :request "launch"
         :name "LLDB::Run"
         )))


;;
;; PlatformIO
;;

(use-package ccls
  :straight t
  :config
  (setq ccls-executable "/usr/local/bin/ccls"))

(use-package platformio-mode
  :straight t
  :config
  (require 'ccls)
  ;; Enable ccls for all c++ files, and platformio-mode only
  ;; when needed (platformio.ini present in project root).
  (add-hook 'c++-mode-hook (lambda ()
                             (lsp-deferred)
                             (platformio-conditionally-enable))))

(provide 'languages)
;;; languages.el ends here
