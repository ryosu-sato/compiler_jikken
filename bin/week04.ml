open Util
open Config
open Assignment
open Check

let init () =
  exec
    [change_directory Dir.tmp;
     clone Group;
     find_compiler_directory Group;
     build Group;
     check_compiler_exists Group]
  |> Option.to_list

let output_of file =
  let name = file.name in
  [Format.sprintf "test/%s.out" name;
   Format.sprintf "test/%s.err" name]

let toi2 () =
  let dir = !!Dir.archive ^ "/test" in
  FileUtil.mkdir ~parent:true dir;
  let files =
    [{name = "tuple"; content = Raw Testcases.tuple}]
  in
  let check file () =
    let output = output_of file in
    let exts = ["before_flatten"; "after_flatten"] in
    let check ext () =
      let filename = Printf.sprintf "%s/%s.%s" dir file.name ext in
      if Sys.file_exists filename then
        None
      else
        Some (Output_not_found ("*." ^ ext))
    in
    match run_compiler ~dir ~output file () with
    | None -> map check exts ()
    | Some e -> [e]
  in
  concat_map check files ()

let toi3 () =
  let dir = !!Dir.archive ^ "/test" in
  FileUtil.mkdir ~parent:true dir;
  let files =
    [{name = "tuple2"; content = Raw Testcases.tuple2}]
  in
  let check file () =
    let output = output_of file in
    let exts = ["before_TACE"; "after_TACE"] in
    let check ext () =
      let filename = Printf.sprintf "%s/%s.%s" dir file.name ext in
      if Sys.file_exists filename then
        None
      else
        Some (Output_not_found ("*." ^ ext))
    in
    match run_compiler ~dir ~output file () with
    | None -> map check exts ()
    | Some e -> [e]
  in
  concat_map check files ()

let assignments : t =
  {init;
   check_commit_files = true;
   items =
     [2, Group, toi2;
      3, Group, toi3]}
