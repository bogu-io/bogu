#lang racket

;; ignore.rkt - Ignore paths and files

;; Ask and I shall provide
(provide
  (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

(require
  "utils.rkt")

(define (read-ignore-patterns file-path)
  (define file-path-resolved (simplify-path (expand-home-path file-path)))
  (cond [(file-exists? file-path-resolved)
         (with-input-from-file file-path-resolved
           (lambda ()
             (filter (lambda (line) (not (empty? line)))
                     (file->lines file-path-resolved))))]))

; Function to check if a path should be ignored
(define (should-ignore? path patterns)
  (for/or ([pattern patterns])
    (regexp-match? pattern path)))

; Example usage:
; (define patterns (read-ignore-patterns "path/to/.gitignore-like"))
; (should-ignore? "example.log" patterns)  ; Usage with loaded patterns