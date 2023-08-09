;; Import necessary libraries
(use srfi-1)   ; For `do-alist` and `alist->hash-table`
(use posix)    ; For `line->string` and `file-exists?`

;; Define a function to read the contents of a file into a list of lines
(define (read-passwd-file file-path)
  (let ((lines '()))
    (with-input-from-file file-path
      (lambda (port)
        (let loop ((line (read-line port)))
          (if line
              (begin
                (set! lines (cons line lines))
                (loop (read-line port)))
              (reverse lines)))))))

;; Define a function to parse a line and extract the shell field
(define (parse-passwd-line line)
  (let ((fields (string-split line #\:)))
    (cadr (reverse fields))))

;; Define a function to count occurrences of elements in a list
(define (count-elements lst)
  (let ((count-table (make-hash-table)))
    (for-each (lambda (element)
                (let ((current-count (hash-table-ref count-table element 0)))
                  (hash-table-set! count-table element (+ current-count 1))))
              lst)
    count-table))

;; Define a function to print login shells and their counts
(define (print-login-shells login-shells)
  (do-alist login-shells
    (lambda (shell count)
      (display (format "Shell: ~a, Count: ~a\n" shell count)))))

;; Define the main function
(define (main args)
  (let* ((passwd-file-path "passwd")
         (passwd-lines (read-passwd-file passwd-file-path))
         (login-shells (count-elements (map parse-passwd-line passwd-lines))))
    (print-login-shells login-shells)))

;; Run the main function when this script is executed
(main (command-line-arguments))
