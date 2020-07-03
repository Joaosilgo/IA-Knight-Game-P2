;;;; Projeto Knights Game
;;;; Disciplina de IA - 2019 / 2020
;;;; Professor: Joaquim Filipe & Eng. Filipe Mariano 
;;;; Autor: João Gomes & André Gastão

(defpackage :p150221001-130221037)

(defvar *initial-player* -1)
(defvar *tempo-limite* 1000)


(defun start ()
  "Permite iniciar o programa"

  (load (compile-file (concatenate 'string (diretoria-atual)      "jogo.lisp")))
  (load (compile-file (concatenate 'string (diretoria-atual) "algoritmo.lisp")))
  (configurar-tempo 5000)
  (menu-Load)
)

(defun diretoria-atual ()
  "Define o caminho para os ficheiros do projeto a partir da raiz"
  (let ((path "C:\\Users\\joao2\\OneDrive\\Ambiente de Trabalho\\EST\\IA\\Projecto_2019_2020_IA_P2_Entregue\\Projeto\\"))
    path
  )
)



(defun ficheiro-solucao ()
  (let ((path "C:\\Users\\joao2\\OneDrive\\Ambiente de Trabalho\\EST\\IA\\Projecto_2019_2020_IA_P2_Entregue\\Projeto\\log.dat"))
    path
  )
)


#|
---------------------------------------------------------- FUNCÕES CONFIGURACOES  ------------------------------------------------------------------
|# 

(defun configurar-tempo (tempo)
"Configuar o tempo limite de execução do Alfa-Beta"
(cond 
 ((or (< tempo 1000) (> tempo 5000) ) Nil)
 (t (setf *tempo-limite* tempo)))
	
)

(defun configurar-profundidade (profundidade)
"Configurar a profundidade máxima a que o algoritmo Alfa-Beta pode explorar a àrvore"
  (setf *profundidade-limite* profundidade)
)









#|
---------------------------------------------------------- Menus  ------------------------------------------------------------------
|# 


(defun menu-Load ()
  "0.0 Menu Boas Vindas"

  (progn
    (format t "~%~%~%~%~%~%~%~%~%~%~%~%~%~%~%~%~%~%~%~%"                                 )
    (loadingBar)
    (format t "~%           ______________________________________________________~%"    )
    (format t "~%                              W E L C O M E                ~%"          ) 
    (format t "~%                                    TO                           ~%~%"  )      
    (loading)
    (format t "~%                                                                 ~%"    ) 
    (format t "~%           ______________________________________________________~%"    ) 
    (loadingBar)
    (menu-principal)
    )
  )







(defun menu-principal ()
  "1.0 Menu principal com as opcões do programa"
  (loop
    (progn
      (format t "~%~%~%~%~%~%~%~%~%")
      (format t "~%           ______________________________________________________")
      (format t "~%          §                  JOGO DO CAVALO                      §")
      (format t "~%          §                   (Knight Game)                      §")
      (format t "~%          §                                                      §")
      (format t "~%          §                                                      §")
      (format t "~%          §                                                      §")
      (format t "~%          §                 1-Play                               §")
      (format t "~%          §                 2-Game Rules                         §")
      (format t "~%          §                 3-Settings                           §")
      (format t "~%          §                 4-Quit                               §")
      (format t "~%          §                                                      §")
      (format t "~%          §______________________________________________________§")

      (format t "~%~%~%          Option -> ")
      )
    (cond ((not (let ((escolha (read)))
               (cond 
                ((and (numberp escolha) (< escolha 5) (> escolha 0)) (case escolha
                                                    (1 (progn (game-modes (tabuleiro) ) t))
                                                    (2 (progn (menu-regras)  t))
                                                    (3 (progn (menu-Settings) nil))
                                                    (4 (progn (format t "~%~%~%          PROGRAMA TERMINADO") nil))))
                ( T (progn  (format t "~%          Invalid Choice~%~%          Option -> ")
                            (setf escolha (read))))))) 
(return)))))












(defun game-modes (tabuleiro)
  "1.1 Sub menu escolhe o modo de jogo após ter escolhido o tabuleiro"
  (loop
   (progn
     (format t "~%           ______________________________________________________")
     (format t "~%          §                                                      §")
     (format t "~%          §                      GAME MODES                      §")
     (format t "~%          §                                                      §")
     (format t "~%          §                                                      §")
     (format t "~%          §                 1- Human vs Human                    §")
     (format t "~%          §                 2- Human vs CPU                      §")
     (format t "~%          §                 3-  CPU  vs CPU                      §")
     (format t "~%          §                 0- Home Menu                         §")
     (format t "~%          §                                                      §")
     (format t "~%          §______________________________________________________§") 
     (format t "~%~%~%          Option -> ")
     )
   (cond ((not (let ((escolha (read))) 
                 (cond 
                  ((and (numberp escolha) (< escolha 4) (> escolha -1)) (case escolha
                                                                          (1 (progn (configurar-jogo tabuleiro 1)
                                                                                    (log-inicial tabuleiro 1)
                                                                              (humano-vs-humano  (configurar-Inicio-Jogo (configurar-tabuleiro tabuleiro)) *initial-player* )))

                                                                          (2  (progn (configurar-jogo tabuleiro 2)
                                                                                     (log-inicial tabuleiro 2)
                                                                              (human-vs-cpu  (configurar-Inicio-Jogo (configurar-tabuleiro tabuleiro)) *initial-player* *tempo-limite* )))

                                                                          (3 (progn  (configurar-jogo tabuleiro 3)
                                                                                     (log-inicial tabuleiro 3)
                                                                             (com-vs-com  (configurar-Inicio-Jogo (configurar-tabuleiro tabuleiro)) *initial-player* *tempo-limite* )) )

                                                                          (0 (progn  NIL))))
                  ( T (progn  (format t "~%          Invalid Choice~%~%          Option -> ")
                        (setf escolha (read)))))))
          (return)))))










(defun menu-regras ()
  "2.0-Menu regras com as regras do jogo"
  (format t "
________________________________________   GAME RULES   ________________________________________
                                          (Knight Game)  
                                          
     1- Esta versão do jogo consiste num tabuleiro com 10 linhas e 10 colunas (10X10)   
     2- Em que cada casa possui uma pontuação com valor entre 00 e 99 (Aleatório),
        sem repetição nas celulas do tabuleiro.                               
     3- O objectivo do jogo é acumular mais pontos que o adversário, usando um cavalo de xadrez.
        Cada jogador tem um cavalo da sua cor (branco ou preto).                        
     4- Todas as jogadas seguintes são efectuadas através de um movimento de cavalo
        (usando as regras tradicionais do Xadrez para o cavalo).
        Um cavalo não pode saltar para uma casa vazia (sem número)
        e também não pode fazê-lo para uma casa que esteja ameaçada pelo cavalo adversário.                                 
     5- O jogo termina quando não for possível movimentar qualquer um dos cavalos no tabuleiro,
        sendo o vencedor o jogador que ganhou mais pontos.           
                                                                                          
_________________________________________________________________________________________________
  ")
  )




(defun menu-Settings ()
"3.0- Menu para configurar o jogo"
(loop
    (progn
     (format t "~%           ______________________________________________________")
     (format t "~%          §                                                      §")
     (format t "~%          §                      SETTINGS                        §")
     (format t "~%          §                                                      §")
     (format t "~%          §                                                      §")
     (format t "~%          §                 1- Execution Time                    §")
     (format t "~%          §                 2- Initial Player                    §")
     (format t "~%          §                 0- Home Menu                         §")
     (format t "~%          §                                                      §")
     (format t "~%          §______________________________________________________§") 
     (format t "~%~%~%          Option -> ")
     )
    (cond ((not (let ((escolha (read)))
               (cond 
                ((and (numberp escolha) (< escolha 3) (> escolha -1)) (case escolha
                                                    (1 (progn (execution-time) nil))                                                  
                                                    (2 (progn (initial-player) nil))
                                                    (0 (progn (menu-principal) nil)))
                )
                ( T (progn  (format t "~%          Invalid Choice~%~%          Option -> ")
                            (setf escolha (read))
                            )))
               
               )) (return))
    )
  )
)




(defun execution-time()
"3.1- Menu para configurar o tempo de execução "
(loop
    (progn
     (format t "~%           ______________________________________________________")
     (format t "~%          §                                                      §")
     (format t "~%          §                     EXECUTION TIME                   §")
     (format t "~%          §                                                      §")
     (format t "~%          §                                                      §")
     (format t "~%          §                      [1000 - 5000]                   §")
     (format t "~%          §                                                      §")     
     (format t "~%          §                    0- Home Menu                      §")
     (format t "~%          §                                                      §")
     (format t "~%          §______________________________________________________§") 
     (format t "~%~%~%          Option -> ")
     )
    (cond ((not (let ((escolha (read)))
               (cond 
                ((and (numberp escolha) (< escolha 5001) (> escolha 999)) (progn (configurar-tempo escolha) (menu-principal) nil))
                ((and (numberp escolha) (= escolha 0) ) (progn (menu-principal)  nil)  )
                ( T (progn  (format t "~%          Invalid Choice~%~%          Option -> ")
                            (setf escolha (read))
                            )))
               
               )) (return)))))



(defun initial-player()
"3.2- Menu para configurar o tempo de execução "
(loop
    (progn
     (format t "~%           ______________________________________________________")
     (format t "~%          §                                                      §")
     (format t "~%          §                     Initial Player                   §")
     (format t "~%          §                                                      §")
     (format t "~%          §                                                      §")
     (format t "~%          §                     -1 (White)                       §")
     (format t "~%          §                     -2 (Black)                       §")
     (format t "~%          §                                                      §")     
     (format t "~%          §                    0- Home Menu                      §")
     (format t "~%          §                                                      §")
     (format t "~%          §______________________________________________________§") 
     (format t "~%~%~%          Option -> ")
     )
    (cond ((not (let ((escolha (read)))
               (cond 
                ((and (numberp escolha) (< escolha 1) (> escolha -3)) (case escolha
                                                    (-1 (progn (setf *initial-player* -1) (menu-principal) nil))
                                                    (-2 (progn (setf *initial-player* -2) (menu-principal) nil))
                                                    (0  (progn (setf *initial-player*  (- (random 2) 2 )) (menu-principal)  nil)))
                )
                ( T (progn  (format t "~%          Invalid Choice~%~%          Option -> ")
                            (setf escolha (read))
                            )))
               
               )) (return)))))












(defun configurar-jogo(tabuleiro tipo-jogo)

  (progn
    (format t "~%           ______________________________________________________~%")
    (format t "~%                               A Configurar                      ~%")
    (cond
     ((= tipo-jogo 1)  (format t "~%                               HUMAN VS HUMAN                      ~%"))
     ((= tipo-jogo 2)  (format t "~%                               HUMAN VS CPU                        ~%"))
     ((= tipo-jogo 3)  (format t "~%                               CPU VS CPU                          ~%"))
     (t                (format t "~%                                                                   ~%")))
    (print-board tabuleiro)
    (loadingBar)
    (format t "~%           _____________________ KNIGHT GAME ____________________~%")
    (format t "~%                                MATCH STARTED                    ~%")
   
    (print-board (no-estado-tabuleiro (configurar-tabuleiro tabuleiro)))
    ))


(defun vencedor ( no jogador)

  (progn
    (format t "~%           ______________________KNIGHT GAME_____________________~%")
    (format t "~%                                                                 ~%")
    (format t "~%                                                                 ~%")
    (loading-game-over)
    (format t "~%                                                                 ~%")
    (format t "~%                             VENCEDOR :  ~A                      ~%"(player jogador))
   
    (format t "~%                                                                 ~%")
    (format t "~%                     Pontos Jogador 1 ~A : ~A                    ~%"(player -1) (no-pontos no -1))
    (format t "~%                     Pontos Jogador 2 ~A : ~A                    ~%"(player -2) (no-pontos no -2))
    (format t "~%                                                                 ~%")
    (format t "~%                          ESTADO FINAL :                         ~%")
    (print-board (no-estado-tabuleiro no))
    (loadingBar)))

(defun player(jogador)
(cond
((= jogador -1)    '(White))
((= jogador -2)    '(Black))
(t '-)))


 
(defun passar-jogada(jogador)
  (progn
    (format t "~%                                   PASSOU A JOGADA~%"  jogador)
    (sleep 1)))


(defun game-status (no jogador round nos-analisados expanded-nodes nos-cortados nos-cortados-alfa nos-cortados-beta tab)

  (progn
    (format t "~%           ______________________________________________________~%")
    (format t "~%~%                                  ROUND ~@r ~%~%"                                 round)
    (format t "~%~%                          Points Player 1 (White): ~5,'0d ~%" (no-pontos no *jogador1*))
    (format t "~%~%                          Points Player 2 (Black): ~5,'0d ~%" (no-pontos no *jogador2*))
    (format t "~%~%                          Expanded Nodes: ~10,'0d ~%"          expanded-nodes          )
    (format t "~%~%                          Analyzed Nodes: ~10,'0d ~%"          nos-analisados          )
    (format t "~%~%                          Cut Nodes: ~10,'0d~%"                nos-cortados            )
    (format t "~%~%                          Cut Nodes-Alfa: ~10,'0d~%"                nos-cortados-alfa  )
    (format t "~%~%                          Cut Nodes-Beta: ~10,'0d~%"                nos-cortados-beta  )
    (format t "~%~%                          Player ~a~%~%"                               (player jogador))
    
    (print-board (no-estado-tabuleiro no))

    ))
















#|
----------------------------------------------------------  Game Modes  ------------------------------------------------------------------
|# 









;;Teste (com-vs-com (no-teste) *jogador1*  1000)
(defun com-vs-com (no jogador &optional tempoMax (jogador-max jogador) (round 1)  &aux (tab (no-estado-tabuleiro no))  )
"com-vs-com Alternadamente é chamado o algoritmo Alfa-Beta para cada jogador, neste caso -1 e -2"
      (cond 
        ((and (no-solucaop no jogador) (no-solucaop no (trocar-jogador jogador)))   
         (progn  
           (log-vencedor no (verificar-vencedor no jogador) ) 
           (vencedor no (verificar-vencedor no jogador)))) 
        ((no-solucaop no jogador)     
         (progn 
           (game-status no jogador round *analised-nodes* *expanded-nodes* *nos-cortados* *nos-cortados-alfa* *nos-cortados-beta*  tab)
           (log-jogada  no jogador       *analised-nodes* *expanded-nodes* *nos-cortados* *nos-cortados-alfa* *nos-cortados-beta* round )
           (passar-jogada jogador)
           (log-passar-jogada jogador)
           (com-vs-com no (trocar-jogador jogador) tempoMax jogador-max (+ round 1))))
        (t 
          (progn 
           (alfabeta-v2 no jogador    tempoMax 10000 ) 
           (game-status no jogador round *analised-nodes* *expanded-nodes* *nos-cortados* *nos-cortados-alfa* *nos-cortados-beta* tab)
           (log-jogada *jogada* jogador  *analised-nodes* *expanded-nodes* *nos-cortados* *nos-cortados-alfa* *nos-cortados-beta* round )
             (setf *analised-nodes* 0 )
             (setf *expanded-nodes* 0 )
             (setf *nos-cortados*   0 )
             (setf *nos-cortados-alfa* 0)
             (setf *nos-cortados-beta* 0)
           (com-vs-com *jogada* (trocar-jogador jogador) tempoMax jogador-max (+ round 1) )
          ))))




;;Teste (human-vs-cpu (no-teste) *jogador1*  1000)
(defun human-vs-cpu(no jogador &optional tempoMax  (jogador-max jogador) (round 1) &aux (tab (no-estado-tabuleiro no))  )
  " Humano vs CPU.É solicitado ao jogador 1 para jogar uma peça, e posteriormente o alfa-beta decide qual a melhor jogada para o computador e realiza a mesma"
  (cond 
   ((and (no-solucaop no jogador) (no-solucaop no (trocar-jogador jogador)))   
    (progn 
      (vencedor no     (verificar-vencedor no jogador))
      (log-vencedor no (verificar-vencedor no jogador))))
   ((no-solucaop no jogador)      
    (progn (game-status no jogador round *analised-nodes* *expanded-nodes* *nos-cortados* *nos-cortados-alfa* *nos-cortados-beta*  tab)
           (log-jogada  no jogador       *analised-nodes* *expanded-nodes* *nos-cortados* *nos-cortados-alfa* *nos-cortados-beta* round)
           (passar-jogada jogador) 
           (log-passar-jogada jogador)
           (human-vs-cpu no (trocar-jogador jogador) tempoMax jogador-max (+ round 1)  ) )) 
   ((no-maxp jogador jogador-max)
    ;;HUMANO
        
    (game-status no jogador round *analised-nodes* *expanded-nodes* *nos-cortados* *nos-cortados-alfa* *nos-cortados-beta*  tab)
    (log-jogada  no jogador       *analised-nodes* *expanded-nodes* *nos-cortados* *nos-cortados-alfa* *nos-cortados-beta* round)
    (human-vs-cpu (jogada-humano no jogador) (trocar-jogador jogador) tempoMax  jogador-max  (+ round 1) ))
                
   ;;CPU
   (t 
        (alfabeta-v2 no jogador    tempoMax 10000 )  
        (game-status *jogada* jogador round *analised-nodes* *expanded-nodes* *nos-cortados* *nos-cortados-alfa* *nos-cortados-beta*  tab)
        (log-jogada  *jogada* jogador       *analised-nodes* *expanded-nodes* *nos-cortados* *nos-cortados-alfa* *nos-cortados-beta* round )
         (setf *analised-nodes* 0 )
         (setf *expanded-nodes* 0 )
         (setf *nos-cortados*   0 )
         (setf *nos-cortados-alfa* 0)
         (setf *nos-cortados-beta* 0)
        (human-vs-cpu *jogada*  (trocar-jogador jogador) tempoMax jogador-max (+ round 1))
        )))










;;Teste (humano-vs-humano (no-teste) *jogador1* )
(defun humano-vs-humano (no jogador &optional   (jogador-max jogador) (round 1) &aux (tab (no-estado-tabuleiro no)))
  "Modo de jogo manual, é possível jogar humano contra humano"
    (cond 
        ((and (no-solucaop no jogador) (no-solucaop no (trocar-jogador jogador)))
         (progn 
         (vencedor no (verificar-vencedor no jogador))
         (log-vencedor no (verificar-vencedor no jogador) )))
        ((no-solucaop no jogador)      
         (progn 
           (game-status no jogador round 0 0 0 0 0 tab)
           (log-jogada  no jogador       0 0 0 0 0  round)
           (passar-jogada jogador)
           (log-passar-jogada jogador)
           (humano-vs-humano no (trocar-jogador jogador) jogador-max (+ round 1) ))) 
        (t 
         (progn 
          (game-status no jogador round 0 0 0 0 0 tab)
          (log-jogada  no jogador       0 0 0 0 0 round)
          (humano-vs-humano (jogada-humano no jogador) (trocar-jogador jogador) jogador-max (+ round 1))
          ))))






(defun jogada-humano (no jogador )
  (let ((sucessor ( novo-suc no (solicitar-operador jogador) jogador ) ))
    (cond 
     ((eq sucessor nil) (jogada-humano no jogador) )
     (t sucessor))))


(defun solicitar-operador(jogador)
  "Função para solicitar o Operador ao jogador"
  (format t "~%                             Jogador ~a~%"  (player jogador))
  (format t "~%                       - Por favor escolha um operador de 1 a 8~%"  )
  (format t "~%                       ->"  )
  (let ((column (read) )) 
    (cond  
     ((OR (not (numberp column))(< column 1) (> column 8) )  (format t "                          Jogada impossivel, volte a tentar ~%") (solicitar-operador  jogador))
     ( (= column 1) 'operador-1)
     ( (= column 2) 'operador-2)
     ( (= column 3) 'operador-3)
     ( (= column 4) 'operador-4)
     ( (= column 5) 'operador-5)
     ( (= column 6) 'operador-6)
     ( (= column 7) 'operador-7)
     ( (= column 8) 'operador-8)
     (T (format t "                          Jogada impossivel, volte a tentar ~%") (solicitar-operador  jogador) ))))
    
    









#|
----------------------------------------------------------  LOG  ------------------------------------------------------------------
|# 



(defun print-Line-file (linha str)
  (format str "~%             ")
  (mapcar (lambda (y) (format str "   ~3,'0D " y)) linha))

(defun print-board-file (tabuleiro str)
(cond 
((null tabuleiro) (format str ""))
(t (progn (print-Line-file (car tabuleiro) str) (format str "~%") (print-board-file (cdr tabuleiro) str) ))))



(defun log-inicial (tabuleiro tipo-jogo)

(progn
   (with-open-file (str (ficheiro-solucao)
        :direction :output
        :if-exists :append
        :if-does-not-exist :create)
    (format str "~%~%~%~%~%~%~%~%~%~%~%~%~%~%~%~%~%~%~%~%~%")
    (format str "~%           ______________________________________________________~%")
    (format str "~%                               A Configurar                      ~%")
    (cond
     ((= tipo-jogo 1)  (format str "~%                               HUMAN VS HUMAN                      ~%"))
     ((= tipo-jogo 2)  (format str "~%                               HUMAN VS CPU                        ~%"))
     ((= tipo-jogo 3)  (format str "~%                               CPU VS CPU                          ~%"))
     (t                (format str "~%                                                                   ~%")))
    (print-board-file tabuleiro str) 
    
    (format str "~%           _____________________ KNIGHT GAME ____________________~%")
    (format str "~%                                MATCH STARTED                    ~%")
   
    (print-board-file (no-estado-tabuleiro (configurar-tabuleiro tabuleiro)) str)
    )))


(defun log-passar-jogada(jogador)
  (progn
    (with-open-file (str (ficheiro-solucao)
        :direction :output
        :if-exists :append
        :if-does-not-exist :create)
    (format str "~%                                   PASSOU A JOGADA~%"  jogador))))


(defun log-jogada (no jogador nos-analisados expanded-nodes nos-cortados nos-cortados-alfa nos-cortados-beta round )
"Regista a jogada no ficheiro de texto a cada vez que o algoritmo Alfa-Beta é executado. 
  Regista o jogador que executou a chamada ao Alfa-Beta, o tabuleiro actual antes de ser efectuada a jogada
  E também a peça a retirar para executar a melhor jogada
"
 (progn 
    (with-open-file (str (ficheiro-solucao)
        :direction :output
        :if-exists :append
        :if-does-not-exist :create)
        
        
      
    (format str "~%           ______________________________________________________~%")
    (format str "~%~%                                  ROUND ~@r ~%~%"                                  round)
    (format str "~%~%                          ~A                              ~%"                (date-time))
    (format str "~%~%                          Points Player 1 (White): ~5,'0d ~%"  (no-pontos no *jogador1*))
    (format str "~%~%                          Points Player 2 (Black): ~5,'0d ~%"  (no-pontos no *jogador2*))
    (format str "~%~%                          Analyzed Nodes: ~10,'0d ~%"          nos-analisados          )
    (format str "~%~%                          Expanded Nodes: ~10,'0d ~%"          expanded-nodes          )
    (format str "~%~%                          Cut Nodes: ~10,'0d ~%"               nos-cortados            )
    (format str "~%~%                          Cut Nodes-Alfa: ~10,'0d~%"                nos-cortados-alfa  )
    (format str "~%~%                          Cut Nodes-Beta: ~10,'0d~%"                nos-cortados-beta  )
    (format str "~%~%                          Player ~a~%~%"                               (player jogador))
    (print-board-file (no-estado-tabuleiro no) str)
    

    )))




(defun log-vencedor ( no jogador)

  (progn
    (with-open-file (str (ficheiro-solucao)
        :direction :output
        :if-exists :append
        :if-does-not-exist :create)
    (format str "~%           ______________________KNIGHT GAME_____________________~%")
    (format str "~%                                                                 ~%")
    (format str "~%                                                                 ~%")
    
    (format str "~%                                                                 ~%")
    (format str "~%                             VENCEDOR :  ~A                      ~%"(player jogador))
   
    (format str "~%                                                                 ~%")
    (format str "~%                     Pontos Jogador 1 ~A : ~A                    ~%"(player -1) (no-pontos no -1))
    (format str "~%                     Pontos Jogador 2 ~A : ~A                    ~%"(player -2) (no-pontos no -2))
    (format str "~%                                                                 ~%")
    (format str "~%                          ESTADO FINAL :                         ~%")
    (print-board-file (no-estado-tabuleiro no) str)
   )))
























#|
_______________________________________________________  Auxiliares  _______________________________________________________
|# 




(defun print-Line (linha)
  "Imprime uma linha do tabuleiro formatada"
  (format t "~%             ")
  (mapcar (lambda (y) (format t " ~3,'0D " y)) linha))

(defun print-board (tabuleiro)
  "Imprime um tabuleiro formatad"
  (cond 
   ((null tabuleiro) (format nil ""))
   (t (progn (print-Line (car tabuleiro)) (format t "~%") (print-board (cdr tabuleiro)) ))))






(defun loading()
  (format t "                         ")
  (loop for x in '(K N I G H T " " G A M E  )
        do (format t " ~A" x) (SLEEP 0.25) )
  )

(defun loading-game-over()
  (format t "                           ")
  (loop for x in '(G A M E " " O V E R  )
        do (format t " ~A" x) (SLEEP 0.25) )
  )

(defun loadingBar()
  (format t "           ")
  (loop for x in '(_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _  )
        do (format t "~A" x) (SLEEP 0.030) )
  )





(defconstant *day-names*
  '("Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" "Sunday")
  ) 


(defun date-time()
"Retorna a Data e a hora Actual"
  (multiple-value-bind
      (second minute hour date month year day-of-week dst-p tz)
      (get-decoded-time)
    (format nil  " ~2,'0d:~2,'0d:~2,'0d of ~a, ~d/~2,'0d/~d (GMT~@d) "
            hour
            minute
            second
            (nth day-of-week *day-names*)
            month 
            date
            year
            (- tz))))


