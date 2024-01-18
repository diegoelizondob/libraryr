defmodule Libraryr.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LibraryrWeb.Telemetry,
      Libraryr.Repo,
      {DNSCluster, query: Application.get_env(:libraryr, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Libraryr.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Libraryr.Finch},
      # Start a worker by calling: Libraryr.Worker.start_link(arg)
      # {Libraryr.Worker, arg},
      # Start to serve requests, typically the last entry
      LibraryrWeb.Endpoint,
      {Absinthe.Subscription, LibraryrWeb.Endpoint}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Libraryr.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LibraryrWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
