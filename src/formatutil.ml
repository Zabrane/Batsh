open Core.Std

let print_indent (out: out_channel) (indent: int) =
  output_string out (String.make indent ' ')

let print_statements
    (out: out_channel)
    (stmts: 'a list)
    ~(f: out_channel -> 'a -> indent:int -> unit)
    ~(indent: int) =
  let print_statement_indented out stmt = f out stmt ~indent in
  let num_stmts = List.length stmts in
  List.iteri stmts ~f: (fun i stmt ->
      print_statement_indented out stmt;
      if i < num_stmts - 1 then
        output_string out "\n"
    )

let print_separate_list
    (outx: out_channel)
    (elements: 'a list)
    ~(f: out_channel -> 'a -> unit)
    ~(separator: string) =
  let num_elements = List.length elements in
  List.iteri elements ~f: (fun i element ->
      f outx element;
      if i < num_elements - 1 then
        output_string outx separator
    )

let escaper = Staged.unstage (String.Escaping.escape_gen_exn
                                ~escapeworthy_map: [
                                  ('\n', 'n');
                                  ('\r', 'r');
                                  ('\"', '"')]
                                ~escape_char: '\\'
                             )

let escape (str: string) :string =
  escaper str