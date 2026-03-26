;; -*- lexical-binding: t; -*-

(TeX-add-style-hook
 "latex"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("book" "letterpaper" "12pt") ("article" "12pt" "" "letterpaper" "50pt" "15pt")))
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art12"))
 :latex)

