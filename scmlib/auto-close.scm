(define (get-back-char)
  (editor-get-row-col-char
    (editor-get-cur-row)
    (- (editor-get-cur-col) 1)))
    
(define (get-next-char)
  (editor-get-row-col-char
    (editor-get-cur-row)
    (editor-get-cur-col)))

(define (delete-back-and-next-char)
  (editor-forward-char 1 #f)
  (editor-backward-char 2 #t)
  (editor-delete-selected-string))

(define (back-space)
  (if (editor-get-selected-area)
      (editor-delete-selected-string)
      (begin
        (editor-backward-char 1 #t)
        (editor-delete-selected-string))))

(define (next-char? ch)
  (let ((next-ch (get-next-char)))
    (and (not (eof-object? next-ch))
         (char=? ch next-ch))))

(define (any? proc ls)
  (eval (cons 'or (map proc ls))))

(define (surrounded? ls)
  (and (not (eof-object? (get-next-char)))
       (any?
         (lambda (e) (string=? e (string (get-back-char)
                                         (get-next-char))))
         ls)))

(define surround-ls '("()" "[]" "{}" "\"\"" "''"))

(define (original-back-space)
  (if (surrounded? surround-ls)
    (delete-back-and-next-char)
    (back-space)))

(app-set-key "BACK" original-back-space)

;()
(app-set-key "Shift+8"
  (lambda ()
    (editor-paste-string "()")
    (editor-backward-char 1 #f)))
(app-set-key "Shift+9"
  (lambda ()
    (if (next-char? #\))
      (editor-forward-char 1 #f)
      (editor-paste-string ")"))))

;[]
(app-set-key "["
  (lambda ()
    (editor-paste-string "[]")
    (editor-backward-char 1 #f)))
(app-set-key "]"
  (lambda ()
    (if (next-char? #\])
      (editor-forward-char 1 #f)
      (editor-paste-string "]"))))

;{}
(app-set-key "Shift+["
  (lambda ()
    (editor-paste-string "{}")
    (editor-backward-char 1 #f)))
(app-set-key "Shift+]"
  (lambda ()
    (if (next-char? #\})
      (editor-forward-char 1 #f)
      (editor-paste-string "}"))))

;""
(app-set-key "Shift+2"
  (lambda ()
    (if (next-char? #\")
      (editor-forward-char 1 #f)
      (begin
        (editor-paste-string "\"\"")
        (editor-backward-char 1 #f)))))

;''
(app-set-key "Shift+7"
  (lambda ()
    (if (next-char? #\')
      (editor-forward-char 1 #f)
      (begin
        (editor-paste-string "''")
        (editor-backward-char 1 #f)))))

(define (expandable-bracket?)
  (and (next-char? #\})
       (= (string-length (editor-get-row-string (editor-get-cur-row))))
          (+ 1 (editor-get-cur-col))))

(define (get-current-indent)
  (let ((indent (rxmatch-substring
                  (rxmatch
                  #/^\t+/
                  (editor-get-row-string (editor-get-cur-row))))))
    (if indent
      (string-length indent)
      0)))

(app-set-key "ENTER"
  (lambda ()
    (let ((current-indent (get-current-indent)))
      (cond
	((expandable-bracket?)
	 (editor-paste-string "\n\n")
	 (editor-paste-string (make-string current-indent #\tab))
	 (editor-previous-line 1 #f)
	 (editor-paste-string (make-string (+ current-indent 1) #\tab)))
	(else
	 (editor-paste-string "\n")
	 (editor-paste-string (make-string current-indent #\tab)))))))
