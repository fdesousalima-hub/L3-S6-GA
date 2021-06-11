(*** Fichier qui interprète l'arbre grammatical ***)
open Graphics
open Ast

(* Position *)
type position = {
  x: float;      (** position x *)
  y: float;      (** position y *)
  a: int;        (** angle of the direction *)
}

(* Position sur le graph *)
let current_position = ref {x = 0.0; y = 0.0; a = 90}

(* Transformation position en string *)
let position_tostring position =
  "x:" ^ Float.to_string (position.x) ^
  " y:" ^ Float.to_string (position.y) ^
  " a:" ^ Int.to_string (position.a) ^ "\n"

(* Affiche la position dans le graph *)
let print_current () =
  Printf.printf "%s" (position_tostring !current_position)

(* Verifie si la position est dehors du graph *)
let checkCuseurNotValid () =
  (Float.to_int !(current_position).x) < 0 || (Float.to_int !(current_position).x) > size_x ()
  || (Float.to_int !(current_position).y) < 0 || (Float.to_int !(current_position).y) > size_y ()

(* Map qui stock les déclarations *)
module Declara = Map.Make(String);;
let declaration_map = ref Declara.empty

(* Boolean pour savoir s'il faut dessiner *)
let drawing = ref false

(* Boolean pour savoir s'il faut dessiner *)
let printMap m =
  Declara.iter (fun key value -> Printf.printf "%s -> %d\n" key value) m;;

(* Récuper une variable dans les declarations ou fait une erreur *)
let findMap m =
  match (Declara.find_opt m !declaration_map) with
    |None -> Printf.printf "Var is not declared!\n"; exit 0
    |Some e -> e

(* Fait une erreur si la variable n'existe pas  *)
let existMap m =
  match (Declara.find_opt m !declaration_map) with
    |None -> Printf.printf "Var is not declared!\n"; exit 0
    |Some e -> ()
    
(* Change la position dans le graph en fonction d'une distance *)
let calcNewPos size =
  (current_position) := { x = !(current_position).x +. Float.of_int size *. cos ((Float.of_int !(current_position).a) *. Float.pi /. 180.0);
                          y = !(current_position).y +. Float.of_int size *. sin ((Float.of_int !(current_position).a) *. Float.pi /. 180.0);
                          a = !(current_position).a}

(* Change l'angle de la position actuelle *)
let turn angle =
  (current_position) := {x = !(current_position).x;
  y = !(current_position).y;
  a = (!(current_position).a + angle) mod 360}

(* Récupere une couleurs en fonction d'un string *)
let get_color s =
  match s with
  | "blanc" -> white
  | "noir" -> black
  | "rouge" -> red
  | "vert" -> green
  | "bleu" -> blue
  | "jaune" -> yellow
  | "cyan" -> cyan
  | "magenta" -> magenta
  | _ -> (Printf.printf "Color chose not valid! (Valid: \"blanc\" \"noir\" \"rouge\" \"vert\" \"bleu\" \"jaune\" \"cyan\" \"magenta\" \n"; exit 0)

(* Intèrprete les déclarations *)
let rec declarations_turtle = function
| Decla (v,d) -> declaration_map := Declara.add v 0 !declaration_map; declarations_turtle d
| ED -> ()

(* Intèrprete les opérations d'une expressions *)
and expressionSuite_turtle nb = function
| Fois e -> nb * expression_turtle e
| Divise e -> let ex = expression_turtle e in if ex !=0 then nb / ex else (Printf.printf "Division by 0!\n"; exit 0)
| Plus e -> nb + expression_turtle e
| Moins e -> nb - expression_turtle e
| EES -> nb

(* Intèrprete les expréssions *)
and expression_turtle = function
| Nombre(nb,es) -> expressionSuite_turtle nb es
| NombreMoins(e) -> - (expression_turtle e)
| Identificateur(id,es) -> expressionSuite_turtle (findMap id) es;
| Suite(e,es) -> expressionSuite_turtle (expression_turtle e) es

(* Intèrprete les blocs des instructions *)
and block_turtle = function
| BlocI(i,b) -> instruction_turtle i; block_turtle b;
| EBI -> ()

(* Intèrprete les instructions *)
and instruction_turtle = function
| Avance a -> calcNewPos (expression_turtle a);
        if (not (checkCuseurNotValid ())) then (
          if (!drawing) then lineto (Float.to_int !(current_position).x) (Float.to_int !(current_position).y )
          else moveto (Float.to_int !(current_position).x) (Float.to_int !(current_position).y))
        else (
          Printf.printf "Cusor is out of screen!\n";
          print_current ();
          exit 0;
          )
| Tourne t -> turn (expression_turtle t)
| Si (e,i,is) -> if (not ((expression_turtle e) = 0)) then instruction_turtle i else instructionSuite_turtle is
| Tantque (e,i) -> while (not ((expression_turtle e) = 0)) do instruction_turtle i done
| BasPinceau -> drawing := true
| HautPinceau -> drawing := false
| Changecouleur s -> set_color (get_color s)
| Changeepaisseur e -> set_line_width (expression_turtle e)
| IdentificateurI(i,e) -> (existMap i); (declaration_map) := (Declara.add i (expression_turtle e) !declaration_map)
| Bloc b ->  block_turtle b

(* Intèrprete les instructions qui suivent *)
and instructionSuite_turtle = function
  | Sinon (i) -> instruction_turtle i; ()
  | EIS -> ()

(* Intèrprete l'arbre *)
let rec as_turtle = function
| Prog(d,i) -> open_graph " 1000x1000";
              auto_synchronize true;
              clear_graph ();
              declarations_turtle d;
              instruction_turtle i; 
              ignore (wait_next_event [Button_down])

