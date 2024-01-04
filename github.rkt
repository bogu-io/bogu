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
  (let loop ((url url))
    (define-values (status response-headers input-port)
      (http-sendrecv host
                     uri
                     #:ssl? #t
                     #:method #"GET"
                     #:headers '()))
    (define headers response-headers)
    (define header-pairs (map parse-header headers))
    (define repo-hashes (read-json input-port))                                                       ; Repos are represented as a list of hashes.
    (get-repo-archive-urls repo-hashes)
    (close-input-port input-port)
    (define next (get-paginated-url header-pairs))
    (when next (loop next))))

(define (parse-header header-bytes)
  (let* ((header (bytes->string/utf-8 header-bytes))
         (parts (string-split header ": ")))
    (cons (first parts) (string-join (rest parts) ": "))))

(define (get-paginated-url headers)
  (define link-header (assoc "link" headers))
  (and link-header
       (regexp-match ".*<\\(.*?\\)>; rel=\"next\"" link-header)))

(define repo-archive-urls '())                                                                        ; Empty this after a GitHub scan.

(define (get-repo-archive-urls repos)
  (when (not (null? repos))
    (define archive-url (hash-ref (first repos) 'archive_url))
    (set! repo-archive-urls (append repo-archive-urls (list archive-url)))
    (get-repo-archive-urls (rest repos))))

; (define (download-repo-archive repo)
;   (define out-file (string-append (car (string-split repo #\/)) ".zip"))
;   (call-with-output-file out-file
;                          (lambda (out)
;                            (define in (get-pure-port (get-repo-archive-url repo)))
;                            (copy-port in out)
;                            (close-input-port in))
;                          'binary)
;   out-file)

