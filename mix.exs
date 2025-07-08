defmodule TaskManagement.MixProject do
  use Mix.Project

  def project do
    [
      app: :task_management,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TaskManagement.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug_cowboy, "~> 2.6"},
      {:jason, "~> 1.4"},
      {:ecto_sql, "~> 3.11"},
      {:myxql, "~> 0.6"},
      {:jose, "~> 1.11"}
  ]
  end
end
