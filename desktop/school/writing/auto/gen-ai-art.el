;; -*- lexical-binding: t; -*-

(TeX-add-style-hook
 "gen-ai-art"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("12pt, " "") ("12pt, letterpaper" "") ("article" "12pt" "letterpaper")))
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art12"))
 :latex)

