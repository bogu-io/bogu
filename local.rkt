#lang racket

;; local.rkt - Local path handler.

;; Ask and I shall provide
(provide
  (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

(require
	"parser.rkt"
	"strings.rkt"
	"walk.rkt"
  "format.rkt")

; Local scan handler
(define (local-scan path)
  (displayln (scan-start-text "local path"))
  (cond [(verbose) (displayln path)])
  (recurse-through-files path)
  (cond [(debug) (displayln "[local-scan-results]")])
  (cond [(debug) (displayln local-scan-results)])
  (cond [(equal? (output-format) "hash-list")
         (displayln local-scan-results)]
        [(equal? (output-format) "json")
         (printf "~a\n" (format-json local-scan-results))])
  (reset-scan))
