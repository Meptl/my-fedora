pkgs:

{
  vim-textobj-line = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-textobj-line";
    name = "vim-textobj-line";
    src = pkgs.fetchFromGitHub {
      owner = "kana";
      repo = "vim-textobj-line";
      rev = "0.0.2";
      sha256 = "0mppgcmb83wpvn33vadk0wq6w6pg9cq37818d1alk6ka0fdj7ack";
    };
  };

  vim-schlepp = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-schlepp";
    name = "vim-schlepp";
    src = pkgs.fetchFromGitHub {
      owner = "zirrostig";
      repo = "vim-schlepp";
      rev = "master";
      sha256 = "0wd1149k1ryfs97mffhyxm4fdhbfw4xdw23v6i5kc8j8nfy0gnil";
    };
  };

  vim-godot = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-godot";
    name = "vim-godot";
    src = pkgs.fetchFromGitHub {
      owner = "habamax";
      repo = "vim-godot";
      rev = "master";
      sha256 = "sha256-FvV91kQKYgBKXzXPKvPnX3TWlx1DlostOT6qaWSZ1F8=";
    };
  };

  llm-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "llm-nvim";
    name = "llm-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "huggingface";
      repo = "llm.nvim";
      rev = "master";
      sha256 = "sha256-iPRIjlPk4eoFHlGmLnvmFA8DMTxoCPoY/GqswxGa+oQ=";
    };
  };

  codeium = pkgs.vimUtils.buildVimPlugin {
    pname = "codeium";
    name = "codeium";
    src = pkgs.fetchFromGitHub {
      owner = "Exafunction";
      repo = "codeium.vim";
      rev = "master";
      sha256 = "sha256-CzQ+fB7j6vSHqtObkBHlYB7TtK/I5CpKmh8pUPDalh0=";
    };
  };
}
