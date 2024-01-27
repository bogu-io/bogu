#lang racket

;; format.rkt - Output formats.

;; Ask and I shall provide
(provide
    (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

(require json)

(define (format-json hashes)
  (write-json hashes))
