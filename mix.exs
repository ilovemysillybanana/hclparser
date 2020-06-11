defmodule HCLParser.MixProject do
  use Mix.Project

  def project do
    [
      app: :hclparser,
      version: "0.1.0",
      elixir: "~> 1.10",
      description: description(), 
      package: package(),
      source_url: "https://github.com/ilovemysillybanana/hclparser",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp package do
    [
      name: "hclparser",
      licenses: ["GPL-2.0-or-later"],
      links: %{"GitHub" => "https://github.com/ilovemysillybanana/hclparser"}
    ]
  end

  defp description do
    "A package to read Terraform 0.12.0 into an elixir manageable data structure."
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
