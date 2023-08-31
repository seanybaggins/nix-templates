{
  description = "Seans's flake templates";

  outputs = { self, ... }: {
    templates = {
      default = {
        path = ./default;
        description = "A good starting flake";
      };
    };
  };
}
