;;; append.lsp

; member is among standards
; (is this supposed to work as a 'member' ?
(defun myappend (x  y)
  (if (null x)
    y
    (cons  (car  x) (myappend (cdr  x)  y))
  )
)

;;; co.lsp

(defun co1 (list)
  (if (null list)
    ( )
    (cons (car list) (co2 (cdr list)))
  )
)

(defun co2 (list)
  (if (null list)
    ( )
    (co1 (cdr list))
  )
)

;;; co-vraci.lsp

(defun co-vraci (z)
  (list (first z) (posledni-prvek))
)

(defun posledni-prvek ( )
  (first (last z))
)

(setq z '(1  2  3  4))
(co-vraci '(a  b  c  d))

;;; cyklus-do.lsp

(defun foo ()
  (do (( x  1 (+  x  1)) (y 10 (*  y  0.5)))
    ((>  x  4)  y)
    (print  y)
    (print 'pocitam)
  )
)

;;; fakt.lsp

(defun fakt (x)
  (cond
        ((= x 0) 1)
        (T      (* x (fakt (- x 1))))
  )
)

;;; fibonacci.lsp

(defun fibon (N)
  (cond
       ((equal N 0) 0)
       ((equal N 1) 1)
       (T           (foo (- N 1)))
  )
)

(defun foo (N)
  (setq F1 1)
  (setq F2 0)
  (loop
    (setq F (+ F1 F2))
    (setq F2 F1)
    (setq F1 F)
    (setq N (- N 1))
    (when (equal N 0) (return F))
  )
)

;;; hanoi.lsp

(defun hanoi (n from to aux)
  (cond
        ((= n 1) (move from to))
        (t       (hanoi (- n 1) from aux to)
                 (move from to)
                 (hanoi (- n 1) aux to from)
         )
  )
)

(defun move (from to)
  (format t  "~%move the disc from ~a to ~a." from to)
)

;;; kvadr.lsp

(defun zadej ()
	(write-line "Vypocet korenu kvadraticke rovnice tvaru:")
	(write-line "         Ax^2 + Bx + C = 0")
	(write-line "=========================================")
	(write-string "Zadej koeficient A: ") (setq a (read))
	(write-string "Zadej koeficient B: ") (setq b (read))
	(write-string "Zadej koeficient C: ") (setq c (read))
)

(defun diskriminant (x y z)
	(- (* y y) (* 4 x z))
)

(defun vypocet ()
	(setq d (diskriminant a b c))
	(cond (	(< d 0)
		(write-line "Rovnice nema reseni !!!")
	      )
	      (	(= d 0)
		(write-line "Rovnice ma jedno reseni.")
		(write-string "X = ")
		(write (/ (- b) (* 2 a)))
	      )
              (	(> d 0)
		(write-line "Rovnice ma dve reseni.")
		(write-string "X1 = ")
		(write (/ (+ (- b) (sqrt d)) (* 2 a)))
		(write-char #\Newline)
		(write-string "X2 = ")
		(write (/ (- (- b) (sqrt d)) (* 2 a)))
	      )
	)
)

(defun main ()
	(zadej)
	(vypocet)
)

;;; maximum.lsp

(defun max2 (x y)
  (if (> x y)
    x
    y
  )
)


(defun max4 (u v x y)
  (max2 (max2 u v) (max2 x y))
)

(defun maxn (n)
  (if (equal (delka n) 2)
    (max2 (car n) (car (cdr n)))
    (max2 (car n) (maxn (cdr n)))
  )
)

(defun delka (n)
  (if (equal n nil)
    0
   (+ 1 (delka (cdr n)))
  )
)

;;; member.lsp

(defun mymember (x  s)  ; member je jiz take mezi standardnimi
  (cond
        ((null s)            nil)
        ((equal x (car  s))  t)        ; s
        (t                   (mymember x (cdr  s)))
  )
)

;;; nsd.lsp

(defun nsd (x y)
  (cond
        ((zerop (- x y)) y)
        ((> y x)         (nsd x (- y x)))
        (t               (nsd y (- x y)))
  )
)

;;; n-ty.lsp

(setq v "vysledek je ")

(defun nta (S x)
  (do ((i 1 (+ i 1)))
    ((= i x) (princ v) (car S)) ; test konce a vysledna forma
    (setq S (cdr S))
  )
)

(defun delej ()
  (nta (read) (read))
)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun nty (S x)
  (cond
        ((= x 1) (car S))
        (t       (nty (cdr S) (- x 1)))
  )
)

;;; prumer.lsp

(defun sum (x)
  (cond
        ((null x) 0)
        ((atom x) x)
        (t        (+ (car x) (sum (cdr x))))
  )
)

(defun mycount (x) ;;; count je take mezi standardnimi
  (cond
        ((null x) 0)
        ((atom x) 1)
        (t        (+ 1 (mycount (cdr x))))
  )
)

(defun avrg () ;;;main program
  (print "napis seznam cisel")
  (setq x (read))
  (setq avg (/ (sum x) (mycount x)))
  (princ "prumer je ")
  (print avg)
)

;;; rekurze.lsp

; odstrani vyskyty prvku e v nejvyssi urovni seznamu s
(defun mydelete (e s)
  (cond
       ((null s)          nil)
       ((equal e (car s)) (mydelete e (cdr s)))
       (t                 (cons (car s) (mydelete e (cdr s))))
  )
)

; zjisti maximalni hloubku vnoreni seznamu - max je stand. fce
(defun max-hloubka (s)
  (cond
       ((null s)       0)
       ((atom (car s)) (max 1 (max-hloubka (cdr s))))
       (t              (max (+ 1 (max-hloubka (car s))) (max-hloubka (cdr s))))  ; nasobna redukce
  )
)

; najde prvek s nejvetsi hodnotou ve vnorovanem seznamu
(defun max-prvek (s)
  (cond
       ((atom s)       s)
       ((null (cdr s)) (max-prvek (car s)))
       (t              (max (max-prvek (car s)) (max-prvek (cdr s))))
  )
)

;;; sude-poradi.lsp

; vybira ze seznamu prvky sude v poradi
(defun sude (x)
  (cond
        ((not (null (cdr x))) (cons (car (cdr x))(sude (cdr (cdr x)))))
        (t                    nil)
  )
)

