#lang racket

;; github.rkt - GitHub API utility functions

;; Ask and I shall provide
(provide
  (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

(require file/unzip
         json
         net/http-client 
         net/url
         uuid)

(define request-headers
  `(("Accept" . "application/vnd.github+json")
    ;("Authorization" . ,(string-append "Bearer " my-token))
    ("X-GitHub-Api-Version" . "2022-11-28")))

(define (get-all-repos user)
  (define host "api.github.com")
  (define uri (string-append "/users/" user "/repos"))
  (let loop ([url uri])
    (define-values (status response-headers input-port)
      (http-sendrecv host
                     uri
                     #:ssl? #t
                     #:method #"GET"
                     #:headers '()))
    (define headers response-headers)
    (define header-pairs (map parse-header headers))
    ; Repos are represented as a list of hashes.
    (define repo-hashes (read-json input-port))
    (get-repo-archive-urls repo-hashes)
    (close-input-port input-port)
    (define next (get-paginated-url header-pairs))
    (when next (loop next)))
  repo-archive-urls)

(define (parse-header header-bytes)
  (let* ((header (bytes->string/utf-8 header-bytes))
         (parts (string-split header ": ")))
    (cons (first parts) (string-join (rest parts) ": "))))

(define (get-paginated-url headers)
  (define link-header (assoc "link" headers))
  (and link-header
       (regexp-match ".*<\\(.*?\\)>; rel=\"next\"" link-header)))

; Empty this after a GitHub scan.
(define repo-archive-urls '())

(define (get-repo-archive-urls repos)
  (when (not (null? repos))
    (define archive-url (hash-ref (first repos) 'archive_url))
    (set! archive-url (string-replace archive-url "{archive_format}" "zipball"))
    (set! archive-url (string-replace archive-url "{/ref}" ""))
    (set! repo-archive-urls (append repo-archive-urls (list archive-url)))
    (get-repo-archive-urls (rest repos))))

(define (download-repo-archive archive-url)
  ; For downloading archives
  (define response (get-pure-port (string->url archive-url) request-headers #:follow-redirects? #t))
  ; Let's be fancy and name the zip and archive a uuid
  (define temp-zip-path (format "~a.zip" (uuid-string)))
  (define output-dir (format "~a" (uuid-string)))
  (call-with-output-file temp-zip-path
                         (lambda (out)
                           (copy-port response out)))
  (unzip temp-zip-path output-dir)
  (delete-file temp-zip-path))
