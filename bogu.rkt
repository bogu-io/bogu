#lang racket

;; bogu.rkt - main file

;; —————————————————————————————————
;; import and implementation section

(require
  "local.rkt"
  "github.rkt"
  "parser.rkt"
  "strings.rkt"
  "utils.rkt")

(define (main args)
  (displayln (string-append "Bogu " version-slug))
  (cond [(= (vector-length args) 0) (displayln help-text)])
  (cond [(> (string-length (local-path)) 0) (local-scan (local-path))])
  (cond [(> (string-length (github-owner)) 0) (github-scan (github-owner))])
  (cond [(symlink) (symbolic-link)])
  (cond [(version) (displayln version-slug)])
  (values))

(main (current-command-line-arguments))
