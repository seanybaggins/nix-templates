{
  description = "Seans's flake templates";

  outputs = { self, ... }: {
    templates = {
      default = {
        path = ./default;
      };
    };
  };
}
