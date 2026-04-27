;;; custom.el --- Customization File -*- mode: emacs-lisp; lexical-binding: t; -*-

;;; Commentary:
;;; Customization and user defined functions.

;;; Code:

(eval-when-compile (defvar custom-c-tab-stop)
                   (defvar recentf-max-saved-items)
                   (defvar apropos-sort-by-scores)
                   (defvar display-line-numbers-grow-only)
                   (defvar display-line-numbers-width-start)
                   (defvar display-line-numbers-type)
                   (defvar scroll-bar-show)
                   (defvar dired-x-hands-off-my-keys)
                   (defvar buffer-face-mode-face)
                   (defvar buffer-file-name))

(declare-function set-frame-size-according-to-resolution "custom")
(declare-function ligature-mode "ligature")
(declare-function emojify-mode "emojify")

(use-package emacs
  :straight t
  :config
  (mapc
   (lambda (item) (add-to-list 'default-frame-alist item))
   '((font . "JetBrains Mono 10")
     (ns-transparent-titlebar . t)
     (ns-appearance . dark)
     (vertical-scroll-bars . nil)))

  ;; Set beginning window size
  (defun set-frame-size-according-to-resolution ()
    "Sets the frame size based on screen resolution."
    (interactive)
    (if (display-graphic-p)
        (progn
          ;; use 120 char wide window for largeish displays
          ;; and smaller 80 column windows for smaller displays
          ;; pick whatever numbers make sense for you
          (if (> (x-display-pixel-width) 1280)
              (add-to-list 'default-frame-alist (cons 'width 160))
            (add-to-list 'default-frame-alist (cons 'width 80)))
          ;; for the height, subtract a couple hundred pixels
          ;; from the screen height (for panels, menubars and
          ;; Whatnot), then divide by the height of a char to
          ;; get the height we want
          (add-to-list 'default-frame-alist
                       (cons 'height (/ (- (x-display-pixel-height) 200)
                                        (frame-char-height))))
          (redraw-frame))))
  (set-frame-size-according-to-resolution)

  (setq-default
   shr-max-width 80
   indent-tabs-mode nil
   ns-use-proxy-icon nil
   frame-title-format "%*%b"
   cursor-in-non-selected-windows nil
   truncate-lines t
   show-trailing-whitespace nil)

  (setq
   ;; This sets C like languages' tab stops
   custom-c-tab-stop 2

   ;; Garbage collection threshold
   gc-cons-threshold (* 100 1024 1024)

   ;; Maximum bytes to read from subprocess in one chunk
   read-process-output-max (* 1024 1024)

   ;; Disable the splash screen and its messages
   ;; (to enable them again, replace the t with 0)
   inhibit-splash-screen t
   inhibit-startup-message t

   ;; Don't put temp messages in scratch buffer
   initial-scratch-message nil

   ;; Enable transient mark mode
   transient-mark-mode 1

   ;; Max saved items across sessions
   recentf-max-saved-items 100

   ;; Don't ring the bell
   ring-bell-function #'ignore

   ;; Turn on visible bell (to disable it, replace t with 0
   visible-bell t

   ;; Sort apropos results by best matches
   apropos-sort-by-scores t

   ;; Ignore case during searches
   ;; case-fold-search t

   ;; Allow search to use M-\<, M-\>, C-v, M-v
   isearch-allow-motion t

   ;; Scroll sreen when point gets within 8 lines of top/bottom of window
   scroll-margin 8

   ;; Try and indent line. Otherwise attempt completion at point.
   tab-always-indent 'complete

   ;; Immediately show matching parenthesis
   show-paren-delay 0

   ;; Maintain line number width.
   display-line-numbers-grow-only t

   ;; Determine line number width needed.
   display-line-numbers-width-start t

   ;; Configure line numbers to be buffer based
   display-line-numbers-type t

   ;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
   ;; to switch display modes.
   context-menu-mode t

   ;; Max Bling
   font-lock-maximum-decoration t

   ;; Make sure files end in a newline
   require-final-newline t

   ;; Support opening new minibuffers from inside existing minibuffers.
   enable-recursive-minibuffers t

   ;; Hide commands in M-x which do not work in the current mode.  Vertico
   ;; commands are hidden in normal buffers. This setting is useful beyond
   ;; Vertico.
   read-extended-command-predicate #'command-completion-default-include-p

   ;; Do not allow the cursor in the minibuffer prompt
   minibuffer-prompt-properties '(read-only t cursor-intangible t face minibuffer-prompt)

   ;; Autosaves location in case of crashes
   auto-save-list-file-prefix "~/.autosaves/.saves-"

   ;; Workaround for dealing with Windblows cut/paste
   select-active-regions nil
   select-enable-clipboard 't
   select-enable-primary nil
   interprogram-cut-function #'gui-select-text
   )

 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;; Blinking cursor.
  (blink-cursor-mode t)

  ;; Show menu bar
  (menu-bar-mode 1)

  ;; Hide tool bar
  (tool-bar-mode 0)

  ;; Don't show scroll bar. Set to t to enable.
  (setq scroll-bar-show nil)

  ;; If showing scroll bars, put them on the right
  (if (bound-and-true-p scroll-bar-show)
      (set-scroll-bar-mode 'right)
    (set-scroll-bar-mode nil))

  ;; Use Y or N in leiu of Yes or No
  (fset 'yes-or-no-p 'y-or-n-p)

  ;; Turn on tab bar history
  (tab-bar-mode)
  (tab-bar-history-mode)
  (global-set-key (kbd "M-[") 'tab-bar-history-back)
  (global-set-key (kbd "M-]") 'tab-bar-history-forward)
  (custom-set-faces '(tab-bar ((t (:height 105)))))

  ;; Map C-x C-b to ibuffer-mode
  (global-set-key [remap list-buffers] 'ibuffer)

  ;; Dictionary
  (global-set-key (kbd "M-#") 'dictionary-lookup-definition)

  ;; Use visual line mode to wrap by word boundaries
  (global-visual-line-mode)

  ;; Turn on delete selection, aka overwrite
  (delete-selection-mode)

  ;; Highlight matching parenthesis
  (show-paren-mode 1)

  ;; Remember recently opened files across sessions
  (recentf-mode 1)

  ;; Remember place in files
  (save-place-mode 1)

  ;; Enable line numbers globally
  ;; (global-display-line-numbers-mode nil)

  ;; M-o key binding to switch windows
  (global-set-key (kbd "M-o") 'other-window)

  ;; Allow changing windows in cardinal directions, S-<right>, S-<left>, S-<up>, S-<down>
  (windmove-default-keybindings)

  ;; Turn on font lock mode globally
  (global-font-lock-mode)

  ;; Enable subword mode
  (global-subword-mode 1)

  ;; Enable repeating keys
  (repeat-mode)

  ;; Enable the mouse in the terminal
  (xterm-mouse-mode)

  ;; Enable the mouse's wheel
  (mouse-wheel-mode)

  ;; Configure modeline
  ;; (setq-default
  ;;  mode-line-format
  ;;  '("%e"
  ;;    mode-line-front-space
  ;;    mode-line-client
  ;;    mode-line-modified
  ;;    mode-line-remote
  ;;    mode-line-frame-identification
  ;;    mode-line-buffer-identification
  ;;    (vc-mode vc-mode)
  ;;    mode-line-end-spaces))

  :hook
  (compilation-mode . visual-line-mode)
  (compilation-minor-mode . visual-line-mode)
  (text-mode . auto-fill-mode)
  (before-save . delete-trailing-whitespace))

;; Dired Extra
(with-eval-after-load 'dired
  ;; Bind dired-x-find-file.
  (setq dired-x-hands-off-my-keys nil)
  (require 'dired-x))
(add-hook 'dired-mode-hook
          (lambda ()
            ;; Set dired-x buffer-local variables here.  For example:
            ;; (dired-omit-mode 1)
            ))

;;
;; Adjust minibuffer face to be smaller
;;
(defvar-local my-minibuffer-font-remap-cookie nil
  "The current face remap of `my-minibuffer-set-font'.")

(defface my-minibuffer-default
  '((t :height 0.9))
  "Face for the minibuffer and the Completions."
  :group 'my-minibuffer-group)

(defun my-minibuffer-set-font ()
  "Set the font of the ‘minibuffer’."
  (setq-local my-minibuffer-font-remap-cookie
              (face-remap-add-relative 'default 'my-minibuffer-default)))

(add-hook 'minibuffer-mode-hook #'my-minibuffer-set-font)

;;
;; Start Emacs Server for emacsclient(s)
;;
(require 'server)
(when (not (server-running-p)) (server-start))

;;
;; Shells
;;

(defun my-buffer-face-mode-pragmatapro ()
  "Set buffer to use Pragmata Pro as face."
   (interactive)
   (setq buffer-face-mode-face '(:inherit default :family "PragmataPro Mono Liga" :height 105))
   (ligature-mode)
   (buffer-face-mode))
(add-hook 'eshell-mode-hook 'my-buffer-face-mode-pragmatapro)
(add-hook 'shell-mode-hook 'my-buffer-face-mode-pragmatapro)

(defun eshell/e (file)
  "Open FILE using Emacs \"find-file\" command."
  (interactive "fOpen file: ")
  (find-file file))

;;
;; Documentation
;;

;; (defun my-Info-mode-hook ()
;;   "Info Mode customization hook."
;;   (face-remap-add-relative 'default :family "iA Writer Quattro V"))
;; (add-hook 'Info-mode-hook 'my-Info-mode-hook)

;; Markdown
(defun my-markdown-mode-hook ()
  "Markdown customization hook."
 (interactive)
   (emojify-mode)
   (buffer-face-mode))
(add-hook 'markdown-mode-hook 'my-markdown-mode-hook)

;;
;; Utilities
;;
(defun dos2unix ()
 "Convert a DOS formatted text buffer to UNIX format."
 (interactive)
 (set-buffer-file-coding-system 'undecided-unix nil))

(defun unix2dos ()
 "Convert a UNIX formatted text buffer to DOS format."
 (interactive)
 (set-buffer-file-coding-system 'undecided-dos nil))

;; Edit a file as root
(defun sudo ()
 "Use TRAMP to `sudo' the current buffer."
 (interactive)
 (when buffer-file-name
   (find-alternate-file
    (concat "/sudo:root@localhost:"
            buffer-file-name))))

;; Hippie Expand
(global-set-key [remap dabbrev-expand] 'hippie-expand)

;; Handle URIs from tools such as Delta
(defun emacs-uri-handler (uri)
  "Handles Emacs URIs in the form: emacs:///path/to/file/LINENUM."
  (save-match-data
    (if (string-match "emacs://\\(.*\\)/\\([0-9]+\\)$" uri)
        (let ((filename (match-string 1 uri))
              (linenum (match-string 2 uri)))
          (while (string-match "\\(%20\\)" filename)
            (setq filename (replace-match " " nil t filename 1)))
          (with-current-buffer (find-file filename)
            (setq linenum (string-to-number linenum))
            (forward-line (1- linenum)))
          )
      (beep)
      (message "Unable to parse the URI <%s>"  uri))))

;;
;; sshfs
;;
(defconst mpn-file-remote-mount-points
  (mapcar (lambda (d) (directory-file-name
                       (expand-file-name d)))
          '("~/.guinea" "~/.labrat"))
  "List of locations where remote file systems have been mounted.
Each directory listed must be an absolute expanded path and must
not end with a slash.")

(push (let ((re (regexp-opt mpn-file-remote-mount-points nil)))
        (list (concat "\\`" re "\\(?:/\\|\\'\\)")
              (concat temporary-file-directory "remote")
              t))
      auto-save-file-name-transforms)

(defun mpn-file-remote-mount-p (&optional file-name)
  "Return whether FILE-NAME is under a remote mount point.
Use function ‘buffer-file-name’ if FILE-NAME is not given.
List of remote mount points is defined in ‘mpn-file-remote-mount-points’
variable."
  (when-let* ((name (or file-name buffer-file-name)))
    (let ((dirs mpn-file-remote-mount-points)
          (name-len (length name))
          dir dir-len matched)
      (while (and dirs (not matched))
        (setq dir (car dirs)
              dirs (cdr dirs)
              dir-len (length dir)
              matched (and (> name-len dir-len)
                           (eq ?/ (aref name dir-len))
                           (eq t (compare-strings name 0 dir-len
                                                  dir 0 dir-len)))))
      matched)))

(defun mpn-dont-lock-remote-files ()
  "Set ‘create-lockfiles’ to nil if buffer opens a remote file.
Use ‘mpn-file-remote-mount-p’ to determine whether opened file is
remote or not.  Do nothing if ‘create-lockfiles’ is already nil."
  (and create-lockfiles
       (mpn-file-remote-mount-p)
       (setq-local create-lockfiles nil)))

(add-hook 'find-file-hook #'mpn-dont-lock-remote-files)


;;
;; SSH hosts
;;

(defun guinea ()
  "SSH into host guinea."
  (interactive)
  (dired "/sshx:etheisen@guinea:/home/etheisen")
  )

(defun labrat ()
  "SSH into host guinea."
  (interactive)
  (dired "/sshx:etheisen@labrat:/home/etheisen")
  )

(provide 'custom)
;;; custom.el ends here
