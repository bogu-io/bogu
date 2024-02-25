#lang racket

;; scanner.rkt - Secret scanner.

;; Ask and I shall provide
(provide
  (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

(require
  "parser.rkt"
  "rules.rkt"
  "utils.rkt")

; Empties a mutable hash
(define (empty-hash the-hash)
  (for ([key (hash-keys the-hash)])
    (hash-remove! the-hash key)))

(define (find-secrets path)
  (define matched-secrets '())
  (with-input-from-file path
    (lambda ()
        (for ([line (in-lines)])
          (define matched-secret (make-hasheq))
          (define aws-id-match (regexp-match aws-id line))
          (define aws-secret-match (regexp-match aws-secret line))
          (define aws-session-id-match (regexp-match aws-session-id line))
          (define aws-session-token-match (regexp-match aws-session-token line))
          (define gcp-api-key-match (regexp-match gcp-api-key line))
          (cond [aws-id-match
                (cond [(not (silent)) (printf "Found AWS Access ID: ~a\n" (car aws-id-match))])
                (define shannon-score (shannon (car aws-id-match)))
                (cond [(debug) (printf "Entropy score: ~a\n" shannon-score)])
                (hash-set! matched-secret 'aws_id (car aws-id-match))
                (set! matched-secrets (append matched-secrets (list matched-secret)))])
          (cond [aws-secret-match
                (define shannon-score (shannon (car aws-secret-match)))
                (cond [(and (> shannon-score 4.5) (< shannon-score 5.9)) (begin
                  (cond [(not (silent)) (printf "Found AWS Access Secret: ~a\n" (car aws-secret-match))])
                  (cond [(debug) (printf "Entropy score: ~a\n" shannon-score)])
                  (hash-set! matched-secret 'aws_secret (car aws-secret-match))
                  (set! matched-secrets (append matched-secrets (list matched-secret))))])])
          (cond [aws-session-id-match
                (cond [(not (silent)) (printf "Found AWS Session ID: ~a\n" (car aws-session-id-match))])
                (define shannon-score (shannon (car aws-session-id-match)))
                (cond [(debug) (printf "Entropy score: ~a\n" shannon-score)])
                (hash-set! matched-secret 'aws_session_id (car aws-session-id-match))
                (set! matched-secrets (append matched-secrets (list matched-secret)))])
          (cond [aws-session-token-match
                (define shannon-score (shannon (car aws-session-token-match)))
                (cond [(and (> shannon-score 4.6) (< shannon-score 5.9)) (begin
                  (cond [(not (silent)) (printf "Found AWS Session Token: ~a\n" (car aws-session-token-match))])
                  (cond [(debug) (printf "Entropy score: ~a\n" shannon-score)])
                  (hash-set! matched-secret 'aws_session_token (car aws-session-token-match))
                  (set! matched-secrets (append matched-secrets (list matched-secret))))])])
          (cond [gcp-api-key-match
                (define shannon-score (shannon (car gcp-api-key-match)))
                (cond [(and (> shannon-score 4) (< shannon-score 5.9)) (begin
                  (cond [(not (silent)) (printf "Found GCP API Key: ~a\n" (car gcp-api-key-match))])
                  (cond [(debug) (printf "Entropy score: ~a\n" shannon-score)])
                  (hash-set! matched-secret 'gcp_api_key (car gcp-api-key-match))
                  (set! matched-secrets (append matched-secrets (list matched-secret))))])]))) #:mode 'text) 
    (cond [(not (silent)) (displayln "")])
    matched-secrets)
