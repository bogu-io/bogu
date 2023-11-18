
#lang racket

;; bogu.rkt - main file

;; —————————————————————————————————
;; import and implementation section

(require
  "local.rkt"
  "parser.rkt"
  "strings.rkt")

(define (main args)
  (displayln (string-append "Bogu " version-slug))
  (cond
    [(= (vector-length args) 0) (displayln help-text)]
    [(> (string-length (local-path)) 0) (local-scan (local-path))]
    [(version) (displayln version-slug)]
    [else (displayln wtf-text)]))

(main (current-command-line-arguments))