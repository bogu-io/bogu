#lang racket

;; walk.rkt - File system walker.

;; Ask and I shall provide
(provide
  (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

(require
  "parser.rkt"
  "scanner.rkt"
  "utils.rkt")

; Holds the results of the scan
(define local-scan-results '())

; Filesystem path walker
(define (recurse-through-files path)
  (define path-objects (directory-list path #:build? #t))
  ; (cond [(debug) (printf "[path-objects]\n~a\n" path-objects)])
  (for ([path-object path-objects])
    (define path-object-string (path->string path-object))
    (cond
      [(directory-exists? path-object)
        (cond [(not (silent)) (printf "Entering directory: ~a\n" path-object)])
        (recurse-through-files path-object)]
      [(file-exists? path-object)
        (define found-secrets '())
        (define secrets-found (make-hasheq))
        (cond [(not (silent)) (printf "File: ~a\n" path-object-string)])
        (cond [(gcp-service-credentials-file? path-object-string)
               (begin
                 (cond [(not (silent)) (printf "Found GCP service credentials file: ~a\n" path-object-string)])
                 (hash-set! secrets-found 'path path-object-string)
                 (hash-set! secrets-found 'results (list (hasheq 'gcp_service_credentials_file path-object-string)))
                 (hash-set! secrets-found 'count (length (hash-ref secrets-found 'results))))]
              [(gcp-oauth-file? path-object-string)
               (begin
                 (cond [(not (silent)) (printf "Found GCP OAuth file: ~a\n" path-object-string)])
                 (hash-set! secrets-found 'path path-object-string)
                 (hash-set! secrets-found 'results (list (hasheq 'gcp_oauth_file path-object-string)))
                 (hash-set! secrets-found 'count (length (hash-ref secrets-found 'results))))]
              [else
                (begin
                  (set! found-secrets (find-secrets path-object-string))
                  (hash-set! secrets-found 'path path-object-string)
                  (hash-set! secrets-found 'results found-secrets)
                  (hash-set! secrets-found 'count (length (hash-ref secrets-found 'results))))])
        (cond
          [(not (empty? (hash-ref secrets-found 'results)))
           (set! local-scan-results (append local-scan-results (list secrets-found)))])]
      [else
        (cond [(not (silent)) (printf "Other: ~a\n" path-object-string)])
        (define found-secrets (find-secrets path-object-string))
        (define secrets-found (make-hasheq))
        (hash-set! secrets-found 'path path-object-string)
        (hash-set! secrets-found 'results found-secrets)
        (hash-set! secrets-found 'count (length (hash-ref secrets-found 'results)))
        (cond
          [(not (empty? found-secrets))
           (set! local-scan-results (append local-scan-results (list secrets-found)))])])))

(define reset-scan (lambda () (set! local-scan-results '())))
