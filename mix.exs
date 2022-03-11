defmodule SchemaAssertions.MixProject do
  use Mix.Project

  def project do
    [
      app: :schema_assertions,
      deps: deps(),
      description: "ExUnit assertions for Ecto schemas",
      dialyzer: dialyzer(),
      docs: docs(),
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      name: "Schema Assertions",
      start_permanent: Mix.env() == :prod,
      version: version()
    ]
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
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ecto, "~> 3.0", optional: true},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:ex_unit, :mix],
      plt_add_deps: :app_tree,
      plt_file: {:no_warn, "priv/plts/dialyzer.plt"}
    ]
  end

  defp docs do
    [
      main: "SchemaAssertions",
      extras: ["README.md", "license.txt"]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp version do
    case File.read("VERSION") do
      {:error, _} -> "0.0.0"
      {:ok, version_number} -> version_number |> String.trim()
    end
  end
end
