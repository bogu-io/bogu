#lang racket

;; utils.rkt - Utility functions.

;; Ask and I shall provide
(provide
  (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

(define (create-bogu-files)
  (define path (build-path (find-system-path 'home-dir) ".bogu" "boguignore"))
  (unless (file-exists? path)
    (make-directory* (path-only path))
    (call-with-output-file path void)))

(define (expand-home-path path)
  (if (string-prefix? path "~")
      (string-replace path "~" (path->string (find-system-path 'home-dir)))
      path))

;; Check if we have gcp service credentials file
(define (gcp-service-credentials-file? file-path)
  (define file-contents (call-with-input-file file-path port->string))
  (cond
    [(and
      (string-contains? file-contents "type")
      (string-contains? file-contents "project_id")
      (string-contains? file-contents "private_key_id")
      (string-contains? file-contents "private_key")
      (string-contains? file-contents "client_email")
      (string-contains? file-contents "client_id")
      (string-contains? file-contents "auth_uri")
      (string-contains? file-contents "token_uri")
      (string-contains? file-contents "auth_provider_x509_cert_url")
      (string-contains? file-contents "client_x509_cert_url")
      (string-contains? file-contents "universe_domain")) #t]
    [else #f]))

;; Check if we have gcp oauth file
(define (gcp-oauth-file? file-path)
  (define file-contents (call-with-input-file file-path port->string))
  (cond
    [(and 
      (string-contains? file-contents "project_id")
      (string-contains? file-contents "auth_uri")
      (string-contains? file-contents "token_uri")
      (string-contains? file-contents "auth_provider_x509_cert_url")
      (string-contains? file-contents "client_secret")
      (string-contains? file-contents "client_id")) #t]
    [else #f]))

(define (get-bogu-dir-path)
  (build-path (find-system-path 'home-dir) ".bogu"))

;; Checks Shannon entropy of a string
(define (shannon str)
  (define len (string-length str))
  (define freq (make-hash))
  (for ([i (in-range len)])
    (hash-update! freq (string-ref str i) add1 0))
  (define entropy 0.0)
  (for ([count (in-hash-values freq)])
    (define p (/ count len))
    (define term (* p (log p 2)))
    (set! entropy (+ entropy term)))
  (set! entropy (- 0 entropy))
  entropy)

(define (symbolic-link)
  (cond [(file-exists? "/usr/local/bin/bogu")
         (delete-file "/usr/local/bin/bogu")])
  (define pwd (path->string (current-directory)))
  (define destination "/usr/local/bin/bogu")
  (make-file-or-directory-link (string-append pwd "bogu") destination)
  (displayln "Symbolic link created in /usr/local/bin"))
