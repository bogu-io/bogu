#lang racket

;; walk.rkt - File system walker.

;; Ask and I shall provide
(provide
  (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

(require
  "parser.rkt"
  "scanner.rkt")

; Filesystem path walker
(define (recurse-through-files path)
  (define path-objects (directory-list path #:build? #t))
  (cond [(verbose) (printf "~a\n" path-objects)])
  (for ([path-object path-objects])
    (define path-object-string (path->string path-object))
    (cond
      [(directory-exists? path-object)
        (printf "Entering directory: ~a\n" path-object)
        (recurse-through-files path-object-string)]
      [(file-exists? path-object)
        (printf "File: ~a\n" path-object-string)
        (hash-set! scan-results path-object-string (find-secrets path-object-string))]
      [else
        (printf "Other: ~a\n" path-object-string)
        (hash-set! scan-results path-object-string (find-secrets path-object-string))])))
