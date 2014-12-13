(define (load-wara-auto-close)
  (define (get-back-char)
    (editor-get-row-col-char
      (editor-get-cur-row)
      (- (editor-get-cur-col) 1)))

  (define (get-next-char)
    (editor-get-row-col-char
      (editor-get-cur-row)
      (editor-get-cur-col)))

  (define (get-back-and-next-char)
    (string (get-back-char)
            (get-next-char)))

  (define (delete-back-and-next-char)
    (editor-forward-char 1 #f)
    (editor-backward-char 2 #t)
    (editor-delete-selected-string))

  (define (area-selected?)
    (list? (editor-get-selected-area)))

  (define (back-space)
    (cond
      ((area-selected?)
       (editor-delete-selected-string))
      (else
        (editor-backward-char 1 #t)
        (editor-delete-selected-string))))

  (define (back-char? ch)
    (let ((back-ch (get-back-char)))
      (and (not (eof-object? back-ch))
           (char=? ch back-ch))))

  (define (next-char? ch)
    (let ((next-ch (get-next-char)))
      (and (not (eof-object? next-ch))
           (char=? ch next-ch))))

  (define (any-is-true? proc ls)
    (eval (cons 'or (map proc ls))))

  (define surround-ls '("()" "[]" "{}" "\"\"" "''"))

  (define (surrounded?)
    (and (not (eof-object? (get-next-char)))
         (any-is-true?
           (lambda (e)
             (string=? e (get-back-and-next-char)))
           surround-ls)))

  (define (special-back-space)
    (cond
      ((area-selected?)
       (back-space))
      ((surrounded?)
       (delete-back-and-next-char))
      (else
        (back-space))))

  (app-set-key
    "BACK"
    special-back-space)

  (define (car-string str)
    (car (string->list str)))

  (define (cadr-string str)
    (cadr (string->list str)))

  (define (over-write-input-key surround key-l key-r)
    (app-set-key
      key-l
      (lambda ()
        (editor-paste-string surround)
        (editor-backward-char 1 #f)))
    (app-set-key
      key-r
      (lambda ()
        (if (next-char? (cadr-string surround))
          (editor-forward-char 1 #f)
          (editor-paste-string (string (cadr-string surround)))))))

  (over-write-input-key "()" "Shift+8" "Shift+9")
  (over-write-input-key "[]" "[" "]")
  (over-write-input-key "{}" "Shift+[" "Shift+]")

  (define (over-write-input-key-same surround key)
    (app-set-key
      key
      (lambda ()
        (cond
          ((next-char? surround)
           (editor-forward-char 1 #f))
          (else
            (editor-paste-string (string surround surround))
            (editor-backward-char 1 #f))))))

  (over-write-input-key-same #\" "Shift+2")
  (over-write-input-key-same #\' "Shift+7")

  (define (expandable-bracket?)
    (or (next-char? #\}) (next-char? #\]) (next-char? #\))))

  (define (bracket?)
    (or (back-char? #\{) (back-char? #\[) (back-char? #\()))

  (define (get-current-indent)
    (let ((indent (rxmatch-substring
                    (rxmatch #/^\t+/
                             (editor-get-row-string (editor-get-cur-row))))))
      (if (boolean? indent)
        0
        (string-length indent))))

  (app-set-key
    "ENTER"
    (lambda ()
      (let ((current-indent (get-current-indent)))
        (cond
          ((expandable-bracket?)
           (editor-paste-string "\n\n")
           (editor-paste-string (make-string current-indent #\tab))
           (editor-previous-line 1 #f)
           (editor-paste-string (make-string (+ 1 current-indent) #\tab)))
          ((bracket?)
           (editor-paste-string "\n")
           (editor-paste-string (make-string (+ 1 current-indent) #\tab)))
          (else
            (editor-paste-string "\n")
            (editor-paste-string (make-string current-indent #\tab))))))))

(load-wara-auto-close)
