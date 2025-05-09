defmodule InvestorUploader.Repo.Migrations.CreateInvestorsAndDocuments do
  use Ecto.Migration

  def change do
    create table(:investors, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :string, null: false
      add :dob, :date, null: false
      add :phone, :string, null: false
      add :street_address, :string, null: false
      add :state, :string, null: false
      add :zip_code, :string, null: false

      timestamps()
    end

    create unique_index(:investors, [:email])
    create index(:investors, [:state])

    create table(:documents, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :investor_id, references(:investors, type: :binary_id, on_delete: :delete_all),
        null: false

      add :filename, :string, null: false
      add :path, :string, null: false

      timestamps()
    end

    create index(:documents, [:investor_id])
  end
end
