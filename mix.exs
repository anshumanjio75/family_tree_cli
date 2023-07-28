defmodule FamilyTree.MixProject do
  use Mix.Project

  def project do
    [
      app: :"family-tree",
      version: "0.1.0",
      elixir: "~> 1.14",
      escript: [main_module: FamilyTree.CLI],
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      xref: [exclude: [FamilyTree.CLIInputs, FamilyTree.Storage]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: [:memento],
      extra_applications: [:logger, :ex_cli]
      # mod: {FamilyTree.Storage, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_cli, "~> 0.1.0"},
      {:memento, "~> 0.3.2"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
