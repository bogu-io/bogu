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
    (define-values (status response-headers input-port)
      (http-sendrecv host
                     uri
                     #:ssl? #t
                     #:method #"GET"
                     #:headers '()))
    (define headers response-headers)
    (define header-pairs (map parse-header headers))
    (set! repos (append repos (read-json input-port)))
    (close-input-port input-port)
    (define next (get-paginated-url header-pairs))
    (when next (loop next)))
  repos)

(define (parse-header header-bytes)
  (let* ((header (bytes->string/utf-8 header-bytes))
         (parts (string-split header ": ")))
    (cons (first parts) (string-join (rest parts) ": "))))

(define (get-paginated-url headers)
  (define link-header (assoc "link" headers))
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

