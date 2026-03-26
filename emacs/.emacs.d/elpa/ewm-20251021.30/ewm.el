;;; ewm.el --- Window manager -*- lexical-binding: t; -*-

;; Copyright (C) 2025

;; Author: Laluxx
;; Package-Version: 20251021.30
;; Package-Revision: aed05324efc2
;; Package-Requires: ((emacs "26.1") (eyebrowse "0.7.8"))
;; Keywords: windows, convenience
;; URL: https://github.com/laluxx/ewm

;; This file is not part of GNU Emacs.

;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.
;;

;;; Commentary:

;;             1 2 3 4 5 6 7 8 9 (workspaces)
;;                        ^ UP
;;                  (split/previous)
;;              (quit) q  k  TAB (last-workspace)
;;                      \ ^ /
;;   < LEFT (s/res) h  <- M -> l  (split/resize) > RIGHT
;;                        v \
;;                        j  SPC (Monocle)
;;                  (split/next)
;;                        v DOWN

;; Keybind behaves differently based on the number of windows in the current workspace.

;; usage: (global-ewm-mode 1)

;;; Code:

(require 'eyebrowse)
(require 'windmove)

(defgroup ewm nil
  "Window management utilities for Emacs."
  :group 'convenience
  :prefix "ewm-")

(defcustom ewm-rotate-stack-prev-fn 'scratch-buffer
  "Function to call when rotating stack backward from a single window."
  :type 'function
  :group 'ewm)

(defcustom ewm-rotate-stack-next-fn 'term
  "Function to call when rotating stack forward from a single window."
  :type 'function
  :group 'ewm)

(defcustom ewm-split-from-special-fn #'ewm-split-from-special-default-fn
  "Function to call after splitting from a special buffer.
Special buffers are those whose names start with *."
  :type 'function
  :group 'ewm)

(defvar ewm-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "M-j") #'ewm-down)
    (define-key map (kbd "M-k") #'ewm-up)
    (define-key map (kbd "M-h") #'ewm-left)
    (define-key map (kbd "M-l") #'ewm-right)
    (define-key map (kbd "M-J") #'ewm-swap-with-next-window)
    (define-key map (kbd "M-K") #'ewm-swap-with-prev-window)
    (define-key map (kbd "M-q") #'ewm-delete-window)
    map)
  "Keymap for `ewm-mode'.")

(defvar ewm-override-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "M-j") #'ewm-down)
    (define-key map (kbd "M-k") #'ewm-up)
    (define-key map (kbd "M-h") #'ewm-left)
    (define-key map (kbd "M-l") #'ewm-right)
    (define-key map (kbd "M-J") #'ewm-swap-with-next-window)
    (define-key map (kbd "M-K") #'ewm-swap-with-prev-window)
    (define-key map (kbd "M-q") #'ewm-delete-window)
    (define-key map (kbd "M-SPC") #'ewm-monocle)
    
    (define-key map (kbd "M-1") (lambda () (interactive) (eyebrowse-switch-to-window-config 1)))
    (define-key map (kbd "M-2") (lambda () (interactive) (eyebrowse-switch-to-window-config 2)))
    (define-key map (kbd "M-3") (lambda () (interactive) (eyebrowse-switch-to-window-config 3)))
    (define-key map (kbd "M-4") (lambda () (interactive) (eyebrowse-switch-to-window-config 4)))
    (define-key map (kbd "M-5") (lambda () (interactive) (eyebrowse-switch-to-window-config 5)))
    (define-key map (kbd "M-6") (lambda () (interactive) (eyebrowse-switch-to-window-config 6)))
    (define-key map (kbd "M-7") (lambda () (interactive) (eyebrowse-switch-to-window-config 7)))
    (define-key map (kbd "M-8") (lambda () (interactive) (eyebrowse-switch-to-window-config 8)))
    (define-key map (kbd "M-9") (lambda () (interactive) (eyebrowse-switch-to-window-config 9)))
    (define-key map (kbd "M-TAB") #'eyebrowse-last-window-config)
    map)
  "Keymap for overriding major mode keybindings.")

(defvar ewm-monocle-state nil
  "Current window configuration for monocle mode.")

(defvar ewm-monocle-buffers nil
  "List of buffers visible before entering monocle mode.")

(defun ewm-activate-override-map ()
  "Activate the override keymap for EWM."
  (add-to-list 'emulation-mode-map-alists `((ewm-mode . ,ewm-override-map))))

(defun ewm-get-user-init-file ()
  "Get the path to the user's init file."
  (or user-init-file
      (expand-file-name "init.el" user-emacs-directory)))

(defun ewm-split-from-special-default-fn ()
  "Default function called after splitting from a special buffer."
  (find-file (ewm-get-user-init-file)))

(defun ewm-split-window-above (&optional size)
  "Split window above with optional SIZE."
  (let ((new-window (split-window nil (and size (- size)) 'above)))
    (select-window new-window)))

(defun ewm-split-window-left (&optional size)
  "Split window left with optional SIZE."
  (let ((new-window (split-window nil (and size (- size)) 'left)))
    (select-window new-window)))

(defun ewm-split (direction &optional size)
  "Split window in DIRECTION and perform post-split actions.
DIRECTION can be `below', `right', `above', or `left'.
SIZE is optional size for the new window.

Post-split behavior for special buffers is configurable via
`ewm-split-from-special-fn'."
  (let* ((current-buffer (current-buffer))
         (is-special (string-match-p "^\\*" (buffer-name current-buffer))))
    (pcase direction
      ('below (split-window-below size))
      ('right (split-window-right size))
      ('above (ewm-split-window-above size))
      ('left (ewm-split-window-left size)))
    
    ;; Perform post-split actions
    (when is-special
      (funcall ewm-split-from-special-fn))
    
    ;; For C files, try to open header if appropriate
    (unless is-special
      (ewm-open-header))))

;;;###autoload
(defun ewm-down ()
  "Navigate down, split window, or cycle buffers in monocle mode."
  (interactive)
  (if ewm-monocle-state
      (ewm-monocle-cycle-buffer 'next)
    (if (= (length (window-list)) 1)
        (progn
          (ewm-split 'below)
          (windmove-down))
      (other-window 1))))

;;;###autoload
(defun ewm-up ()
  "Navigate up, split window, or cycle buffers in monocle mode."
  (interactive)
  (if ewm-monocle-state
      (ewm-monocle-cycle-buffer 'prev)
    (if (= (length (window-list)) 1)
        (ewm-split 'below)
      (other-window -1))))

;;;###autoload
(defun ewm-left ()
  "Split vertically or resize window based on current layout."
  (interactive)
  (if (= (length (window-list)) 1)
      (ewm-split 'right)
    (if (= (window-pixel-left (selected-window))
           (window-pixel-left (next-window)))
        ;; Vertical arrangement - resize height
        (if (window-at-side-p (selected-window) 'bottom)
            (enlarge-window 5)
          (shrink-window 5))
      ;; Horizontal arrangement - resize width
      (if (window-at-side-p (selected-window) 'right)
          (enlarge-window-horizontally 5)
        (shrink-window-horizontally 5)))))

;;;###autoload
(defun ewm-right ()
  "Split vertically and move right, or resize window based on current layout."
  (interactive)
  (if (= (length (window-list)) 1)
      (let* ((current-buffer (current-buffer))
             (is-special (string-match-p "^\\*" (buffer-name current-buffer))))
        (split-window-right)
        (windmove-right)
        (if is-special
            (funcall ewm-split-from-special-fn)
          (ewm-open-header)))
    (if (= (window-pixel-left (selected-window))
           (window-pixel-left (next-window)))
        ;; Vertical arrangement - resize height
        (if (window-at-side-p (selected-window) 'bottom)
            (shrink-window 5)
          (enlarge-window 5))
      ;; Horizontal arrangement - resize width
      (if (window-at-side-p (selected-window) 'right)
          (shrink-window-horizontally 5)
        (enlarge-window-horizontally 5)))))

;;;###autoload
(defun ewm-delete-window ()
  "Delete the current window, or kill the buffer if it's the only window."
  (interactive)
  (if (= (length (window-list)) 1)
      (kill-buffer (current-buffer))
    (delete-window)))

(defun ewm-rotate-stack (direction)
  "Swap the current window with the window in DIRECTION (`next' or `prev').
When there's only one window, split and call the appropriate function:
- `ewm-rotate-stack-prev-fn' for `prev'
- `ewm-rotate-stack-next-fn' for `next'"
  (if (= (length (window-list)) 1)
      (progn
        (split-window-below)
        (other-window 1)
        (call-interactively
         (if (eq direction 'prev)
             ewm-rotate-stack-prev-fn
           ewm-rotate-stack-next-fn)))
    (let* ((current (selected-window))
           (other-window (if (eq direction 'prev)
                             (previous-window)
                           (next-window)))
           (current-buf (window-buffer current))
           (other-buf (window-buffer other-window))
           (current-pos (window-start current))
           (other-pos (window-start other-window)))
      (unless (eq current other-window)
        (set-window-buffer current other-buf)
        (set-window-buffer other-window current-buf)
        (set-window-start current other-pos)
        (set-window-start other-window current-pos)
        (select-window other-window)))))

;;;###autoload
(defun ewm-swap-with-next-window ()
  "Swap current window with next window."
  (interactive)
  (ewm-rotate-stack 'next))

;;;###autoload
(defun ewm-swap-with-prev-window ()
  "Swap current window with previous window."
  (interactive)
  (ewm-rotate-stack 'prev))

(defun ewm-open-header ()
  "Open matching header file if current buffer is a C source file."
  (when-let* ((current-file (buffer-file-name))
              ((string-match "\\(.+\\)\\.c\\'" current-file))
              (file-base (match-string 1 current-file))
              (header-file (concat file-base ".h"))
              ((file-exists-p header-file)))
    (find-file header-file)))

;;;###autoload
(defun ewm-monocle ()
  "Toggle between multiple windows and single window (monocle mode).
This maximizes the current window while preserving the layout for restoration."
  (interactive)
  (if (one-window-p)
      (when ewm-monocle-state
        (set-window-configuration ewm-monocle-state)
        (setq ewm-monocle-state nil)
        (setq ewm-monocle-buffers nil))
    (setq ewm-monocle-state (current-window-configuration))
    (setq ewm-monocle-buffers (mapcar #'window-buffer (window-list)))
    (delete-other-windows)))

(defun ewm-monocle-cycle-buffer (direction)
  "Cycle through buffers in monocle mode based on DIRECTION.
DIRECTION should be `next' or `prev'."
  (let* ((current-buffer (window-buffer (selected-window)))
         (buffers ewm-monocle-buffers)
         (current-index (cl-position current-buffer buffers :test #'eq))
         (count (length buffers))
         (new-index (pcase direction
                      ('next (mod (1+ current-index) count))
                      ('prev (mod (1- current-index) count))))
         (new-buffer (nth new-index buffers)))
    (set-window-buffer (selected-window) new-buffer)))

(defun ewm-setup-eyebrowse ()
  "Setup eyebrowse configuration for EWM."
  (setq eyebrowse-mode-line-style nil)
  (setq eyebrowse-tagged-slot-format "%t")
  (eyebrowse-mode 1))

;;;###autoload
(define-minor-mode ewm-mode
  "Minor mode for window management utilities.
Provides tiling window manager-style keybindings for window operations."
  :lighter " EWM"
  :keymap ewm-mode-map
  :group 'ewm
  (when ewm-mode
    (ewm-activate-override-map)
    (ewm-setup-eyebrowse)))

;;;###autoload
(define-globalized-minor-mode global-ewm-mode
  ewm-mode
  (lambda () (ewm-mode 1))
  :group 'ewm)

(provide 'ewm)

;;; ewm.el ends here
