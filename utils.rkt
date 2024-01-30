#lang racket

;; utils.rkt - Utility functions.

;; Ask and I shall provide
(provide
  (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

;; Check if we have gcp service credentials file
(define (gcp-service-credentials-file? file-path)
  (define file-contents (call-with-input-file file-path port->string))
  (cond
    [(and 
      (string-contains? file-contents "\"type\": \"service_account\"")
      (string-contains? file-contents "project_id")
      (string-contains? file-contents "private_key_id")
      (string-contains? file-contents "private_key")
      (string-contains? file-contents "client_email")
      (string-contains? file-contents "client_id")) #t]
    [else #f]))
