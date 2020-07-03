;;;; Projeto Knights Game
;;;; Disciplina de IA - 2019 / 2020
;;;; Professor: Joaquim Filipe & Eng. Filipe Mariano 
;;;; Autor: João Gomes & André Gastão


(defpackage :p150221001-130221037)

;;Hash table guarda o estado e o valor
;;Teste:(hash-table-count *my-hash*)
(defparameter *my-hash* (make-hash-table))

;;(maphash #'print-hash-entry *my-hash*)

(defun print-hash-entry (key value)
    (format t "The value associated with the key ~a is ~a~%" key value))



(defun memoizacao (fn)
 (let ((table *my-hash*))
    (lambda (no  jogador tempo-final prof)
      (or (gethash (no-estado-tabuleiro no) table)
          (let ((val (funcall fn no  jogador tempo-final prof)))
            (setf (gethash (no-estado-tabuleiro no) table) val)
            (maphash #'(lambda (k v) (format t "~a => ~a~%" k v)) table)
            val))))
 )





;Caso um dos jogadores não consiga movimentar o cavalo, cede a vez ao jogador oposto. 
;O jogo termina quando nenhum jogador consegue movimentar o cavalo.
(defun no-solucaop (no jogador)
"verifica se o tabuleiro está vazio verifica se não há mais movimento  "
(cond 
((= (numero-jogadas-disponiveis (sucessores no (operadores) jogador)) 0) T )
(t Nil)))





(defun avaliar(no jogador )
"Função de Avaliação = difrença de pontos entre jogadores"
  (- (no-pontos no jogador ) (no-pontos no (trocar-jogador jogador) ) ))




;;Teste:  (no-maxp *jogador1* *jogador1* )
(defun no-maxp (jogador jogador-max)
  "verifica se é o jogador max = "
	(= jogador jogador-max))





;______________________________________________________________________ Ordenação______________________________________________________






(defun ordenar-nos (lista jogador jogadorMax)
  "Ordena o no consoante o h(x) para ser usado na lista sucessores "
 "maximo (sort (copy-seq lista) #'< :key #'no-h)"
 "minimo (sort (copy-seq lista) #'> :key #'no-h)"
(cond
((no-maxp jogador jogadorMax) (sort (copy-seq lista ) #'< :key #'no-h ))
(t (sort (copy-seq lista) #'> :key #'no-h  ))))






(defun ordenar ( sucessores jogador jogadorMax )
"Devolve a lista de  ordenada a partir da funçao quicksort"
(cond
((no-maxp jogador jogadorMax)  (quicksort1 sucessores ))
(t  (quicksort2 sucessores ))))





(defun quicksort1 (no)
  "Algoritmo quicksort de ordenação no nó max  "
  (cond 
   ((null no) nil)
   (t (let*((x     (car no))
            (resto (cdr no))
            (f     (lambda (a) (< (no-h a) (no-h x)))))
        (append (quicksort1 (remove-if-not f resto))
                (list x)
                (quicksort1 (remove-if f resto)))))))

(defun quicksort2 (no)
  "Algoritmo quicksort de ordenação no nó min  "
  (cond 
   ((null no) nil)
   (t (let*((x     (car no))
            (resto (cdr no))
            (f     (lambda (a) (> (no-h a) (no-h x)))))
        (append (quicksort2 (remove-if-not f resto))
                (list x)
                (quicksort2 (remove-if f resto)))))))





;______________________________________________________________________ Algoritmos ______________________________________________________







;Teste: (alfabeta-v2 (no-teste) *jogador1* 1000 1000)
(defun alfabeta-v2 (No jogador tempLimite profLimite &optional (alfa most-negative-fixnum) (beta most-positive-fixnum) (tfinal( + (get-internal-real-time) tempLimite))(jogador-max jogador))
 "Alfabeta versão melhorada com stats"
	(cond 
           ((OR (no-solucaop no jogador) 
		(>= (no-profundidade no) profLimite)
		(>= (get-internal-real-time) tfinal)
                (null no))(avaliar no jogador ))
		(T (let ((sucessoes (ordenar (sucessores no (operadores) jogador) jogador jogador-max)))
					(if (no-maxp jogador jogador-max) ;Saber em que ramo é que está
						(progn 
                                                  (setf *expanded-nodes* (+ *expanded-nodes* (length sucessoes)))
                                                  (alfabeta-max  sucessoes  jogador tempLimite profLimite alfa beta tfinal jogador-max  ))
						(progn 
                                                   (setf *expanded-nodes* (+ *expanded-nodes* (length sucessoes)))
                                                   (alfabeta-min  sucessoes  jogador tempLimite profLimite alfa beta tfinal jogador-max )))))))


(defun alfabeta-max (sucessores jogador tempoLimite profLim alfa beta tFinal jogador-max )
  (cond 
   ((null sucessores) alfa )
   (t (let* 
          ( (jogador-oposto (trocar-jogador jogador))
            (no-a-expandir (car sucessores))
	    (valor (alfabeta-v2 no-a-expandir jogador-oposto tempoLimite profLim alfa beta tFinal jogador-max ))
	    (novo-alfa (max alfa valor)))

        (if (>= novo-alfa beta)  (progn (setf *nos-cortados-alfa* (+ *nos-cortados-alfa* 1))  (setf *nos-cortados* (+ *nos-cortados* 1)) beta )

          (progn 
            (setf *jogada* no-a-expandir)
            (setf *analised-nodes* (+ *analised-nodes* 1))
            ;(setf (gethash (no-estado-tabuleiro no-a-expandir) *my-hash*) valor) 
            (max novo-alfa (alfabeta-max (cdr sucessores) jogador tempoLimite profLim novo-alfa beta tfinal jogador-max ))))))))




(defun alfabeta-min (sucessores jogador tempoLimite profLim alfa beta tFinal jogador-max )
  (cond 
   ((null sucessores)  beta )
   (t (let* 
          ( (jogador-oposto (trocar-jogador jogador))
            (no-a-expandir (car sucessores))
	    (valor (alfabeta-v2 no-a-expandir jogador-oposto tempoLimite profLim alfa beta tFinal jogador-max ))
	    (novo-beta (min beta valor)))
          
        (if (<= novo-beta alfa)  (progn  (setf *nos-cortados-beta* (+ *nos-cortados-beta* 1)) (setf *nos-cortados* (+ *nos-cortados* 1))  alfa  )

          (progn             
            (setf *jogada* no-a-expandir)
            (setf *analised-nodes* (+ *analised-nodes* 1)  )
            ;(setf (gethash (no-estado-tabuleiro no-a-expandir) *my-hash*) valor)
            (min novo-beta (alfabeta-min (cdr sucessores) jogador tempoLimite profLim alfa novo-beta tfinal jogador-max ))))
        ))))


















