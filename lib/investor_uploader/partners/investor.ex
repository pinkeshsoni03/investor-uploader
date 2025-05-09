defmodule InvestorUploader.Partners.Investor do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "investors" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :dob, :date
    field :phone, :string
    field :street_address, :string
    field :state, :string
    field :zip_code, :string

    has_many :documents, InvestorUploader.Partners.Document

    timestamps()
  end

  @states [
    {"AL", "Alabama"},
    {"AK", "Alaska"},
    {"AZ", "Arizona"},
    {"AR", "Arkansas"},
    {"CA", "California"},
    {"CO", "Colorado"},
    {"CT", "Connecticut"},
    {"DE", "Delaware"},
    {"FL", "Florida"},
    {"GA", "Georgia"},
    {"HI", "Hawaii"},
    {"ID", "Idaho"},
    {"IL", "Illinois"},
    {"IN", "Indiana"},
    {"IA", "Iowa"},
    {"KS", "Kansas"},
    {"KY", "Kentucky"},
    {"LA", "Louisiana"},
    {"ME", "Maine"},
    {"MD", "Maryland"},
    {"MA", "Massachusetts"},
    {"MI", "Michigan"},
    {"MN", "Minnesota"},
    {"MS", "Mississippi"},
    {"MO", "Missouri"},
    {"MT", "Montana"},
    {"NE", "Nebraska"},
    {"NV", "Nevada"},
    {"NH", "New Hampshire"},
    {"NJ", "New Jersey"},
    {"NM", "New Mexico"},
    {"NY", "New York"},
    {"NC", "North Carolina"},
    {"ND", "North Dakota"},
    {"OH", "Ohio"},
    {"OK", "Oklahoma"},
    {"OR", "Oregon"},
    {"PA", "Pennsylvania"},
    {"RI", "Rhode Island"},
    {"SC", "South Carolina"},
    {"SD", "South Dakota"},
    {"TN", "Tennessee"},
    {"TX", "Texas"},
    {"UT", "Utah"},
    {"VT", "Vermont"},
    {"VA", "Virginia"},
    {"WA", "Washington"},
    {"WV", "West Virginia"},
    {"WI", "Wisconsin"},
    {"WY", "Wyoming"}
  ]

  @doc """
  Return the list of `{abbr, name}` for a dropdown.
  """
  def states, do: @states

  @required ~w(first_name last_name email dob phone street_address state zip_code)a
  def changeset(investor, attrs) do
    investor
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> validate_format(:email, ~r/^[\w.!#$%&'*+\/=?^`{|}~-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/)
    |> validate_inclusion(:state, Enum.map(@states, &elem(&1, 1)))
    |> validate_length(:zip_code, is: 5)
    |> validate_format(:zip_code, ~r/^\d{5}$/)
    |> validate_format(:phone, ~r/^\d{10}$/)
    |> unique_constraint(:email)
  end
end
