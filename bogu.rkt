
#lang racket

; Parameters
(define local-path (make-parameter ""))
(define verbose (make-parameter #f))
(define version (make-parameter #f))

; Strings
(define version-slug "v0.0.2")
(define help-text (format "Bogu - ~a
The Secret Scanner

Use -h|--help for more details." version-slug))
(define (scan-start-text scan-type)
  (format "Starting ~a scan..." scan-type))
(define wtf-text "Not sure what to do with arguments provided.\n\nUse -h|--help for more details.")

; Filenames to ignore
(define bogu-ignore '(".git"))

; Results
(define scan-results (make-hash))

; Policies
(define aws-id            #px"(AKIA|ABIA|ACCA)[0-9A-Z]{16}")
(define aws-secret        #px"[A-Za-z0-9+/]{40}[^A-Za-z0-9+/]{0,1}")
(define aws-session-id    #px"ASIA[0-9A-Z]{16}")
(define aws-session-token #px"[A-Za-z0-9+=/]{41,1000}[^A-Za-z0-9+=/]{0,1}")

; Command line parser
(define parser
  (command-line
    #:usage-help
    "Bogu - The Secret Scanner"
    #:once-each
    [("-p" "--path") PATH "Local scan path" (local-path PATH)]
    [("-v" "--verbose") "Verbose" (verbose #t)]
    #:once-any
    [("--version") "Version" (version #t)]))

(define (find-secrets path)
  (define matched-secrets (make-hash))
  (with-input-from-file path
    (lambda ()
        (for ([line (in-lines)])
          (define aws-id-match (regexp-match aws-id line))
          (define aws-secret-match (regexp-match aws-secret line))
          (define aws-session-id-match (regexp-match aws-session-id line))
          (define aws-session-token-match (regexp-match aws-session-token line))
          (cond [aws-id-match
                (printf "Found AWS Access ID: ~a\n" (car aws-id-match))
                (hash-set! matched-secrets "aws_id" (car aws-id-match))])
          (cond [aws-secret-match
                (printf "Found AWS Access Secret: ~a\n" (car aws-secret-match))
                (hash-set! matched-secrets "aws_secret" (car aws-secret-match))])
          (cond [aws-session-id-match
                (printf "Found AWS Session ID: ~a\n" (car aws-session-id-match))
                (hash-set! matched-secrets "aws_session_id" (car aws-session-id-match))])
          (cond [aws-session-token-match
                (printf "Found AWS Session Token: ~a\n" (car aws-session-token-match))
                (hash-set! matched-secrets "aws_session_token" (car aws-session-token-match))]))) #:mode 'text)
    (values matched-secrets))

; Filesystem path walker
(define (recurse-through-files path)
  (define path-objects (directory-list path #:build? #t))
  (cond [(verbose) (printf "~a\n" path-objects)])
  (for ([path-object path-objects])
    (define path-object-string (path->string path-object))
    (define basename (path->string (file-name-from-path path-object-string)))
    (cond 
      [(member basename bogu-ignore)
       (printf "~a is in internal bogu-ignore.\n" path-object-string)]
      [else
        (cond
          [(directory-exists? path-object)
           (printf "Entering directory: ~a\n" path-object)
           (recurse-through-files path-object-string)]
          [(file-exists? path-object)
           (printf "File: ~a\n" path-object-string)
           (hash-set! scan-results path-object-string (find-secrets path-object-string))]
          [else
           (printf "Other: ~a\n" path-object-string)
           (hash-set! scan-results path-object-string (find-secrets path-object-string))])])))

; Local scan handler
(define (local-scan path)
  (displayln (scan-start-text "local path"))
  (cond [(verbose) (displayln path)])
  (recurse-through-files path)
  (cond [(verbose) (displayln scan-results)]))

(define (main args)
  (displayln (string-append "Bogu " version-slug))
  (cond
    [(= (vector-length args) 0) (displayln help-text)]
    [(> (string-length (local-path)) 0) (local-scan (local-path))]
    [(version) (displayln version-slug)]
    [else (displayln wtf-text)]))

(main (current-command-line-arguments))