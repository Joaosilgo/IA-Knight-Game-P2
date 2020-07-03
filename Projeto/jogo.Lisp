;;;; Projeto Knights Game
;;;; Disciplina de IA - 2019 / 2020
;;;; Professor: Joaquim Filipe & Eng. Filipe Mariano 
;;;; Autor: João Gomes & André Gastão

(defpackage :p150221001-130221037)

(defvar *jogador1* -1)
(defvar *jogador2* -2)

(defvar *jogada*           )
(defvar *nos-cortados*   0 )
(defvar *nos-cortados-alfa*   0 )
(defvar *nos-cortados-beta*   0 )


(defvar *analised-nodes* 0 )
(defvar *expanded-nodes* 0 )
(defvar *execution-time* 0 )

(defvar *pontos-jogador1* 0 )
(defvar *pontos-jogador2* 0 )






#|
_________________________________________________ Tabuleiro _________________________________________________
|# 


;Teste: (lista-numeros)
(defun lista-numeros (&optional (n 100))
  "Cria um lista padrao, sequencial de numeros até 100"
  (cond((<= n 0) '())
       ((cons (- n 1) (lista-numeros(- n 1))))))



(defun remover-se(pred lista)
  (cond ((null lista) NIL) 
        ((funcall pred (car lista)) (remover-se pred (cdr lista)))
        (T (cons (car lista) (remover-se pred (cdr lista))))))



(defun baralhar (lista_numeros)
  (cond
   ((<= (list-length lista_numeros) 0) '())
   (t (let((random_Number (nth (random (length lista_numeros)) lista_numeros)))
        (cons random_number  (baralhar (remover-se  #'(lambda (x) (= x random_Number)) lista_numeros)))))))



;Teste: (tabuleiro-aleatorio ( baralhar ( lista-numeros ) ) 10)
;Teste(Opcional): (pprint(tabuleiro-aleatorio ( baralhar ( lista-numeros ) ) 10))
(defun tabuleiro-aleatorio (lista n)
  (cond
   ((null lista) nil)
   (t (cons (subseq lista 0 n) (tabuleiro-aleatorio (subseq lista n) n)))))



;;Teste: (tabuleiro) 
(defun tabuleiro()
  "Cria um tabuleiro aleatório"
  (tabuleiro-aleatorio ( baralhar ( lista-numeros ) ) 10))




;Teste: (configurar-tabuleiro (tabuleiro))
(defun configurar-tabuleiro (tabuleiro)
  "Coloca os jogadores em jogo nas maiores casas de cada lado"
  (cond 
   ((null tabuleiro) nil)
   (T 
    (let* ((posicaoCavaloBranco (posicao-valor  tabuleiro  (maximum (casas-fila (linha 0 tabuleiro)))))  
           (posicaoCavaloPreto  (posicao-valor  tabuleiro  (maximum (casas-fila (linha 9 tabuleiro)))))
           (SimetricoBranco     (regra-simetrico (celula (first posicaoCavaloBranco)(second posicaoCavaloBranco) tabuleiro) ))
           (SimetricoPreto      (regra-simetrico (celula (first posicaoCavaloPreto )(second posicaoCavaloPreto ) tabuleiro) ))
           (posicaoSimetricoBranco (posicao-valor tabuleiro SimetricoBranco ))
           (posicaoSimetricoPreto  (posicao-valor tabuleiro SimetricoPreto  ))
           (maxDuploBranco         (Duplo-Maximo (Duplos-Disponiveis  tabuleiro )))
           (maxDuploPreto          (Duplo-Maximo (Duplos-Disponiveis  tabuleiro ))) 
           (posicaoDuploBranco     (posicao-valor tabuleiro maxDuploBranco )) 
           (posicaoDuploPreto      (posicao-valor tabuleiro maxDuploPreto  ))
           (isDuplo1               (regra-duplo (celula (first posicaoCavaloBranco)(second posicaoCavaloBranco) tabuleiro) ))
           (isDuplo2               (regra-duplo (celula (first posicaoCavaloPreto) (second posicaoCavaloPreto)  tabuleiro) )))


                  (cond 
                            ((and (eq isDuplo1 T) (eq isDuplo2 Nil))

                     (list (substituir (first posicaoCavaloBranco)    (second posicaoCavaloBranco)  
                           (substituir (first posicaoCavaloPreto)     (second posicaoCavaloPreto)                                                     
                           (substituir (first posicaoSimetricoBranco) (second posicaoSimetricoBranco) 
                           (substituir (first posicaoSimetricoPreto)  (second posicaoSimetricoPreto) 
                           (substituir (first posicaoDuploBranco)     (second posicaoDuploBranco) tabuleiro NIL) NIL) NIL)-2)-1) 
                           (maximum (casas-fila (linha 0 tabuleiro)))
                           (maximum (casas-fila (linha 9 tabuleiro)))))

                            ((and (eq isDuplo1 Nil) (eq isDuplo2 T))

                     (list (substituir (first posicaoCavaloBranco)    (second posicaoCavaloBranco)  
                           (substituir (first posicaoCavaloPreto)     (second posicaoCavaloPreto)                                                     
                           (substituir (first posicaoSimetricoBranco) (second posicaoSimetricoBranco) 
                           (substituir (first posicaoSimetricoPreto)  (second posicaoSimetricoPreto)                        
                           (substituir (first posicaoDuploPreto)      (second posicaoDuploPreto) tabuleiro NIL) NIL) NIL)-2)-1) 
                           (maximum (casas-fila (linha 0 tabuleiro)))
                           (maximum (casas-fila (linha 9 tabuleiro)))))

                            ((and (eq isDuplo1 Nil) (eq isDuplo2 Nil))

                     (list (substituir (first posicaoCavaloBranco)    (second posicaoCavaloBranco)  
                           (substituir (first posicaoCavaloPreto)     (second posicaoCavaloPreto)                                                     
                           (substituir (first posicaoSimetricoBranco) (second posicaoSimetricoBranco) 
                           (substituir (first posicaoSimetricoPreto)  (second posicaoSimetricoPreto) tabuleiro NIL) NIL)-2)-1) 
                           (maximum (casas-fila (linha 0 tabuleiro)))
                           (maximum (casas-fila (linha 9 tabuleiro)))))

                            (t 
                             
                     (list (substituir (first posicaoCavaloBranco)    (second posicaoCavaloBranco)  
                           (substituir (first posicaoCavaloPreto)     (second posicaoCavaloPreto)                                                     
                           (substituir (first posicaoSimetricoBranco) (second posicaoSimetricoBranco) 
                           (substituir (first posicaoSimetricoPreto)  (second posicaoSimetricoPreto) 
                           (substituir (first posicaoDuploBranco)     (second posicaoDuploBranco) 
                           (substituir (first posicaoDuploPreto)      (second posicaoDuploPreto) tabuleiro NIL) NIL) NIL) NIL)-2)-1) 
                           (maximum (casas-fila (linha 0 tabuleiro)))
                           (maximum (casas-fila (linha 9 tabuleiro))))))
  
                    ))))

;;Teste: (configurar-Inicio-Jogo ((configurar-tabuleiro (tabuleiro))))
(defun configurar-Inicio-Jogo (tabuleiro)
  "Cria o primeiro nó inicial de jogo"
  ;; (Tabuleiro|cor-cavalo|Pontos1|Pontos2|Profundidade|Pai|Heuristica)
  (cria-no (first tabuleiro) 0 (second tabuleiro) (third tabuleiro) 0 nil 0))





(defun tabuleiro-teste ()
"Tabuleiro de teste"

  '(
    (-1 25 54 89 21 08 36 14 41 96) 
    (78 47 56 23 05 49 13 12 26 60) 
    (00 27 17 83 34 93 74 52 45 80) 
    (69 09 77 95 55 39 91 73 57 30) 
    (24 15 22 86 01 11 68 79 76 72) 
    (81 48 32 02 64 16 50 37 29 71) 
    (99 51 06 18 53 28 07 63 10 88) 
    (59 42 46 85 90 75 87 43 20 31) 
    (03 61 58 44 65 82 19 04 35 62) 
    (33 70 84 40 66 38 92 67 98 -2)
    )
)






#|
_________________________________________________ Seletores  _________________________________________________
|# 


;;Teste:  (linha 0 (tabuleiro))
;;Resultado: (94 25 54 89 21 8 36 14 41 96)
(defun linha (linha tabuleiro)
  "retorna a linha de um tabuleiro"
  (cond  
   ((eq (numberp linha) Nil)           Nil )
   ((null tabuleiro)                   Nil )
   ((< linha 0)                        Nil )
   ((> linha 9)                        Nil )        
   (t(nth linha tabuleiro))
   )
  )



;;Teste: (celula 0 1 (tabuleiro))
;;Resultado: 25
(defun celula (linha coluna tabuleiro)
  "retorna a celula de um tabuleiro"
  (cond  
   ((eq (numberp linha ) Nil) Nil )
   ((eq (numberp coluna) Nil) Nil )
   ((null tabuleiro)          Nil )
   ((< coluna 0)              Nil )
   ((> coluna 9)              Nil )        
   (t (nth coluna (linha linha tabuleiro)))
   )
  )



;;teste: (substituir-posicao 0 (linha 0 (tabuleiro)) -1)
;;Resultado: (-1 25 54 89 21 8 36 14 41 96)
(defun substituir-posicao (c linha &optional (valor NIL))
"Retorna um linha com o index substituido"
  (cond
   ((or(> c (- (length linha) 1)) (< c 0)) Nil)
   ((= c 0) (cons valor (cdr linha)))
   (t       (cons (car linha) (substituir-posicao (- c 1) (cdr linha) valor)))
   )
  )


;;Teste:(substituir 0 0 (tabuleiro) -1)
;((-1 25 54 89 21 08 36 14 41 96) 
;(78 47 56 23 05 49 13 12 26 60) 
;(00 27 17 83 34 93 74 52 45 80) 
;(69 09 77 95 55 39 91 73 57 30) 
;(24 15 22 86 01 11 68 79 76 72) 
;(81 48 32 02 64 16 50 37 29 71) 
;(99 51 06 18 53 28 07 63 10 88) 
;(59 42 46 85 90 75 87 43 20 31) 
;(03 61 58 44 65 82 19 04 35 62) 
;(33 70 84 40 66 38 92 67 98 97))
(defun substituir ( l c tabuleiro &optional (valor NIL))
  "Retorna um linha com o index substituido"
  (cond
   ((or (eq l Nil)  (eq c Nil)) tabuleiro )
   ((= l 0)(cons (substituir-posicao c (linha l tabuleiro) valor) (cdr tabuleiro)))
   (t      (cons (car tabuleiro) (substituir (- l 1) c (cdr tabuleiro) valor )))
   )
  )



;;Teste: (posicao-cavalo (tabuleiro-teste) *jogador1*)
;;Resultado: NIL
(defun posicao-cavalo (tabuleiro jogador &optional (line 0) )
 "Retorna a posição (x y) de onde se localiza o cavalo Branco"
  (cond    
   ((null tabuleiro) Nil)
   ((equal (find jogador (car tabuleiro)) jogador) (list line (position jogador (car tabuleiro))))
   (t (posicao-cavalo (cdr tabuleiro) jogador (+ line 1)) ))
  )




;;Teste: (posicao-cavalo-branco (tabuleiro))
;;Resultado: NIL
(defun posicao-cavalo-branco (tabuleiro &optional (line 0) )
 "Retorna a posição (x y) de onde se localiza o cavalo Branco"
  (cond    
   ((null tabuleiro) Nil)
   ((equal (find -1 (car tabuleiro)) -1) (list line (position -1 (car tabuleiro))))
   (t (posicao-cavalo-branco (cdr tabuleiro) (+ line 1)) ))
  )

;;Teste: (posicao-cavalo-preto (tabuleiro))
;;Resultado: NIL
(defun posicao-cavalo-preto (tabuleiro &optional (line 0) )
 "Retorna a posição (x y) de onde se localiza o cavalo Branco"
  (cond    
   ((null tabuleiro) Nil)
   ((equal (find -2 (car tabuleiro)) -2) (list line (position -2 (car tabuleiro))))
   (t (posicao-cavalo-preto (cdr tabuleiro) (+ line 1)) ))
  )


#|
_________________________________________________ Operadores  _________________________________________________
|# 


#|                                                          MOVIMENTOS
- (8 movimentos)
 (x, y) => (l , c) => moves ( cima/baixo , direita/esquerda)
operador-1 (2  -1)
operador-2 (2   1)
operador-3 (1   2)
operador-4 (-1  2)
operador-5 (-2  1)
operador-6 (-2 -1)
operador-7 (-1 -2)
operador-8 (1  -2)
|# 



;;Teste: (operadores)
;;Resultado:(OPERADOR-1 OPERADOR-2 OPERADOR-3 OPERADOR-4 OPERADOR-5 OPERADOR-6 OPERADOR-7 OPERADOR-8)
(defun operadores ()
  "Cria uma lista com todos os operadores do Jogo do Cavalo (Knight´s Tour)."
  (list 'operador-1 'operador-2 'operador-3 'operador-4 'operador-5 'operador-6 'operador-7 'operador-8))

;TODO´s:
;1 - Verificar se o movimento é válido;
;2 - Verificar se o cavalo está nalguma casa do tabuleiro, caso contrário deverá posicionar o cavalo numa casa da 1ª linha;
;3 - Após o movimento do cavalo, deverá aplicar a regra do número simétrico ou a regra do número duplo.



 #|OPERADOR-1|#
;;Teste: (operador-1 (tabuleiro-teste) *jogador1*)
;;Resultado: NIL
(defun operador-1 (tabuleiro jogador)
  "Operador-1 (+2 +1)"
  (cond 
   ((null tabuleiro) nil)
   ((eq (posicao-cavalo tabuleiro jogador) NIL) NIL)
   (T (let* ((posicaoCavaloInicial (posicao-cavalo tabuleiro jogador))  
             (posicaoCavaloFinal (list (+(car(posicao-cavalo tabuleiro jogador)) 2) (+(second(posicao-cavalo tabuleiro jogador))1) ))
             (isvalido (validar-movimento (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro)))
        (cond   
         ((eq isvalido T)(let* ( (Simetrico (regra-simetrico (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                                 (posicaoSimetrico (posicao-valor tabuleiro Simetrico ))
                                 (isDuplo (regra-duplo (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                                 (maxDuplo  (Duplo-Maximo (Duplos-Disponiveis  tabuleiro ))) 
                                 (posicaoDuplo (posicao-valor tabuleiro maxDuplo ))) 

                           (cond 
                            ((eq isDuplo T)
                             (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                          (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial) 
                                                      (substituir (car posicaoDuplo) (second posicaoDuplo)
                                                                  (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)NIL)Nil)jogador))

                            (T (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                            (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial)                                                     
                                                        (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)Nil)jogador))))))))))



 #|OPERADOR-2|#
;;Teste: (operador-2 (tabuleiro-teste) *jogador1*)
;;Resultado: NIL
(defun operador-2 (tabuleiro jogador)
  "Operador-2 (+1 +2)"
  (cond 
   ((null tabuleiro) nil)
   ((eq (posicao-cavalo tabuleiro jogador) NIL) NIL)
   (T (let* ((posicaoCavaloInicial (posicao-cavalo tabuleiro jogador))  
             (posicaoCavaloFinal (list (+(car(posicao-cavalo tabuleiro jogador)) 1) (+(second(posicao-cavalo tabuleiro jogador))2) ))
             (isvalido (validar-movimento (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro)))      
        (cond   
         ((eq isvalido T)(let* ( (Simetrico (regra-simetrico (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                                 (posicaoSimetrico (posicao-valor tabuleiro Simetrico ))
                                 (isDuplo (regra-duplo (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                                 (maxDuplo  (Duplo-Maximo (Duplos-Disponiveis  tabuleiro ))) 
                                 (posicaoDuplo (posicao-valor tabuleiro maxDuplo ))) 

                           (cond 
                            ((eq isDuplo T)
                             (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                          (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial) 
                                                      (substituir (car posicaoDuplo) (second posicaoDuplo)
                                                                  (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)NIL)Nil)jogador))

                            (T (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                            (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial)                                                     
                                                        (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)Nil)jogador))))))))))


 
 #|OPERADOR-3|#
;;Teste: (operador-3 (tabuleiro-teste) *jogador1*)
;;Resultado: NIL
(defun operador-3 (tabuleiro jogador)
  "operador-3 (1   2)"
  (cond 
   ((null tabuleiro) nil)
   ((eq (posicao-cavalo tabuleiro jogador) NIL) NIL)
   (T 
    (let* ((posicaoCavaloInicial (posicao-cavalo tabuleiro jogador))  
           (posicaoCavaloFinal (list (-(car(posicao-cavalo tabuleiro jogador)) 1) (+(second(posicao-cavalo tabuleiro jogador))2) ))
           (isvalido (validar-movimento (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro)))
                                                    
      (cond   
       ((eq isvalido T)(let* ( (Simetrico (regra-simetrico (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (posicaoSimetrico (posicao-valor tabuleiro Simetrico ))
                               (isDuplo (regra-duplo (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (maxDuplo  (Duplo-Maximo (Duplos-Disponiveis  tabuleiro ))) 
                               (posicaoDuplo (posicao-valor tabuleiro maxDuplo ))) 
         
                         (cond 
                          ((eq isDuplo T)
                           (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                        (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial) 
                                                    (substituir (car posicaoDuplo) (second posicaoDuplo)
                                                                (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)NIL)Nil)jogador))

                          (T (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                          (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial)                                                     
                                                      (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)Nil)jogador))))))))))



 #|OPERADOR-4|#
;;Teste: (operador-4 (tabuleiro-teste) *jogador1*)
;;Resultado: NIL
(defun operador-4 (tabuleiro jogador)
  "operador-4 (-1  2)"
  (cond 
   ((null tabuleiro) nil)
   ((eq (posicao-cavalo tabuleiro jogador) NIL) NIL)
   (T 
    (let* ((posicaoCavaloInicial (posicao-cavalo tabuleiro jogador))  
           (posicaoCavaloFinal (list (-(car(posicao-cavalo tabuleiro jogador)) 2) (+(second(posicao-cavalo tabuleiro jogador))1) ))
           (isvalido (validar-movimento (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro)))
                                                    
      (cond   
       ((eq isvalido T)(let* ( (Simetrico (regra-simetrico (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (posicaoSimetrico (posicao-valor tabuleiro Simetrico ))
                               (isDuplo (regra-duplo (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (maxDuplo  (Duplo-Maximo (Duplos-Disponiveis  tabuleiro ))) 
                               (posicaoDuplo (posicao-valor tabuleiro maxDuplo ))) 
         
                         (cond 
                          ((eq isDuplo T)
                           (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                        (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial) 
                                                    (substituir (car posicaoDuplo) (second posicaoDuplo)
                                                                (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)NIL)Nil)jogador))

                          (T (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                          (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial)                                                     
                                                      (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)Nil)jogador))))))))))



 #|OPERADOR-5|#
;;Teste: (operador-5 (tabuleiro-teste) *jogador1*)
;;Resultado: NIL
(defun operador-5 (tabuleiro jogador)
  (cond 
   ((null tabuleiro) nil)
   ((eq (posicao-cavalo tabuleiro jogador) NIL) NIL)
   (T 
    (let* ((posicaoCavaloInicial (posicao-cavalo tabuleiro jogador))  
           (posicaoCavaloFinal (list (-(car(posicao-cavalo tabuleiro jogador)) 2) (-(second(posicao-cavalo tabuleiro jogador))1) ))
           (isvalido (validar-movimento (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro)))
                                                    
      (cond   
       ((eq isvalido T)(let* ( (Simetrico (regra-simetrico (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (posicaoSimetrico (posicao-valor tabuleiro Simetrico ))
                               (isDuplo (regra-duplo (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (maxDuplo  (Duplo-Maximo (Duplos-Disponiveis  tabuleiro ))) 
                               (posicaoDuplo (posicao-valor tabuleiro maxDuplo ))) 
                         (cond 
                          ((eq isDuplo T)
                           (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                        (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial) 
                                                    (substituir (car posicaoDuplo) (second posicaoDuplo)
                                                                (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)NIL)Nil)jogador))

                          (T (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                          (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial)                                                     
                                                      (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)Nil)jogador))))))))))



 #|OPERADOR-6|#
;;Teste: (operador-6 (tabuleiro-teste) *jogador1*)
;;Resultado: NIL
(defun operador-6 (tabuleiro jogador)
  (cond 
   ((null tabuleiro) nil)
   ((eq (posicao-cavalo tabuleiro jogador) NIL) NIL)
   (T 
    (let* ((posicaoCavaloInicial (posicao-cavalo tabuleiro jogador))  
           (posicaoCavaloFinal (list (-(car(posicao-cavalo tabuleiro jogador)) 1) (-(second(posicao-cavalo tabuleiro jogador))2) ))
           (isvalido (validar-movimento (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro)))
                                                    
      (cond   
       ((eq isvalido T)(let* ( (Simetrico (regra-simetrico (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (posicaoSimetrico (posicao-valor tabuleiro Simetrico ))
                               (isDuplo (regra-duplo (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (maxDuplo  (Duplo-Maximo (Duplos-Disponiveis  tabuleiro ))) 
                               (posicaoDuplo (posicao-valor tabuleiro maxDuplo ))) 
         
                         (cond 
                          ((eq isDuplo T)
                           (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                        (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial) 
                                                    (substituir (car posicaoDuplo) (second posicaoDuplo)
                                                                (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)NIL)Nil)jogador))

                          (T (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                          (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial)                                                     
                                                      (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)Nil)jogador))))))))))



 #|OPERADOR-7|#
;;Teste: (operador-7 (tabuleiro-teste) *jogador1*)
;;Resultado: NIL
(defun operador-7 (tabuleiro jogador)
  "Se for Nil não á cavalo no tabuleiro" 
  (cond 
   ((null tabuleiro) nil)
   ((eq (posicao-cavalo tabuleiro jogador) NIL) NIL)
   (T 
    (let* ((posicaoCavaloInicial (posicao-cavalo tabuleiro jogador)) 
           (posicaoCavaloFinal (list (+(car(posicao-cavalo tabuleiro jogador)) 1) (-(second(posicao-cavalo tabuleiro jogador))2) )) 
           (isvalido (validar-movimento (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro)))
                                                    
      (cond   
       ((eq isvalido T)(let* ( (Simetrico (regra-simetrico (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (posicaoSimetrico (posicao-valor tabuleiro Simetrico ))
                               (isDuplo (regra-duplo (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (maxDuplo  (Duplo-Maximo (Duplos-Disponiveis  tabuleiro ))) 
                               (posicaoDuplo (posicao-valor tabuleiro maxDuplo ))) 

                         (cond 
                          ((eq isDuplo T)
                           (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                        (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial) 
                                                    (substituir (car posicaoDuplo) (second posicaoDuplo)
                                                                (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)NIL)Nil)jogador))

                          (T (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                          (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial)                                                     
                                                      (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)Nil)jogador))))))))))



 #|OPERADOR-8|#
;;Teste: (operador-8 (tabuleiro-teste) *jogador1*)
;;Resultado: NIL
(defun operador-8 (tabuleiro jogador)
  (cond 
   ((null tabuleiro) nil)
   ((eq (posicao-cavalo tabuleiro jogador) NIL) NIL)
   (T 
    (let* ((posicaoCavaloInicial (posicao-cavalo tabuleiro jogador))  
           (posicaoCavaloFinal (list (+(car(posicao-cavalo tabuleiro jogador)) 2) (-(second(posicao-cavalo tabuleiro jogador))1) ))
           (isvalido (validar-movimento (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro)))
                                                    
      (cond   
       ((eq isvalido T)(let* ( (Simetrico (regra-simetrico (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (posicaoSimetrico (posicao-valor tabuleiro Simetrico ))
                               (isDuplo (regra-duplo (celula (first posicaoCavaloFinal)(second posicaoCavaloFinal) tabuleiro) ))
                               (maxDuplo  (Duplo-Maximo (Duplos-Disponiveis  tabuleiro ))) 
                               (posicaoDuplo (posicao-valor tabuleiro maxDuplo ))) 

         
                         (cond 
                          ((eq isDuplo T)
                           (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                        (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial) 
                                                    (substituir (car posicaoDuplo) (second posicaoDuplo)
                                                                (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)NIL)Nil)jogador))

                          (T (substituir  (first posicaoCavaloFinal ) (second posicaoCavaloFinal )  
                                          (substituir (car posicaoCavaloInicial) (second posicaoCavaloInicial)                                                     
                                                      (substituir (car posicaoSimetrico) (second posicaoSimetrico) tabuleiro NIL)Nil)jogador))))))))))





#|
_________________________________________________ Validações & Regras  _________________________________________________
|# 



;;Teste: (validar-movimento 0 10 (tabuleiro-teste))
;;Resultado: NIL
(defun validar-movimento(l c tabuleiro)
  "Função para validar o movimento que retorna T ou NIL caso possa ou não se movimentar"
  (cond 
   ( (eq l Nil)                         Nil)
   ( (eq c Nil)                         Nil)
   ( (null tabuleiro)                   Nil)
   ( (or (> l 9) (< l 0))               Nil)
   ( (or (> c 9) (< c 0))               Nil)
   ( (equal (celula l c tabuleiro) Nil) Nil)
   ( (= (celula l c tabuleiro)  -1) Nil)
   ( (= (celula l c tabuleiro)  -2) Nil)
   (t T)))



;;Teste: (regra-simetrico 98)
;;Resultado: 89
(defun regra-simetrico (numero)
  "Retorna o numero simetrico do argumento recebido"
  (cond
   (  (eq (numberp numero) Nil) Nil )
   (  (< numero 0) Nil )
   (T (+ (*(mod numero 10 ) 10)(multiple-value-bind (q) (floor numero 10) q) )))
  )


  
;;Teste: (regra-duplo 99)
;;Resultado: T
(defun regra-duplo (numero)
  "Retorna T se for simetrico senão NIL"
  (cond
   ( (not (numberp numero) ) Nil )
   ( (= numero 0) Nil)
   ( (And (= (multiple-value-bind (q) (floor numero 10) q)  (mod numero 10 ) ) (numberp numero)) T)
   (T Nil)))



;;Teste: (Duplo-Maximo (Duplos-Disponiveis ( tabuleiro-teste )))
;;Resultado: 99
(defun Duplo-Maximo (lista) 
  (maximum lista))



;;Teste: (Duplos-Disponiveis ( tabuleiro-teste ))
;;Resultado: (99 88 77 66 55 44 33 22 11)
(defun Duplos-Disponiveis ( tabuleiro )
  "Retorna a lista de Duplos Disponiveis Ordenada"
  (sort (duplos(alisa tabuleiro))  #'>))



;;Teste: (duplos(alisa ( tabuleiro-teste ))) 
;;Resultado: (77 55 22 11 99 88 44 33 66)
(defun duplos (tabuleiro)
  "recebe uma lista e retorna outra lista com numeros Duplos disponiveis desorganizados "
  (cond 
   ((null tabuleiro) '())
   ((equal (regra-duplo (car tabuleiro))  T) (cons (car tabuleiro) (duplos (cdr tabuleiro)  )))
   (T (duplos (cdr tabuleiro) )))
  )



;; Teste ( posicao-valor ( tabuleiro-Teste) 99  )
;;Resultado: (6 0)
(defun posicao-valor ( tabuleiro valor &optional (line 0) )
""
  (cond 
   ((eq (numberp valor) Nil) Nil )
   ((eq valor Nil) Nil)
   ((null tabuleiro) NIL)
   ((equal (find valor (car tabuleiro)) valor ) (list line (position valor (car tabuleiro))))
   (t (posicao-valor   (cdr tabuleiro) valor (+ line 1) ) ))
  )



;;Teste: (numero-jogadas-disponiveis (sucessores (no-teste) (operadores) *jogador1*) )
;;Resultado:10
(defun numero-jogadas-disponiveis(sucessao) 
  "Conta o numéro de jogadas a partir do nº de sucessões que existe"
  (cond
   ((null sucessao) 0)
   ((equal sucessao  Nil ) 0 )
   ((equal (car sucessao)  Nil ) 0 )
   (t  ( + 1 ( numero-jogadas-disponiveis (cdr sucessao) )))
   )
  )


;;Teste: (casas-primeira-fila (linha 0 (tabuleiro-teste)))
;;Resultado:(94 25 54 89 21 8 36 14 41 96)
(defun casas-fila(linha)
  "Devolve uma lista de casas disponiveis na primeira fila"
  (cond
   ((null linha)  Nil)
   ((equal linha  Nil)  Nil )
   ((equal linha  T  )  Nil )
   ((equal (car linha)  Nil ) (casas-fila (cdr linha)))
   ((equal (car linha)  -1  ) (casas-fila (cdr linha)))
   ((equal (car linha)  -2  ) (casas-fila (cdr linha)))
   (t      (cons  (car linha) (casas-fila (cdr linha))))
   )
  )



#|
_________________________________________________ Funções Auxiliares  _________________________________________________
|# 

;;TESTE:
(defun maximum (list)
  (cond
   ((null list) NIL)
   ((equal list  Nil ) NIL )    
   (t   (reduce #'max list)))
  )

;TESTE: (junta '(NIL 25 54 89 21 8 36 14 41 96) '(78 47 56 23 5 NIL 13 12 26 60) )
(defun junta (lista1 lista2)
  (cond 
   ((= (length lista1)0) lista2)
   (T(cons (car lista1) (junta (cdr lista1)lista2))))
  )

(defun alisa (lista)
  (cond 
   ((= (length lista)0) nil)
   ((listp (car lista)) (junta(alisa(car lista))(alisa(cdr lista))))
   (T (cons (car lista)(alisa (cdr lista))))
   )
  )




#|
_________________________________________________ Representação De Estados _________________________________________________
|# 



;Teste: (pprint(no-teste))
;Resultado:
;(((94 25 54 89 210 8 36 14 41 96)
;  (78 47 56 23 05 49 13 12 26 60)
;  (00 27 17 83 34 93 74 52 45 80)
;  (69 09 77 95 55 39 91 73 57 30)
;  (24 15 22 86 01 11 68 79 76 72)
;  (81 48 32 02 64 16 50 37 29 71)
;  (99 51 06 18 53 28 07 63 10 88)
;  (59 42 46 85 90 75 87 43 20 31)
;  (03 61 58 44 65 82 19 04 35 62)
;  (33 70 84 40 66 38 92 67 98 97))
; 0
; 0
; 0
; 0
; NIL
; 40.40404)
(defun no-teste ()
"Define um no teste do problema do cavalo em que linha=0, posicao=0, profundidade=0 e pai=NIL"
 (list (tabuleiro-teste) 0 0 0 0 nil 0 ))


;;Teste: (pprint(cria-no (tabuleiro-teste) '(0 0) 0 0 nil (float (/ (objetivo) (m1 (tabuleiro-teste))))))
;Resultado:
;(((94 25 54 89 210 8 36 14 41 96)
;  (78 47 56 23 05 49 13 12 26 60)
;  (00 27 17 83 34 93 74 52 45 80)
;  (69 09 77 95 55 39 91 73 57 30)
;  (24 15 22 86 01 11 68 79 76 72)
;  (81 48 32 02 64 16 50 37 29 71)
;  (99 51 06 18 53 28 07 63 10 88)
;  (59 42 46 85 90 75 87 43 20 31)
;  (03 61 58 44 65 82 19 04 35 62)
;  (33 70 84 40 66 38 92 67 98 97))
; (0 0)
; 0
; 0
; NIL
; 40.40404)
(defun cria-no (tabuleiro cavalo pontos1 pontos2 profundidade pai heuristica)                           
  "Cria um nó : (Tabuleiro|corcavalo|Pontos1|Pontos2|Profundidade|Pai|Heuristica)"
  (list tabuleiro cavalo pontos1 pontos2 profundidade pai heuristica))



;;Teste: (no-estado-tabuleiro(no-teste))
;Resultado:
;(((94 25 54 89 210 8 36 14 41 96)
;  (78 47 56 23 05 49 13 12 26 60)
;  (00 27 17 83 34 93 74 52 45 80)
;  (69 09 77 95 55 39 91 73 57 30)
;  (24 15 22 86 01 11 68 79 76 72)
;  (81 48 32 02 64 16 50 37 29 71)
;  (99 51 06 18 53 28 07 63 10 88)
;  (59 42 46 85 90 75 87 43 20 31)
;  (03 61 58 44 65 82 19 04 35 62)
;  (33 70 84 40 66 38 92 67 98 97))
(defun no-estado-tabuleiro (no)
  (first no))



;;Teste: (no-Posicao(no-teste))
;Resultado: (0 0)
(defun no-cavalo (no)
  (second no))



;;Teste: (no-pontos(no-teste))
;Resultado: 0
(defun no-pontos (no jogador)
(cond 
((= jogador -1 ) (third no))
((= jogador -2 ) (fourth no))
(t 0)))





;;Teste: (no-profundidade(no-teste))
;Resultado: 0
(defun no-profundidade (no)
  (fifth no))



;;Teste: (no-pai(no-teste))
;Resultado: NIL
(defun no-pai (no)
  (sixth no))


;;Teste: (no-H(no-teste))
;Resultado: 
(defun no-H (no)
  (seventh  no))



;;Teste: (no-custo(no-teste))
;Resultado:
(defun no-custo (no)
  "f(n)=g(n)+h(n) "
  (+(no-profundidade no)(no-H no)))






   
;; teste: (novo-sucessor (no-teste) 'operador-1 *jogador1*)
(defun novo-sucessor (no op jogador )
  " Cria um novo sucessor a partir do no que recebe e a operação"     
  (let ((estado (funcall op (no-estado-tabuleiro no) jogador)))
    (cond 
     ((null estado)nil)
     ((eq (posicao-cavalo (no-estado-tabuleiro no) jogador) Nil)  Nil) 
     (T(cond   ((equal op 'operador-1) 
                (cria-no (operador-1 (no-estado-tabuleiro no) jogador) jogador
                         (incrementar-valor no op jogador) 0 (+ (no-profundidade no) 1) no 0 ))
               ((equal op 'operador-2) 
                (cria-no (operador-2 (no-estado-tabuleiro no) jogador)jogador
                         (incrementar-valor no op jogador) 0 (+ (no-profundidade no) 1) no 0 ))
               ((equal op 'operador-3) 
                (cria-no (operador-3 (no-estado-tabuleiro no) jogador)jogador
                         (incrementar-valor no op jogador) 0 (+ (no-profundidade no) 1) no 0 ))
               ((equal op 'operador-4) 
                (cria-no (operador-4 (no-estado-tabuleiro no) jogador)jogador
                         (incrementar-valor no op jogador) 0 (+ (no-profundidade no) 1) no 0 ))
               ((equal op 'operador-5) 
                (cria-no (operador-5 (no-estado-tabuleiro no) jogador)jogador
                         (incrementar-valor no op jogador) 0 (+ (no-profundidade no) 1) no 0 ))
               ((equal op 'operador-6) 
                (cria-no (operador-6 (no-estado-tabuleiro no) jogador)jogador
                         (incrementar-valor no op jogador) 0 (+ (no-profundidade no) 1) no 0 ))
               ((equal op 'operador-7) 
                (cria-no (operador-7 (no-estado-tabuleiro no) jogador)jogador
                         (incrementar-valor no op jogador) 0 (+ (no-profundidade no) 1) no 0 ))
               ((equal op 'operador-8) 
                (cria-no (operador-8 (no-estado-tabuleiro no) jogador)jogador
                         (incrementar-valor no op jogador) 0 (+ (no-profundidade no) 1) no 0 ))
               (t Nil))
       ))))



(defun novo-suc (no op jogador )

(let ((estado (funcall op (no-estado-tabuleiro no) jogador)))
    (cond 
     ((null estado)nil)
     ((eq (posicao-cavalo (no-estado-tabuleiro no) jogador) Nil)  Nil) 
     ((= jogador -1)  
      (cria-no estado jogador (incrementar-valor no op jogador)(no-pontos no -2)(+(no-profundidade no) 1) no (h no jogador)))
      ((= jogador -2)  
      (cria-no estado jogador (no-pontos no -1)(incrementar-valor no op jogador)(+(no-profundidade no) 1) no (h no jogador)))
)))




(defun incrementar-valor(no op jogador)
  "Incrementa os pontos  do no a partir do valor da casa consoante a operação fornecida Poderia haver refactoring para que no tabuleiro houvesse o tabuleiro e os pontos do jogador 1 e 2"
  (cond   ((equal op 'operador-1)  (+ (celula (+(first  (posicao-cavalo (no-estado-tabuleiro no) jogador))2) 
                                              (+(second (posicao-cavalo (no-estado-tabuleiro no) jogador))1) (no-estado-tabuleiro no))  
                                      (no-pontos no jogador))) 
          ((equal op 'operador-2)  (+ (celula (+(first  (posicao-cavalo (no-estado-tabuleiro no) jogador))1) 
                                              (+(second (posicao-cavalo (no-estado-tabuleiro no) jogador))2) (no-estado-tabuleiro no)) 
                                      (no-pontos no jogador))) 
          ((equal op 'operador-3)  (+ (celula (-(first  (posicao-cavalo (no-estado-tabuleiro no) jogador))1) 
                                              (+(second (posicao-cavalo (no-estado-tabuleiro no) jogador))2) (no-estado-tabuleiro no)) 
                                      (no-pontos no jogador))) 
          ((equal op 'operador-4)  (+ (celula (-(first  (posicao-cavalo (no-estado-tabuleiro no) jogador))2) 
                                              (+(second (posicao-cavalo (no-estado-tabuleiro no) jogador))1) (no-estado-tabuleiro no)) 
                                      (no-pontos no jogador))) 
          ((equal op 'operador-5)  (+ (celula (-(first  (posicao-cavalo (no-estado-tabuleiro no) jogador))2) 
                                              (-(second (posicao-cavalo (no-estado-tabuleiro no) jogador))1) (no-estado-tabuleiro no)) 
                                      (no-pontos no jogador))) 
          ((equal op 'operador-6)  (+ (celula (-(first  (posicao-cavalo (no-estado-tabuleiro no) jogador))1) 
                                              (-(second (posicao-cavalo (no-estado-tabuleiro no) jogador))2) (no-estado-tabuleiro no)) 
                                      (no-pontos no jogador))) 
          ((equal op 'operador-7)  (+ (celula (+(first  (posicao-cavalo (no-estado-tabuleiro no) jogador))1) 
                                              (-(second (posicao-cavalo (no-estado-tabuleiro no) jogador))2) (no-estado-tabuleiro no)) 
                                      (no-pontos no jogador))) 
          ((equal op 'operador-8)  (+ (celula (+(first  (posicao-cavalo (no-estado-tabuleiro no) jogador))2) 
                                              (-(second (posicao-cavalo (no-estado-tabuleiro no) jogador))1) (no-estado-tabuleiro no)) 
                                      (no-pontos no jogador)))
          (t Nil)))




;;Teste;  (sucessores (no-teste) (operadores) *jogador1* )"
(defun sucessores (no ops jogador)
  (cond 
    ((eq (posicao-cavalo (no-estado-tabuleiro no) jogador ) Nil) Nil )
    ((eq (no-estado-tabuleiro no) Nil ) Nil) 
    (t (remove nil(mapcar #'(lambda(op) (novo-suc no op jogador )) ops)))))

   




#|
_________________________________________________ Heuristica _________________________________________________
|# 




;Teste : (sum-Points-Tabuleiro (alisa (tabuleiro-teste)))
;Resultado: 4950
(defun sum-Points-Tabuleiro ( tabuleiro  )
  "Soma o Total de Pontos que eexiste no momento no tabuleiro"
  (cond 
   ((null tabuleiro) 0)
   ((or (equal (car tabuleiro) Nil) (equal (car tabuleiro) -1) (equal (car tabuleiro) -2) ) (sum-Points-Tabuleiro (cdr tabuleiro)) )
   (t (+(car tabuleiro) (sum-Points-Tabuleiro (cdr tabuleiro)))))
  )



;Teste : (sum-CasasDisponiveis-Tabuleiro (alisa (tabuleiro-teste)))
;Resultado: 100
(defun sum-CasasDisponiveis-Tabuleiro ( tabuleiro  )
  "Soma o total de casas disponiveis no tauleiro"
  (cond 
   ((null tabuleiro) 0)
   ( (or (equal (car tabuleiro) Nil) (equal (car tabuleiro) -1) (equal (car tabuleiro) -2)) (sum-CasasDisponiveis-Tabuleiro (cdr tabuleiro) ) )
   (t ( + 1  (sum-CasasDisponiveis-Tabuleiro (cdr tabuleiro)))))
  )



;Teste : (m (tabuleiro-teste))
;Resultado: 49.5
(defun m (tabuleiro)
  (cond
   ((or (=(sum-CasasDisponiveis-Tabuleiro (alisa tabuleiro)) 0) (=(sum-Points-Tabuleiro (alisa tabuleiro)) 0) ) 0)
   (t (float (/(sum-Points-Tabuleiro (alisa tabuleiro))  (sum-CasasDisponiveis-Tabuleiro (alisa tabuleiro)))))))



;Teste : (h (no-teste) )
;Resultado: 40.40404
;(defun h (no)
;  (cond 
 ;  ( (=(m (no-estado-tabuleiro no))0)  0)
 ;  (t  (m (no-estado-tabuleiro no) ))))
 
(defun h (no jogador)
(- (no-pontos no jogador ) (no-pontos no (trocar-jogador jogador) ) )
)



;____________________________________________________________________________________________________________












;;Teste: (trocar-jogador *jogador1*)
(defun trocar-jogador (jogador)
  "Realiza a troca entre jogadores"
  (cond
   ((= jogador -1) -2)
   (t -1)))





(defun verificar-vencedor (no jogador)
  "verifica quem é o vencedor, ou se existiu um empate"
  (cond 
   ((> (no-pontos no jogador) (no-pontos no (trocar-jogador jogador))) jogador)
   ((< (no-pontos no jogador) (no-pontos no (trocar-jogador jogador))) (trocar-jogador jogador))
   ((= (no-pontos no jogador) (no-pontos no (trocar-jogador jogador))) 0)
   (t nil))
  )








 
















        
(defmacro timing (&body forms)
  (let ((real1 (gensym))
        (real2 (gensym))
        (run1 (gensym))
        (run2 (gensym))
        (result (gensym)))
    `(let* ((,real1 (get-internal-real-time))
            (,run1 (get-internal-run-time))
            (,result (progn ,@forms))
            (,run2 (get-internal-run-time))
            (,real2 (get-internal-real-time)))
       (format *debug-io* "~%~%~%~%~%~%~%~%           Computation took:~%")
       (format *debug-io* "          ~f seconds of real time~%"
               (/ (- ,real2 ,real1) internal-time-units-per-second))
       (format t "          ~f seconds of run time~%"
               (/ (- ,run2 ,run1) internal-time-units-per-second))
       ,result)))



 
               















