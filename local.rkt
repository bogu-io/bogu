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
	"walk.rkt")

; Local scan handler
(define (local-scan path)
  (displayln (scan-start-text "local path"))
  (cond [(verbose) (displayln path)])
  (define scan-results (recurse-through-files path))
  (cond [(debug) (displayln "[scan-results]")])
  (cond [(debug) (displayln scan-results)]))
