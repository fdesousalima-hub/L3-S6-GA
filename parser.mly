%{
(*** Fichier qui crée l'arbre grammatical ***)
open Ast
%}

%token VAR VIRGULE DEBUT EGALE FOIS DIVISE PLUS MOINS POUVERT PFERMER BASPINCEAU HAUTPINCEAU CHANGECOULEUR CHANGEEPAISSEUR AVANCE TOURNE SI ALORS SINON TANTQUE FAIRE FIN EOF
%token<string> ID 
%token<int> NB 

%start<Ast.programme> programme

%%


programme: 
    | d=declarations i=instruction EOF { Prog (d,i) }

declarations:
    | VAR i=ID VIRGULE  d=declarations { Decla (i, d) }
    | { ED }

instruction:
    | AVANCE e=expression { Avance (e) }
    | TOURNE e=expression { Tourne (e) }
    | SI e=expression ALORS POUVERT i=instruction PFERMER is=instructionSuite { Si (e,i,is) }
    | TANTQUE e=expression FAIRE i=instruction { Tantque (e,i) }
    | BASPINCEAU { BasPinceau }
    | HAUTPINCEAU { HautPinceau }
    | CHANGECOULEUR i=ID { Changecouleur (i) }
    | CHANGEEPAISSEUR e=expression { Changeepaisseur (e) }
    | i= ID EGALE e=expression { IdentificateurI (i,e) }
    | DEBUT b=blocInstruction FIN { Bloc (b) }

instructionSuite: 
    | SINON ix=instruction { Sinon (ix) }
    | { EIS }

blocInstruction:
    | i=instruction VIRGULE b=blocInstruction { BlocI (i,b) }
    | { EBI }

expression:
    | n=NB e=expressionSuite { Nombre (n,e) }
    | MOINS e=expression { NombreMoins (e) }
    | i=ID e=expressionSuite { Identificateur (i,e) }
    | POUVERT e=expression PFERMER x=expressionSuite { Suite (e,x) }

expressionSuite:
    | FOIS e=expression { Fois (e) }
    | DIVISE e=expression { Divise (e) }
    | PLUS e=expression { Plus (e) }
    | MOINS e=expression { Moins (e) }
    | { EES }
