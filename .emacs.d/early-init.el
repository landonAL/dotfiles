;; -*- lexical-binding: t; -*-

;;; OPTIMIZATION

;; Garbage collection

(setq gc-cons-threshold most-positive-fixnum)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 16777216)))

;; Native compilation

(if (and (featurep 'native-compile)
         (fboundp 'native-comp-available-p)
         (native-comp-available-p))
    (setq native-comp-deferred-compilation t
          package-native-compile t)
  (setq features (delq 'native-compile features)))

;;; GENERAL

(setq default-input-method nil)
(set-language-environment "UTF-8")
(setq read-process-output-max (* 256 1024)) ;; 256kb
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)
(setq ad-redefinition-action 'accept)
(setq warning-suppress-types '((defvaralias) (lexical-binding)))
(setq ffap-machine-p-known 'reject)
(setq frame-inhibit-implied-resize t)
(setq auto-mode-case-fold nil)
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)

(org-babel-load-file
 (expand-file-name
  "init.org"
  user-emacs-directory))
