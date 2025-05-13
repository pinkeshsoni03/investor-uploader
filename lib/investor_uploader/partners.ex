defmodule InvestorUploader.Partners do
  @moduledoc "The Partners context."

  import Ecto.Query, warn: false
  alias InvestorUploader.Repo
  alias InvestorUploader.Partners.{Investor, Document}

  ## Investors

  def list_investors(params) do
    Investor
    |> order_by([i], desc: i.inserted_at)
    |> Repo.paginate(params)
  end

  def get_investor!(id) do
    Repo.get!(Investor, id)
    |> Repo.preload(:documents)
  end

  def create_investor(attrs \\ %{}) do
    %Investor{}
    |> Investor.changeset(attrs)
    |> Repo.insert()
  end

  def change_investor(%Investor{} = investor, attrs \\ %{}) do
    Investor.changeset(investor, attrs)
  end

  ## Documents

  def create_document(attrs \\ %{}) do
    %Document{}
    |> Document.changeset(attrs)
    |> Repo.insert()
  end

  def list_documents_for_investor(investor_id) do
    Document
    |> where(investor_id: ^investor_id)
    |> Repo.all()
  end
end
