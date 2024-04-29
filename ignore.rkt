#lang racket

;; ignore.rkt - Ignore paths and files

;; Ask and I shall provide
(provide
  (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

(define (read-ignore-patterns file-path)
  (with-input-from-file file-path
    (lambda ()
      (filter (lambda (line) (not (empty? line)))
              (file->lines)))))

; Function to check if a path should be ignored
(define (should-ignore? path patterns)
  (ormap (lambda (pattern)
           (regexp-match pattern path))
         patterns))

; Example usage:
(define patterns (read-ignore-patterns "path/to/.gitignore-like"))
(should-ignore? "example.log" patterns)  ; Usage with loaded patterns