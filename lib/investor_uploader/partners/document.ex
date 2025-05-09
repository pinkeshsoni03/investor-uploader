defmodule InvestorUploader.Partners.Document do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "documents" do
    field :filename, :string
    field :path, :string

    belongs_to :investor, InvestorUploader.Partners.Investor, type: :binary_id

    timestamps()
  end

  @required ~w(investor_id filename path)a
  def changeset(document, attrs) do
    document
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> assoc_constraint(:investor)
  end
end
