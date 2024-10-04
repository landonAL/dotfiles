;; -*- coding: utf-8; lexical-binding: t -*-

(setq custom-file "~/.emacs.custom.el")

(setq gc-cons-threshold most-positive-fixnum ; 2^61 bytes
      gc-cons-percentage 0.6)

(setq package-enable-at-startup nil)
(package-initialize)

(setq gc-cons-threshold 80000000 ; 80 MiB
      gc-cons-percentage 1)

(setq inhibit-startup-message t)

;; emergency security fix
;; https://bugs.debian.org/766397
(with-eval-after-load 'enriched
  (defun enriched-decode-display-prop (start end &optional param)
    (list start end)))

(require 'use-package)

(add-to-list 'load-path "~/.emacs.local/")

(load-file "~/.emacs.rc/rc.el")
(load-file "~/.emacs.rc/misc-rc.el")

;; General
(add-to-list 'default-frame-alist `(font . "Iosevka-18"))
(add-to-list 'default-frame-alist '(fullscreen . maximized))

; (rc/require-theme 'gruber-darker)

(when (window-system)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1)
  (pixel-scroll-mode))

(when (eq system-type 'darwin)
  (setq ns-auto-hide-menu-bar t))

(setq default-directory (concat (getenv "HOME") "/"))

(setq-default inhibit-splash-screen t
              make-backup-files nil
	          auto-save-default nil
	          create-lockfiles nil
              tab-width 4
              indent-tabs-mode nil
              compilation-scroll-output t
              electric-pair-mode t
	          initial-scratch-message nil
	          sentence-end-double-space nil
	          ring-bell-function 'ignore
	          save-interprogram-paste-before-kill t
	          use-dialog-box nil
	          mark-even-if-inactive nil
	          kill-whole-line t
	          fast-but-imprecise-scrolling t
	          load-prefer-newer t
	          confirm-kill-processes nil
	          native-comp-async-report-warnings-errors 'silent
	          truncate-string-ellipsis "…"
	          help-window-select t
	          scroll-preserve-screen-position t
	          completions-detailed t
	          next-error-message-highlight t
	          read-minibuffer-restore-windows t
	          kill-do-not-save-duplicates t
	          confirm-kill-emacs 'y-or-n-p
	          x-alt-keysym 'meta
	          mouse-wheel-tilt-scroll t
	          mouse-wheel-flip-direction t
	          truncate-lines t
	          dired-use-ls-dired nil
	          dired-create-destination-dirs 'ask
	          dired-kill-when-opening-new-dired-buffer t
	          dired-do-revert-buffer t
	          dired-mark-region t
	          read-process-output-max (* 1024 1024)
	          enable-recursive-minibuffers t
	          sh-basic-offset 2
	          sh-basic-indentation 4)

(set-charset-priority 'unicode)
(prefer-coding-system 'utf-8-unix)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(show-paren-mode 1)
(delete-selection-mode t)
(global-display-line-numbers-mode t)
(column-number-mode)
(savehist-mode)
(global-goto-address-mode)
(global-so-long-mode)
(minibuffer-depth-indicate-mode)

;; Uncomment this code to highlight the active line
; (require 'hl-line)
; (add-hook 'prog-mode-hook #'hl-line-mode)
; (add-hook 'text-mode-hook #'hl-line-mode)

(add-hook 'compilation-mode-hook 'visual-line-mode)

;; IDO
; (rc/require 'smex 'ido-completing-read+)

; (require 'ido-completing-read+)

; (ido-mode 1)
; (ido-everywhere 1)
; (ido-ubiquitous-mode 1)

; (global-set-key (kbd "M-x") 'smex)
; (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; C-mode
(setq-default c-basic-offset 4
              c-default-style '((java-mode . "java")
                                (awk-mode . "awk")
                                (other . "bsd")))

(add-hook 'c-mode-hook (lambda ()
                         (interactive)
                         (c-toggle-comment-style -1)))

(require 'basm-mode)

(require 'fasm-mode)
(add-to-list 'auto-mode-alist '("\\.asm\\'" . fasm-mode))

(require 'porth-mode)

(require 'noq-mode)

(require 'jai-mode)

(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

(require 'c3-mode)

;; Whitespace mode
(defun rc/set-up-whitespace-handling ()
  (interactive)
  (whitespace-mode 0)
  (add-to-list 'write-file-functions 'delete-trailing-whitespace))

(add-hook 'tuareg-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'c++-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'c-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'simpc-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'emacs-lisp-mode 'rc/set-up-whitespace-handling)
(add-hook 'java-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'lua-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'rust-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'scala-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'markdown-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'haskell-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'python-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'erlang-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'asm-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'fasm-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'go-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'nim-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'yaml-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'porth-mode-hook 'rc/set-up-whitespace-handling)

;; Magit
(rc/require 'cl-lib)
(rc/require 'magit)

(setq magit-auto-revert-mode nil)

(global-set-key (kbd "C-c m s") 'magit-status)
(global-set-key (kbd "C-c m l") 'magit-log)

;; Multiple cursors
(rc/require 'multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)

;; Dired
(require 'dired-x)

(setq dired-omit-files
      (concat dired-omit-files "\\|^\\..+$"))
(setq-default dired-dwim-target t)
(setq dired-listing-switches "-alh")
(setq dired-mouse-drag-files t)

;; Move text
(rc/require 'move-text)

(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-<up>") 'move-text-up)

(global-set-key (kbd "M-n") 'move-text-down)
(global-set-key (kbd "M-<down>") 'move-text-down)

;; Packages that don't require configuration
(rc/require
 'scala-mode
 'd-mode
 'yaml-mode
 'glsl-mode
 'tuareg
 'lua-mode
 'less-css-mode
 'graphviz-dot-mode
 'clojure-mode
 'cmake-mode
 'rust-mode
 'csharp-mode
 'nim-mode
 'jinja2-mode
 'markdown-mode
 'purescript-mode
 'nix-mode
 'dockerfile-mode
 'toml-mode
 'nginx-mode
 'kotlin-mode
 'go-mode
 'php-mode
 'racket-mode
 'qml-mode
 'ag
 'elpy
 'typescript-mode
 'rfc-mode
 'sml-mode
 )

(load-file custom-file)
