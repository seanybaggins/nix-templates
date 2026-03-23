{
  readVersionFromFile =
    filePath:
    let
      raw = builtins.readFile filePath;
      cleaned = builtins.replaceStrings [ "\n" ] [ "" ] raw;
    in
    cleaned;
}
