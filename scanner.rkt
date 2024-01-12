#lang racket

;; scanner.rkt - Secret scanner.

;; Ask and I shall provide
(provide
  (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

(require
  "parser.rkt"
  "rules.rkt")

; Results
(define scan-results (make-hash))

; Empties a mutable hash
(define (empty-hash the-hash)
  (for ([key (hash-keys the-hash)])
    (hash-remove! the-hash key)))

(define (find-secrets path)
  (define matched-secrets (make-hash))
  (with-input-from-file path
    (lambda ()
        (for ([line (in-lines)])
          (define aws-id-match (regexp-match aws-id line))
          (define aws-secret-match (regexp-match aws-secret line))
          (define aws-session-id-match (regexp-match aws-session-id line))
          (define aws-session-token-match (regexp-match aws-session-token line))
          (define gcp-api-key-match (regexp-match gcp-api-key line))
          (cond [aws-id-match
                (cond [(not (silent)) (printf "Found AWS Access ID: ~a\n" (car aws-id-match))])
                (hash-set! matched-secrets "aws_id" (car aws-id-match))])
          (cond [aws-secret-match
                (cond [(not (silent)) (printf "Found AWS Access Secret: ~a\n" (car aws-secret-match))])
                (hash-set! matched-secrets "aws_secret" (car aws-secret-match))])
          (cond [aws-session-id-match
                (cond [(not (silent)) (printf "Found AWS Session ID: ~a\n" (car aws-session-id-match))])
                (hash-set! matched-secrets "aws_session_id" (car aws-session-id-match))])
          (cond [aws-session-token-match
                (cond [(not (silent)) (printf "Found AWS Session Token: ~a\n" (car aws-session-token-match))])
                (hash-set! matched-secrets "aws_session_token" (car aws-session-token-match))])
          (cond [gcp-api-key-match
                (cond [(not (silent)) (printf "Found GCP API Key: ~a\n" (car gcp-api-key-match))])
                (hash-set! matched-secrets "gcp_api_key" (car gcp-api-key-match))]))) #:mode 'text)
    (cond [(not (silent)) (displayln "")])
    (values matched-secrets))
