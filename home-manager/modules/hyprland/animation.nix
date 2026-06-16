_: {
  curve = [
    {
      _args = [
        "rubber"
        {
          type = "spring";
          mass = 1;
          stiffness = 70;
          dampening = 10;
        }
      ];
    }
  ];

  animation = [
    {
      leaf = "windows";
      enabled = true;
      speed = 1;
      spring = "rubber";
    }
    {
      leaf = "workspaces";
      enabled = true;
      speed = 6;
      spring = "default";
    }
  ];
}
