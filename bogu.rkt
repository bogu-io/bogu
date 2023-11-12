#lang racket

(define version-slug "v0.0.1")
(define local-path (make-parameter ""))
(define version (make-parameter #f))
(define naked-text (format "Bogu - ~a
The Secret Scanner

Use -h|--help for more details." version-slug))
(define wtf-text "Not sure what to do with arguments provided.\n\nUse -h|--help for more details.")

(define parser
  (command-line
    #:usage-help
    "Bogu - The Secret Scanner"
    #:once-each
    [("-p" "--path") PATH "Local scan path" (local-path PATH)]
    #:once-any
    [("-v" "--version") "Version" (version #t)]))

(define (main args)
  (cond
    [(= (vector-length args) 0) (displayln naked-text)]
    [(version) (displayln version-slug)]
    [else (displayln wtf-text)]))

(main (current-command-line-arguments))