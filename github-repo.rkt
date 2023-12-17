#lang racket

;; github-repo.rkt - GitHub repo handler.

;; Ask and I shall provide
(provide
  (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

(require
	"parser.rkt"
	"scanner.rkt"
	"strings.rkt"
	"walk.rkt")

; GitHub Repo scan handler
(define (github-repo repo)
  (displayln (scan-start-text "GitHub repo"))
  (cond [(verbose) (displayln repo)])
  (recurse-through-files path)
  (cond [(verbose) (displayln scan-results)]))
