#lang racket

;; strings.rkt - Strings used throughout bogu

;; Ask and I shall provide
(provide
  (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

(define version-slug "v0.0.15")

(define help-text (format "Bogu - ~a
The Secret Scanner

Use -h|--help for more details." version-slug))

(define (scan-start-text scan-type)
  (format "\nStarting ~a scan...\n" scan-type))

(define wtf-text "Not sure what to do with arguments provided.\n\nUse -h|--help for more details.")
