#lang racket

;; rules.rkt - All of the secret scanning rules.

;; Ask and I shall provide
(provide
  (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

(define aws-id            #px"(AKIA|ABIA|ACCA)[0-9A-Z]{16}")
(define aws-secret        #px"[A-Za-z0-9+/]{40}[^A-Za-z0-9+/]{0,1}")
(define aws-session-id    #px"ASIA[0-9A-Z]{16}")
(define aws-session-token #px"[A-Za-z0-9+=/]{41,1000}[^A-Za-z0-9+=/]{0,1}")
