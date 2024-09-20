;; -*- lexical-binding: t; -*-

(defvar last-file-name-handler-alist file-name-handler-alist)
(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6
      file-name-handler-alist nil)

(require 'package)

(setq package-archives
   '(("melpa" . "http://melpa.org/packages/")
     ("elp" . "http://elpa.gnu.org/packages/")
     ("gnu-devel" . "http://elpa.gnu.org/devel/")
     ("nongnu" . "http://elpa.nongnu.org/nongnu/")
     ))

(eval-when-compile
  (require 'use-package))

(use-package magit
  :ensure t
  :defer t)

(use-package org
  :ensure t
  :defer t)

(use-package org-bullets
  :ensure t
  :defer t
  :init
    (add-hook 'org-mode-hook (lambda ()
                (org-bullets-mode 1))))

(custom-set-faces
  '(org-level-1 ((t (:inherit outline-1 :height 1.7))))
  '(org-level-2 ((t (:inherit outline-2 :height 1.6))))
  '(org-level-3 ((t (:inherit outline-3 :height 1.5))))
  '(org-level-4 ((t (:inherit outline-4 :height 1.4))))
  '(org-level-5 ((t (:inherit outline-5 :height 1.3))))
  '(org-level-6 ((t (:inherit outline-6 :height 1.2))))
  '(org-level-7 ((t (:inherit outline-7 :height 1.1)))))

(use-package expand-region
  :ensure t
  :defer t
  :bind ("C-<SPC>" . er/expand-region))

(add-to-list 'custom-theme-load-path (expand-file-name "themes" user-emacs-directory))

(load-theme 'gruber-darker t)

(custom-set-faces
 '(line-number-current-line ((t (:inherit (hl-line default) :weight bold)))))

(setq-default line-spacing 0.12)

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(font-lock-mode 1)
(set-face-attribute 'default nil :font "Iosevka-18")

(global-display-line-numbers-mode 1)
(global-visual-line-mode t)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(setq inhibit-startup-screen t)
(show-paren-mode 1)
(setq visible-bell t)
(setq blink-matching-paren nil)

(delete-selection-mode 1)
(electric-indent-mode -1)
(electric-pair-mode 1)
(setq sentence-end-double-space nil)
(setq save-interprogram-paste-before-kill t)
(setq mouse-yank-at-point t)
(setq kill-do-not-save-duplicates t)

(global-auto-revert-mode t)
(save-place-mode 1)
(setq auto-save-default t)
(setq auto-save-include-big-deletions t)
(setq load-prefer-newer t)
(setq require-final-newline t)
(setq backup-by-copying t)
(setq create-lockfiles nil)
(setq make-backup-files nil)
(setq delete-old-versions t)
(setq version-control t)
(setq vc-make-backup-files nil)

(ido-mode 1)
(ido-everywhere 1)

(setq fast-but-imprecise-scrolling t)
(setq hscroll-margin 2
      hscroll-step 1
      scroll-conservatively 10
      scroll-margin 0
      scroll-preserve-screen-position t
      auto-window-vscroll nil
      mouse-wheel-scroll-amount '(2 ((shift) . hscroll))
      mouse-wheel-scroll-amount-horizontal 2)

(setq frame-resize-pixelwise t)
(setq window-resize-pixelwise nil)
(setq resize-mini-windows 'grow-only)

(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

(setq gc-cons-threshold 16777216
      gc-cons-percentage 0.1
      file-name-handler-alist last-file-name-handler-alist)
