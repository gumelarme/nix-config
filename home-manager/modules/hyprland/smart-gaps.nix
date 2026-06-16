_: {
  workspace_rule = [
    {
      workspace = "w[tv1]s[false]";
      gaps_out = 0;
      gaps_in = 0;
    }
    {
      workspace = "f[1]s[false]";
      gaps_out = 0;
      gaps_in = 0;
    }
  ];

  window_rule = [
    {
      match = {
        float = false;
        workspace = "w[tv1]";
      };
      border_size = 0;
    }
    {
      match = {
        float = false;
        workspace = "w[tv1]";
      };
      rounding = 0;
    }
    {
      match = {
        float = false;
        workspace = "f[1]";
      };
      border_size = 0;
    }
    {
      match = {
        float = false;
        workspace = "f[1]";
      };
      rounding = 0;
    }
  ];
}
