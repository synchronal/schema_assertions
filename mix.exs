defmodule SchemaAssertions.MixProject do
  use Mix.Project

  @scm_url "https://github.com/synchronal/schema_assertions"

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def project do
    [
      aliases: aliases(),
      app: :schema_assertions,
      deps: deps(),
      description: "ExUnit assertions for Ecto schemas",
      dialyzer: dialyzer(),
      docs: docs(),
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      homepage_url: @scm_url,
      name: "Schema Assertions",
      package: package(),
      preferred_cli_env: [credo: :test],
      source_url: @scm_url,
      start_permanent: Mix.env() == :prod,
      version: version()
    ]
  end

  # # #

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:ecto_sql, "~> 3.0", optional: true},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:mix_audit, "~> 1.0", only: :dev, runtime: false},
      {:postgrex, ">= 0.0.0", only: :test}
    ]
  end

  defp dialyzer do
    [
      plt_add_apps: [:ecto, :ex_unit, :mix],
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

  defp package do
    [
      files: ~w[
        .formatter.exs
        README.*
        VERSION
        lib
        license.*
        mix.exs
      ],
      licenses: ["MIT"],
      links: %{"GitHub" => @scm_url},
      maintainers: ["synchronal.dev", "Erik Hanson", "Eric Saxby"]
    ]
  end

  defp version do
    case Path.expand(Path.join([__ENV__.file, "..", "VERSION"])) |> File.read() do
      {:error, _} -> "0.0.0"
      {:ok, version_number} -> version_number |> String.trim()
    end
  end
end
