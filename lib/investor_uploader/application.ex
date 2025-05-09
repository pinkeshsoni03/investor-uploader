defmodule InvestorUploader.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      InvestorUploaderWeb.Telemetry,
      InvestorUploader.Repo,
      {DNSCluster, query: Application.get_env(:investor_uploader, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: InvestorUploader.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: InvestorUploader.Finch},
      # Start a worker by calling: InvestorUploader.Worker.start_link(arg)
      # {InvestorUploader.Worker, arg},
      # Start to serve requests, typically the last entry
      InvestorUploaderWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InvestorUploader.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    InvestorUploaderWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
