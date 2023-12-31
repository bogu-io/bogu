#lang racket

;; github.rkt - GitHub API utility functions

;; Ask and I shall provide
(provide
  (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

(require json net/http-client)

(define (get-all-repos user)
  (define url (string-append "https://api.github.com/users" user "/repos"))
  (define repos '())
  (let loop ((url url))
    (define-values (response-header response-body)
      (http-sendrecv url
                     (current-seconds)
                     "GET"
                     '()    ; headers
                     'none    ; no body for GET
                     'identity    ; don't encode the body
                     'utf-8))    ; decode response as UTF-8
    (set! repos (append repos (json->list response-body)))
    (define next (get-paginated-url response-header))
    (if next (loop next) repos)))

(define (get-paginated-url headers)
  (define link-header (assoc-ref headers "link"))
  (and link-header
       (regexp-match ".*<\\(.*?\\)>; rel=\"next\"" link-header)))

(define (get-repo-archive-url repo)
  (string-append "https://api.github.com/repos/" repo "/zipball"))

(define (download-repo-archive repo)
  (define out-file (string-append (car (split-string repo #\/)) ".zip"))
  (call-with-output-file out-file
                         (lambda (out)
                           (define in (get-pure-port (get-repo-archive-url repo)))
                           (copy-port in out)
                           (close-input-port in))
                         'binary)
  out-file)

