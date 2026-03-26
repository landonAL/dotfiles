;; -*- lexical-binding: t; -*-

(TeX-add-style-hook
 "base10-to-other-base"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "12pt" "letterpaper")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("amsmath" "")))
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art12"
    "amsmath"))
 :latex)

