(*** Fichier qui execute le programme ***)

(* Crée les tokens d'un fichier *)
let lexbuf = Lexing.from_channel stdin 

(* Création de l'arbre *)
let ast = Parser.programme Lexer.main lexbuf 

(* Interpretation de l'arbre *)
let _ = Turtle.as_turtle ast
