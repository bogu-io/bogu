#lang racket

;; github.rkt - GitHub API utility functions

;; Ask and I shall provide
(provide
  (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

(require json
         net/http-client 
         net/url
         net/head)

(define (get-all-repos user)
  (define host "api.github.com")
  (define uri (string-append "/users/" user "/repos"))
  (define repos '())
  (let loop ((url url))
    (define-values (status response-body input-port)
      (http-sendrecv host
                     uri
                     #:ssl? #t
                     #:method #"GET"
                     #:headers '()))
    (define body (port->string input-port))
    (display body)
    (set! repos (append repos (read-json input-port)))
    (close-input-port input-port)))
    ;;(define next (get-paginated-url headers))
    ;;(when next (loop next))) repos)

(define (get-paginated-url headers)
  (define link-header (assoc headers "link"))
  (and link-header
       (regexp-match ".*<\\(.*?\\)>; rel=\"next\"" link-header)))

(define (get-repo-archive-url repo)
  (string-append "https://api.github.com/repos/" repo "/zipball"))

(define (download-repo-archive repo)
  (define out-file (string-append (car (string-split repo #\/)) ".zip"))
  (call-with-output-file out-file
                         (lambda (out)
                           (define in (get-pure-port (get-repo-archive-url repo)))
                           (copy-port in out)
                           (close-input-port in))
                         'binary)
  out-file)

