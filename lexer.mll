{
(*** Fichier qui crée les tokens ***)
open Parser
}

let layout = [ ' ' '\t' '\n' ]
let ident_char = ['a'-'z']['a'-'z''A'-'Z''0'-'9']*
let ident_int = ['1'-'9']['0'-'9']*|'0'

rule main = parse
  | layout  { main lexbuf }
  | "Var" { VAR }
  | ";" { VIRGULE }
  | "Debut" { DEBUT }
  | "=" { EGALE }
  | "*" { FOIS }
  | "/" { DIVISE }
  | "+" { PLUS }
  | "-" { MOINS }
  | "(" { POUVERT }
  | ")" { PFERMER }
  | "BasPinceau"  { BASPINCEAU }
  | "HautPinceau" { HAUTPINCEAU }
  | "ChangeCouleur" { CHANGECOULEUR }
  | "ChangeEpaisseur" {CHANGEEPAISSEUR }
  | "Avance"  { AVANCE }
  | "Tourne"  { TOURNE }
  | "Si"  { SI }
  | "Alors" { ALORS }
  | "Sinon" { SINON }
  | "Tant que"  { TANTQUE }
  | "Faire" { FAIRE }
  | "Fin" { FIN }
  | ident_char  { ID (Lexing.lexeme lexbuf) }
  | ident_int { NB (int_of_string(Lexing.lexeme lexbuf)) }
  | eof			{ EOF }
  | _			{ failwith ("unexpected character " ^ Lexing.lexeme lexbuf)}
