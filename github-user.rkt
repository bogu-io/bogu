#lang racket

;; github-user.rkt - GitHub User handler.

;; Ask and I shall provide
(provide
  (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

(require
	"parser.rkt"
    "github.rkt"
	"scanner.rkt"
	"strings.rkt"
	"walk.rkt")

; GitHub Repo scan handler
(define (github-user-scan user)
  (displayln (scan-start-text "GitHub User"))
  (cond [(verbose) (displayln user)])
  (define repos (get-all-repos user))
  (displayln repos))
  ; (recurse-through-files path)
  ; (cond [(verbose) (displayln scan-results)]))
