#lang racket

;; github.rkt - GitHub User handler.

;; Ask and I shall provide
(provide
  (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

(require
	"parser.rkt"
  "github-api.rkt"
  "strings.rkt"
	"walk.rkt"
  "format.rkt")

(define github-results '())

; GitHub Repo scan handler
(define (github-scan user)
  (displayln (scan-start-text "GitHub User"))
  (cond [(verbose) (displayln user)])
  (define-values (repos) (get-all-repos user))
  (cond [(debug) (displayln repos)])
  (let loop ([archive-urls repos])
    (when (not (null? archive-urls))
      (define repo-results (make-hasheq))
      (define archive-url (first archive-urls))
      (define archive-path (download-repo-archive archive-url))
      (define repo-name (string-replace archive-url "https://api.github.com/repos/" ""))
      (set! repo-name (string-replace repo-name "/zipball" ""))
      (hash-set! repo-results 'repo_name repo-name)
      (recurse-through-files archive-path)
      (cond [(debug) (displayln "[local-scan-results]")])
      (cond [(debug) (displayln local-scan-results)])
      (cond
        [(not (empty? local-scan-results))
         (hash-set! repo-results 'repo_results local-scan-results)])
      (set! github-results (append github-results (list repo-results)))
      (delete-archive archive-path)
      (reset-scan)
      (loop (rest archive-urls))))
  (cond [(debug) (displayln "[github-results]")])
  (cond [(debug) (displayln github-results)])
  (cond [(equal? (output-format) "hash-list")
         (displayln github-results)]
        [(equal? (output-format) "json")
         (printf "~a\n" (format-json github-results))]))

