;;; exwm-firefox.el --- Firefox + EXWM     -*- lexical-binding: t; -*-

;; Copyright (C) 2019, 2020, 2021, 2022, 2023, 2024  Ian Eure

;; Author: Ian Eure <ian@retrospec.tv>
;; Version: 1.3
;; URL: https://github.com/ieure/exwm-firefox
;; Package-Requires: ((emacs "25") (s "1.12.0") (exwm "0.22.1") (exwm-firefox-core "20190608.2213"))
;; Keywords: extensions

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This package adds enhanced support for Firefox under EXWM.
;; Keybindings intentionally mirror other Emacs navigation controls.

;; To enable it, run M-x exwm-firefox-mode RET

;; - Navigate forwards (=C-c C-f=) and backwards (=C-c C-b=) in
;;   browsing history.
;; - Open a new window in an Emacs split (=C-c C-n=).
;; - Open a new private window in an Emacs split (=C-c C-p=).
;; - Detach the current tab into an Emacs split window (=C-c C-d=).
;;   Requires tabdetach extension.
;; - Merge the detached tab back into its parent window (=C-c C-=).
;;   Requires tabdetach extension.

;;; Code:

(require 'exwm-firefox-core)
(require 's)
(eval-when-compile
  (require 'subr-x)
  (require 'cl-macs))

(defgroup exwm-firefox nil
  "Customizing EXWM enhancements for Firefox-like browsers."
  :prefix "exwm-firefox-"
  :group 'exwm)

(defcustom exwm-firefox-classes
  '("firefox" "librewolf" "icecat" "iceweasel")
  "List of X11 class names of Firefox-based browsers.

  If a client's EXWM-CLASS-NAME contains one of these substrings,
  exwm-firefox-mode will be enabled for it."
  :type '(repeat string))

(defvar exwm-firefox--intercept nil
  "The function to call when a new Firefox window is created.")

(defun exwm-firefox--make-keymap ()
  "Create keymap to apply to Firefox windows."
  (let ((map (copy-keymap (current-local-map))))
    (define-key map "\C-c\C-f" 'exwm-firefox-core-history-forward)
    (define-key map "\C-c\C-b" 'exwm-firefox-core-history-back)
    (define-key map "\C-c\C-n" 'exwm-firefox-split-window)
    (define-key map "\C-c\C-p" 'exwm-firefox-split-private)
    (define-key map "\C-c\C-d" 'exwm-firefox-split-detach)
    (define-key map "\C-c\C-g" 'exwm-firefox-merge)
    map))

(defun exwm-firefox? (&optional client-class-name)
  "Does the current buffer contain a Firefox window?"
  (cl-loop for class in exwm-firefox-classes
           with client-class-name = (or client-class-name exwm-class-name)
           when (s-contains? class client-class-name t)
           return class))

(defun exwm-firefox--setup-hook ()
  "Set up exwm-firefox for new clients."
  (when (exwm-firefox?)
    (use-local-map (exwm-firefox--make-keymap))
    (when exwm-firefox--intercept
      (funcall exwm-firefox--intercept))))

(defun exwm-firefox--class+title->buffer-name (&optional class title)
  (save-match-data
    (when-let ((browser-name (exwm-firefox? (or class exwm-class-name))))
      (let* ((title (or title exwm-title))
             (page-loaded? (caar (last (s-matched-positions-all "\\S+[-—]\\S+" title))))
             (page-title (if page-loaded? (substring title 0 page-loaded?) nil))
             (window-description (if page-loaded? (substring title page-loaded?) title))
             (private? (s-contains? "private" window-description t)))
        (concat "*"
                browser-name
                (when private? "-private")
                (when page-title (concat ": " page-title))
                "*")))))

(defun exwm-firefox--update-title ()
  (when-let ((name (exwm-firefox--class+title->buffer-name)))
    (rename-buffer (generate-new-buffer-name name))))

(defun exwm-firefox--split (old-window-config)
  "Move a new Firefox window into a split.

   OLD-WINDOW-CONFIG is the window confguration at the time the
   split window was created.

   Returns nil."
  (let ((new-firefox (current-buffer)))
    (set-window-configuration old-window-config)
    (switch-to-buffer-other-window new-firefox)
    (exwm-firefox-core-focus-search-bar)
    (setq exwm-firefox--intercept nil)))

(defun exwm-firefox--intercept-hook ()
  "Run an action the next time a Firefox window is created."
  (if-let ((callback (and (exwm-firefox?) exwm-firefox--intercept)))
      (funcall callback)))

(defun exwm-firefox--intercept-next (data callback)
  "Perform an action the next time a Firefox window is created.

   Calls function CALLBACK with DATA as its only argument."

  (unless (exwm-firefox?)
    (error "Not a Firefox window"))
  (when exwm-firefox--intercept
    (warn "Already intercepting"))

  (setq exwm-firefox--intercept (apply-partially callback data))

  ;; If nothing happens in 3 seconds, reset the state
  (run-with-timer 3 nil (lambda () (setq exwm-firefox--intercept nil))))

(defun exwm-firefox-split-window ()
  "Create a new Firefox window in a split."
  (interactive)
  (exwm-firefox--intercept-next (current-window-configuration)
                                'exwm-firefox--split)
  (exwm-firefox-core-window-new))

(defun exwm-firefox-split-private ()
  "Create a new Firefox private window in a split.

   With ARG prefix, display the window in that workspace."
  (interactive)
  (exwm-firefox--intercept-next (current-window-configuration)
                                'exwm-firefox--split)
  (exwm-firefox-core-window-new-private))

(defun exwm-firefox-split-detach ()
  "Detach the current tab into a new split window.

   With no ARG, create the new window in a split in the current workspace.

   This requires the tabdetach extension to work."
  (interactive)
  (exwm-firefox--intercept-next (current-window-configuration)
                                'exwm-firefox--split)
  (exwm-input--fake-key ?\M-\S-d))

(defun exwm-firefox-merge ()
  "Merge the current tab into its parent window.

   This requires the tabdetach extension to work."
  (interactive)
  (exwm-input--fake-key ?\M-\S-m))

(define-minor-mode exwm-firefox-mode
  "Minor mode to enhance Firefox in EXWM."
  :init-value nil
  :lighter nil
  :keymap nil
  :keymap nil
  :group 'tools
  :global t
  (setq exwm-firefox--intercept nil)
  (if exwm-firefox-mode
      (progn
        (add-hook 'exwm-manage-finish-hook 'exwm-firefox--setup-hook)
        (add-hook 'exwm-update-title-hook 'exwm-firefox--update-title))
    (remove-hook 'exwm-manage-finish-hook 'exwm-firefox--setup-hook)
    (remove-hook 'exwm-update-title-hook 'exwm-firefox--update-title)))

(provide 'exwm-firefox)
;;; exwm-firefox.el ends here
