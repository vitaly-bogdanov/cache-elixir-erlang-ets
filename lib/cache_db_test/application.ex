defmodule CacheDbTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      CacheDbTest.Repo,
      # Start the Telemetry supervisor
      CacheDbTestWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: CacheDbTest.PubSub},
      # Start the Endpoint (http/https)
      CacheDbTestWeb.Endpoint,
      # Start a worker by calling: CacheDbTest.Worker.start_link(arg)
      # {CacheDbTest.Worker, arg}
      {CacheDbTest.Cache, [name: CampCache]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CacheDbTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CacheDbTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
