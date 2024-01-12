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

(define github-results '())

; GitHub Repo scan handler
(define (github-user-scan user)
  (displayln (scan-start-text "GitHub User"))
  (cond [(verbose) (displayln user)])
  (define-values (repos) (get-all-repos user))
  ; TODO: --debug - https://github.com/bogu-io/bogu/issues/22
  ; (cond [(verbose) (displayln repos)])
  (let loop ([archive-urls repos])
    (when (not (null? archive-urls))
      (define repo-results (make-hash))
      (define archive-url (first archive-urls))
      ; (displayln archive-url)
      (define archive-path (download-repo-archive archive-url))
      (define repo-name (string-replace archive-url "https://api.github.com/repos/" ""))
      (set! repo-name (string-replace repo-name "/zipball" ""))
      ; (displayln repo-name)
      (hash-set! repo-results "repo_name" repo-name)
      (recurse-through-files archive-path)
      ; (displayln scan-results)
      (hash-set! repo-results "repo_results" scan-results)
      (set! github-results (append github-results (list repo-results)))
      (delete-archive archive-path)
      (loop (rest archive-urls))))
  ; TODO: --debug - https://github.com/bogu-io/bogu/issues/22
  (cond [(verbose) (displayln github-results)]))
