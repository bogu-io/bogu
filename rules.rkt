#lang racket

;; rules.rkt - All of the secret scanning rules.

;; Ask and I shall provide
(provide
  (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

(define aws-id            #px"\\b(AKIA|ABIA|ACCA)[0-9A-Z]{16}\\b")
(define aws-secret        #px"\\b[A-Za-z0-9+/]{40}[^A-Za-z0-9+/]{0,1}\\b")
(define aws-session-id    #px"\\bASIA[0-9A-Z]{16}\\b")
(define aws-session-token #px"\\b[A-Za-z0-9+=/]{41,1000}[^A-Za-z0-9+=/]{0,1}\\b")
(define gcp-api-key       #px"\\bAIza[A-Za-z0-9_-]{35}\\b")
(define lumos-api-key     #px"\\blsk_(.{44})\\b")
