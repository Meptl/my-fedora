{ pkgs, ... }:

with builtins;
let
  readVimConfig = f: if pkgs.lib.hasSuffix ".lua" f
                     then "lua << EOF\n${builtins.readFile f}\nEOF"
                     else builtins.readFile f;
  # Read all files in a dir into a single vimrc file.
  readConfigDir = dir: concatStringsSep "\n" (map (rc: readVimConfig (toPath "${dir}/${rc}")) (attrNames (readDir dir)));

  # Concat all the files in this folder.
  baseRC = readConfigDir ./configs/rc;

  # Seems writeTextDir doesn't support paths as the name suggests (because writeTextFile.name cannot have "/")
  colorscheme = pkgs.writeTextFile {
    name = "vimcolorscheme";
    text = builtins.readFile (./configs + "/myparamount.vim");
    destination = "/colors/myparamount.vim";
  };
in
{
  enable = true;
  extraPackages = with pkgs; [
    ripgrep
    home-manager

    # Not part of lazy-lsp-nvim
    nixd
    openscad-lsp
  ];
  extraConfig = ''
    ${baseRC}
    let &runtimepath.=',${colorscheme}'
    colorscheme myparamount
  '';
  plugins = let
    myPlugins = (import ./vimPrivatePlugins.nix) pkgs;
  in
  with pkgs.vimPlugins; [
    markdown-preview-nvim

    vim-textobj-user  # Other textobj classes need this.
    myPlugins.vim-textobj-line
    vim-textobj-entire
    # vim-indent-object

    ReplaceWithRegister
    commentary
    fugitive
    fzf-vim
    fzfWrapper
    polyglot
    repeat  # Enhances . command.
    surround
    hier  # Highlight quickfix errors.
    undotree
    vim-abolish  # Abbrevs and substitutions. Case coercion.
    vim-css-color  # Highlights hex colors.
    vim-swap
    vim-unimpaired  # I just use this for the ]q [q quickfix bindings.
    vim-sort-motion
    vim-smoothie  # Smooth scrolling
    vim-sneak  # f but with two characters
    vim-endwise
    myPlugins.vim-schlepp
    vim-gitgutter
    vim-highlightedyank
    vim-localvimrc

    vim-visual-increment
    increment-activator  # You really have to be under "true" to make it behave...

    nvim-lspconfig
    cmp-nvim-lsp
    nvim-cmp
    luasnip
    cmp_luasnip
    cmp-buffer
    cmp-path
    cmp-cmdline
    # lazy-lsp-nvim # Lazy load the lsp servers

    nvim-ts-context-commentstring
    nvim-treesitter.withAllGrammars

    myPlugins.codeium
    myPlugins.vim-godot
  ];
  viAlias = true;
  vimAlias = true;
}
