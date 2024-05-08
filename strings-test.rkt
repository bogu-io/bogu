#lang racket

;; strings-test.rkt - Tests for strings.rkt

;; Ask and I shall provide
(provide
  (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

(require 
  "strings.rkt"
  rackunit)

;; Test for `version-slug`
(check-equal? version-slug "v0.0.16")

;; Test for `scan-start-text`
(check-equal? (scan-start-text "test") "\nStarting test scan...\n")

;; Test for `wtf-text`
(check-equal? wtf-text "Not sure what to do with arguments provided.\n\nUse -h|--help for more details.")