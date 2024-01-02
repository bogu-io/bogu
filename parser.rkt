#lang racket

;; parser.rkt - Command line options parameters and parser.

;; Ask and I shall provide
(provide
  (all-defined-out))

;; —————————————————————————————————
;; import and implementation section

; Parameters
(define github-user (make-parameter ""))
(define local-path (make-parameter ""))
(define verbose (make-parameter #f))
(define version (make-parameter #f))

; Command line parser
(define parser
  (command-line
    #:usage-help
    "Bogu - The Secret Scanner"
    #:once-each
    [("-p" "--path") PATH "Local scan path" (local-path PATH)]
    [("--github-user") USER "GitHub Repo Scan by User" (github-user USER)]
    [("-v" "--verbose") "Verbose" (verbose #t)]
    #:once-any
    [("--version") "Version" (version #t)]))

