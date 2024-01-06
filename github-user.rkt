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
  ; TODO: --debug - https://github.com/bogu-io/bogu/issues/22
  (cond [(verbose) (displayln repos)])
  (let loop ([archive-urls repos])
    (when (not (null? archive-urls))
      (define archive-url (first archive-urls))
      (displayln archive-url)
      (define archive-path (download-repo-archive archive-url))
      (delete-archive archive-path)
      (loop (rest archive-urls))))
  (cond [(verbose) (displayln scan-results)]))

  ; (recurse-through-files path)
  ; (cond [(verbose) (displayln scan-results)]))
