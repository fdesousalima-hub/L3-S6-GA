(*** Fichier qui définit l'arbre grammatical ***)

(* Définition du programme *)
type programme = 
  | Prog of declaration * instruction

(* Définition des déclarations *)
and declaration = 
  | Decla of string * declaration
  | ED

(* Définition des instructions *)
and instruction =
  | Avance of expression
  | Tourne of expression
  | Si of expression * instruction * instructionSuite
  | Tantque of expression * instruction
  | Changecouleur of string
  | Changeepaisseur of expression
  | BasPinceau
  | HautPinceau
  | IdentificateurI of string * expression 
  | Bloc of blocInstruction 

(* Définition des instructions suite (Pour Sinon) *)
and instructionSuite =
  | Sinon of instruction
  | EIS

(* Définition des blocs d'instructions *)
and blocInstruction = 
  | BlocI of instruction * blocInstruction
  | EBI

(* Définition des expressions *)
and expression =
  | Nombre of int * expressionSuite
  | NombreMoins of expression
  | Identificateur of string * expressionSuite
  | Suite of expression * expressionSuite

(* Définition des opérations des expressions *)
and expressionSuite = 
  | Fois of expression
  | Divise of expression
  | Plus of expression
  | Moins of expression
  | EES

(*** Transformation de l'arbre en string ***)

(* Transformation des declarations en string *)
let rec declarations_string = function
  | Decla(v,d) -> "Decla " ^ v ^ ";\n" ^ declarations_string d
  | ED -> ""

(* Transformation des operations des expressions en string *)
and expressionSuite_string = function
  | Fois e -> " * " ^ expression_string e
  | Divise e -> " / " ^ expression_string e
  | Plus e -> " + " ^ expression_string e
  | Moins e -> " - " ^ expression_string e
  | EES -> ""

(* Transformation des expressions en string *)
and expression_string = function
  | Nombre(nb,es) -> string_of_int nb ^ expressionSuite_string es
  | NombreMoins(e) -> " -" ^ expression_string e
  | Identificateur(id,es) -> id ^ expressionSuite_string es
  | Suite(e,es) -> " ( " ^ expression_string e ^ " ) " ^ expressionSuite_string es
  
(* Transformation des blocs d'instructions en string *)
and block_string = function
  | BlocI(i,b) -> instruction_string i ^ ";\n" ^ block_string b
  | EBI -> ""

(* Transformation des instructions en string *)
and instruction_string = function
  | Avance a -> "Avance " ^ expression_string a
  | Tourne t -> "Tourne " ^ expression_string t
  | Si (e,i,is) -> "Si " ^ expression_string e ^ " Alors (" ^ instruction_string i ^ ") " ^ instructionSuite_string is
  | Tantque (e,i) -> "Tantque " ^ expression_string e ^ " Faire " ^ instruction_string i
  | BasPinceau -> "BasPinceau"
  | HautPinceau -> "HautPinceau"
  | Changecouleur s -> "Changecouleur to " ^ s
  | Changeepaisseur e -> "Changeepaisseur to " ^ expression_string e
  | IdentificateurI(i,e) ->  i ^ " " ^ expression_string e
  | Bloc b ->  "Debut \n" ^ block_string b ^ "Fin"

(* Transformation des instructions suite en string *)
and instructionSuite_string = function
  | Sinon (i) -> "Sinon " ^ instruction_string i
  | EIS-> ""

(* Transformation du programme en string *)
let rec as_string = function
  | Prog(d,i) -> (declarations_string d) ^ (instruction_string i)