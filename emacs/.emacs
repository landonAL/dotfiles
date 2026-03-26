; -*- coding: utf-8; lexical-binding: t -*-

(setq custom-file "~/.emacs.custom.el")

(add-to-list 'load-path
             (file-name-as-directory
              (expand-file-name "~/.emacs.local")))

(load-file "~/.emacs.rc/rc.el")
(load-file "~/.emacs.rc/misc-rc.el")

;; optimization
(defvar last-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(defun config:defer-gc ()
  (setq gc-cons-threshold most-positive-fixnum))

(defun config:do-gc ()
  (let ((current-gc (car (memory-use-counts))))
    (when (> current-gc (* 50 1024 1024))
      (garbage-collect))

    (config:defer-gc)))

(config:defer-gc)
(add-hook 'minibuffer-exit-hook #'config:do-gc)

; (byte-recompile-directory (expand-file-name "~/.emacs.d" ) 0)

;; emergency security fix
;; https://bugs.debian.org/766397
(with-eval-after-load 'enriched
  (defun enriched-decode-display-prop (start end &optional param)
    (list start end)))

(with-eval-after-load 'time
  ;; Do not show system load in mode line
  (setq display-time-default-load-average nil)
  ;; By default, the file in environment variable MAIL is checked
  ;; It's "/var/mail/my-username"
  ;; I set `display-time-mail-function' to display NO mail notification in mode line
  (setq display-time-mail-function (lambda () nil)))

;; visual
;(when (member "Roboto Mono" (font-family-list))
;  (set-face-attribute 'default nil :font "Roboto Mono" :height 108)
;  (set-face-attribute 'fixed-pitch nil :family "Roboto Mono"))

(add-to-list 'default-frame-alist `(font . "Iosevka-18"))
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(rc/require-theme 'gruber-darker)

;; general
(when (window-system)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (tooltip-mode -1)
  (pixel-scroll-mode))

(when (eq system-type 'darwin)
  (setq ns-auto-hide-menu-bar t))

(setq default-directory (concat (getenv "HOME") "/"))

(setq-default inhibit-splash-screen t
	          inhibit-startup-message t
		      make-backup-files nil
	          auto-save-default nil
	          create-lockfiles nil
		      tab-width 4
		      indent-tabs-mode nil
		      compilation-scroll-output t
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
	          sh-basic-indentation 4
		      bidi-display-reordering 'left-to-right
		      bidi-paragraph-direction 'left-to-right
		      bidi-inhibit-bpa t
		      cursor-in-non-selected-windows nil
		      frame-inhibit-implied-resize t
		      ffap-machine-p-known 'reject
		      inhibit-compacting-font-caches t
		      TeX-auto-save t
		      TeX-parse-self t
		      TeX-PDF-mode t
		      TeX-master nil
              initial-buffer-choice 'dashboard-open)

(global-prettify-symbols-mode t)
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
(global-auto-revert-mode t)
(electric-pair-mode t)

;; disable line-numbers-mode for pdf-view-mode
(require 'display-line-numbers)
(defun display-line-numbers--turn-on ()
  "Turn on `display-line-numbers-mode'."
  (unless (or (minibufferp) (eq major-mode 'pdf-view-mode))
    (display-line-numbers-mode)))

;; move to inputted line
(global-unset-key (kbd "M-g g"))
(global-unset-key (kbd "M-g M-g"))
(global-set-key (kbd "C-x g") 'goto-line)

;; highlight the active line
; (require 'hl-line)
; (add-hook 'prog-mode-hook #'hl-line-mode)
; (add-hook 'text-mode-hook #'hl-line-mode)

(add-hook 'compilation-mode-hook 'visual-line-mode)

;; ido
(ido-mode 1)
(ido-everywhere 1)

(use-package ido-completing-read+
 :ensure t
 :defer t)

(ido-ubiquitous-mode 1)

; smex is an external extension on top of ido
(use-package smex
  :ensure t
  :defer t)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; c-mode
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

;; whitespace mode
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

;; magit
(use-package cl-lib
  :ensure t
  :defer t)

(use-package magit
  :ensure t
  :defer t)

(setq magit-auto-revert-mode nil)

(global-set-key (kbd "C-c m s") 'magit-status)
(global-set-key (kbd "C-c m l") 'magit-log)

;; org
(setq org-agenda-files '("~/org")
      org-log-done 'time
      org-return-follows-link t
      org-hide-emphasis-markers t
      org-adapt-indentation nil
      org-hide-leading-stars t
      org-pretty-entities t
      org-ellipsis "  ·"
      org-src-fontify-natively t
      org-src-tab-acts-natively t
      org-edit-src-content-indentation 0
      org-support-shift-select t)

(add-hook 'org-mode-hook 'org-indent-mode)
(add-hook 'org-mode-hook 'visual-line-mode)

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)

(use-package org-modern
  :ensure t
  :config
  (setq org-auto-align-tags t
        org-tags-column 0
        org-fold-catch-invisible-edits 'show-and-error
        org-special-ctrl-a/e t
        org-insert-heading-respect-content t
        org-modern-tag nil
        org-modern-priority nil
        org-modern-todo nil
        org-modern-table nil
        org-agenda-tags-column 0
        org-modern-star 'replace
        org-agenda-block-separator ?─
        org-agenda-time-grid
        '((daily today require-timed)
	      (800 1000 1200 1400 1600 1800 2000)
	      " ┄┄┄┄┄ " "┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄")
        org-agenda-current-time-string
        "⭠ now ─────────────────────────────────────────────────"))

(with-eval-after-load 'org (global-org-modern-mode))

;; dashboard
;(setq org-agenda-files
;      (directory-files-recursively "~/.emacs.d/org" "\\.org$"))

(require 'org-agenda)
(use-package dashboard
  :ensure t
  :custom
  (dashboard-banner-logo-title "Welcome to the editor of all time")
  (dashboard-startup-banner 'official)
  (dashboard-vertically-center-content t)
  (dashboard-set-heading-icons t)
  (dashboard-set-file-icons t)
  (dashboard-center-content t)
  (dashboard-show-shortcuts nil)
  (dashboard-agenda-prefix-format " %i%?-12t% s")
  (dashboard-week-agenda t)
  (dashboard-filter-agenda-entry 'dashboard-no-filter-agenda)
  (dashboard-items '((recents   . 5)
                     (projects  . 5)
                     (agenda    . 5)))
  :hook
  (dashboard-mode . (lambda () (read-only-mode 1)))
  :config
  (dashboard-setup-startup-hook))

;; doom modeline
;(use-package doom-modeline
;  :ensure t
;  :defer t
;  :init (doom-modeline-mode 1))

;; exwm
(use-package exwm
  :ensure t)

(setq exwm-workspace-number 1)

(add-hook 'exwm-update-class-hook
  (lambda () (exwm-workspace-rename-buffer exwm-class-name)))

(setq exwm-input-global-keys
      `(([?\s-r] . exwm-reset)
        ([?\s-w] . exwm-workspace-switch)
        ([?\s-s] . (lambda (cmd)
                     (interactive (list (read-shell-command "$ ")))
                     (start-process-shell-command cmd nil cmd)))
        ,@(mapcar (lambda (i)
                    `(,(kbd (format "s-%d" i)) .
                      (lambda ()
                        (interactive)
                        (exwm-workspace-switch-create ,i))))
                  (number-sequence 0 9))))

;(setq exwm-input-simulation-keys
;      '(([?\C-b] . [left])
;        ([?\C-f] . [right])
;        ([?\C-p] . [up])
;        ([?\C-n] . [down])
;        ([?\C-a] . [home])
;        ([?\C-e] . [end])
;        ([?\M-v] . [prior])
;        ([?\C-v] . [next])
;        ([?\C-d] . [delete])
;        ([?\C-k] . [S-end delete])
;        ([?\C-w] . [?\C-x])
;        ([?\M-w] . [?\C-c])
;        ([?\C-y] . [?\C-v])
;            ([?\M-d] . [C-delete])))

(exwm-wm-mode)

; make firefox window's buffer name match tab title
;(defun efs/exwm-update-title ()
;  (pcase exwm-class-name
;    ("firefox" (exwm-workspace-rename-buffer (format "firefox: %s" exwm-title)))))

;; When window title updates, use it to set the buffer name
;(add-hook 'exwm-update-title-hook #'efs/exwm-update-title)

;(with-eval-after-load 'exwm (require 'exwm-firefox-core))
;(with-eval-after-load 'exwm-firefox-core (require 'exwm-firefox))
;(with-eval-after-load 'exwm-firefox (exwm-firefox-mode))

;; ewm
;(use-package ewm
;  :bind (:map ewm-mode-map
;         ("s-<return>" . (lambda () (interactive)
;                           (start-process "st" nil "st")))
;         ("s-d" . ewm-launch-app))

(defun time ()
  (interactive)
  (message "%s" (format-time-string "%H:%M:%S")))

;; vterm
;(use-package vterm
;  :ensure t
;  :defer t)

;(global-set-key (kbd "C-c C-v") 'vterm)

;; auctex
(use-package auctex
  :ensure t
  :defer t)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

(add-hook 'LaTeX-mode-hook
          (lambda ()
            (setq truncate-lines nil)))

(require 'tex-site)
; (setq TeX-view-program-selection '((output-pdf "PDF Tools")))

(add-hook 'doc-view-mode-hook 'auto-revert-mode)

;; cdlatex
(use-package cdlatex
  :ensure t
  :defer t)

(add-hook 'LaTeX-mode-hook #'turn-on-cdlatex)

(setq cdlatex-math-symbol-alist
'((?: ("\\colon" "\\,\\middle|\\," "\\mid"))
(?t ("\\tau" "\\to" "\\tan"))
(?0 ("\\varnothing" "\\emptyset"))
(?i ("\\in" "\\imath" "\\iota"))
(?~ ("\\approx" "\\simeq" "\\sim"))
(?. ("\\cdot" "\\cdots" "\\ldots"))
))

;; pdf-tools
(use-package pdf-tools
  :ensure t
  :defer t
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :pin manual
  :config
  (setq pdf-info-epdfinfo-program "/usr/local/bin/epdfinfo"))

(add-hook 'pdf-view-mode-hook
          (lambda ()
	    ;; open pdfs scaled to fit page
            (setq-default pdf-view-display-size 'fit-page)
	    ;; more fine-grained zooming
            (setq pdf-view-resize-factor 1.1)))

(defvar pdf-minimal-width 72
  "Minimal width of a window displaying a pdf.
If an integer, number of columns.  If a float, fraction of the
original window.")

(defvar pdf-split-width-threshold 0
  "Minimum width a window should have to split it horizontally
for displaying a pdf in the right.")

(defun pdf-split-window-sensibly (&optional window)
  "A version of `split-window-sensibly' for pdfs.
It prefers splitting horizontally, and takes `pdf-minimal-width'
into account."
  (let ((window (or window (selected-window)))
	(width (- (if (integerp pdf-minimal-width)
		      pdf-minimal-width
		    (round (* pdf-minimal-width (window-width window)))))))
    (or (and (window-splittable-p window t)
	     ;; Split window horizontally.
	     (with-selected-window window
	       (split-window-right width)))
	(and (window-splittable-p window)
	     ;; Split window vertically.
	     (with-selected-window window
	       (split-window-below)))
	(and (eq window (frame-root-window (window-frame window)))
	     (not (window-minibuffer-p window))
	     ;; If WINDOW is the only window on its frame and is not the
	     ;; minibuffer window, try to split it vertically disregarding
	     ;; the value of `split-height-threshold'.
	     (let ((split-height-threshold 0))
	       (when (window-splittable-p window)
		 (with-selected-window window
		   (split-window-below))))))))

(defun display-buffer-pop-up-window-pdf-split-horizontally (buffer alist)
  "Call `display-buffer-pop-up-window', using `pdf-split-window-sensibly'
when needed."
  (let ((split-height-threshold nil)
	(split-width-threshold pdf-split-width-threshold)
	(split-window-preferred-function #'pdf-split-window-sensibly))
    (display-buffer-pop-up-window buffer alist)))

(add-to-list 'display-buffer-alist '("\\.pdf\\(<[^>]+>\\)?$" . (display-buffer-pop-up-window-pdf-split-horizontally)))

;; multiple cursors
(use-package multiple-cursors
  :ensure t
  :defer t)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)

;; move text
(use-package move-text
  :ensure t
  :defer t)

(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-<up>") 'move-text-up)

(global-set-key (kbd "M-n") 'move-text-down)
(global-set-key (kbd "M-<down>") 'move-text-down)

;; arduino configuration
(defun arduino-create ()
  "Creates an Arduino sketch with the given name in the current directory."
  (interactive)
  (let* ((sketch (read-string "Enter sketch name: "))
         (dir-path (expand-file-name sketch))
         (file-path (expand-file-name (concat sketch ".ino") dir-path)))

    (make-directory dir-path t)
    (with-temp-file file-path
      (insert "void setup() {\n}\n\nvoid loop() {\n}"))))

(defun arduino-compile ()
  "Compile and upload an Arduino sketch chosen from .ino files in the current directory."
  (interactive)
  (let* ((ino-files (directory-files default-directory nil "\\.ino\\'"))
         (sketch (if ino-files
                     (completing-read "Select Arduino sketch: " ino-files nil t)
                   (user-error "No .ino files found in this directory")))
         (command (format
                   "arduino-cli compile --fqbn arduino:avr:uno %s && \ arduino-cli upload -p /dev/ttyACM0 --fqbn arduino:avr:uno %s" sketch sketch)))
    (shell-command command "*Arduino Output*" "*Arduino Error Buffer*")))

;; packages that don't require configuration
(use-package scala-mode
  :ensure t
  :defer t)

(use-package arduino-mode
  :ensure t
  :defer t)

(use-package d-mode
  :ensure t
  :defer t)

(use-package yaml-mode
  :ensure t
  :defer t)

(use-package glsl-mode
  :ensure t
  :defer t)

(use-package tuareg
  :ensure t
  :defer t)

(use-package lua-mode
  :ensure t
  :defer t)

(use-package less-css-mode
  :ensure t
  :defer t)

(use-package graphviz-dot-mode
  :ensure t
  :defer t)

(use-package clojure-mode
  :ensure t
  :defer t)

(use-package cmake-mode
  :ensure t
  :defer t)

(use-package rust-mode
  :ensure t
  :defer t)

(use-package csharp-mode
  :ensure t
  :defer t)

(use-package nim-mode
  :ensure t
  :defer t)

(use-package jinja2-mode
  :ensure t
  :defer t)

(use-package markdown-mode
  :ensure t
  :defer t)

(use-package purescript-mode
  :ensure t
  :defer t)

(use-package nix-mode
  :ensure t
  :defer t)

(use-package dockerfile-mode
  :ensure t
  :defer t)

(use-package toml-mode
  :ensure t
  :defer t)

(use-package nginx-mode
  :ensure t
  :defer t)

(use-package kotlin-mode
  :ensure t
  :defer t)

(use-package go-mode
  :ensure t
  :defer t)

(use-package php-mode
  :ensure t
  :defer t)

(use-package racket-mode
  :ensure t
  :defer t)

(use-package qml-mode
  :ensure t
  :defer t)

(use-package ag
  :ensure t
  :defer t)

(use-package elpy
  :ensure t
  :defer t)

(use-package typescript-mode
  :ensure t
  :defer t)

(use-package rfc-mode
  :ensure t
  :defer t)

(use-package sml-mode
  :ensure t
  :defer t)

(defun restore-file-name-handlers ()
  (setq file-name-handler-alist last-file-name-handler-alist))

(add-hook 'emacs-startup-hook 'restore-file-name-handlers)

(load-file custom-file)
