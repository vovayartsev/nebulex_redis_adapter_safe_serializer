defmodule NebulexRedisAdapterSafeSerializer.MixProject do
  use Mix.Project

  def project do
    [
      app: :nebulex_redis_adapter_safe_serializer,
      version: "0.1.0",
      elixir: "~> 1.12",
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:nebulex_redis_adapter, ">= 0.0.0"},
      {:plug_crypto, ">= 1.1.0"}
    ]
  end
end
