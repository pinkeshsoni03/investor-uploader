defmodule InvestorUploader.PartnersTest do
  use InvestorUploader.DataCase, async: true

  alias InvestorUploader.Partners
  alias InvestorUploader.Partners.{Investor, Document}

  @valid_investor_attrs %{
    first_name: "John",
    last_name: "Doe",
    email: "john.doe@example.com",
    dob: ~D[1985-10-20],
    phone: "1234567890",
    street_address: "123 Main St",
    state: "New York",
    zip_code: "10001"
  }
  @invalid_investor_attrs %{}
  @bad_email_attrs Map.put(@valid_investor_attrs, :email, "not-an-email")
  @bad_phone_attrs Map.put(@valid_investor_attrs, :phone, "12345")
  @bad_zip_attrs Map.put(@valid_investor_attrs, :zip_code, "ABCDE")
  @bad_state_attrs Map.put(@valid_investor_attrs, :state, "InvalidState")

  describe "investors" do
    test "list_investors/0 returns all investors" do
      {:ok, investor} = Partners.create_investor(@valid_investor_attrs)
      assert [^investor] = Partners.list_investors()
    end

    test "get_investor!/1 returns the investor with documents preloaded" do
      {:ok, investor} = Partners.create_investor(@valid_investor_attrs)
      {:ok, doc} =
        Partners.create_document(%{
          investor_id: investor.id,
          filename: "file.pdf",
          path: "/tmp/file.pdf"
        })

      fetched = Partners.get_investor!(investor.id)
      assert fetched.id == investor.id
      assert [%Document{} = fetched_doc] = fetched.documents
      assert fetched_doc.id == doc.id
    end

    test "create_investor/1 with valid data creates an investor" do
      assert {:ok, %Investor{} = inv} = Partners.create_investor(@valid_investor_attrs)
      assert inv.first_name == "John"
      assert inv.email == "john.doe@example.com"
    end

    test "create_investor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Partners.create_investor(@invalid_investor_attrs)
    end

    test "change_investor/1 returns a changeset" do
      {:ok, inv} = Partners.create_investor(@valid_investor_attrs)
      changeset = Partners.change_investor(inv)
      assert %Ecto.Changeset{data: ^inv, valid?: true} = changeset
    end
  end

  describe "investors validations" do
    test "email format is validated" do
      assert {:error, changeset} = Partners.create_investor(@bad_email_attrs)
      assert %{email: ["has invalid format"]} = errors_on(changeset)
    end

    test "phone must be 10 digits" do
      assert {:error, changeset} = Partners.create_investor(@bad_phone_attrs)
      assert %{phone: ["has invalid format"]} = errors_on(changeset)
    end

    test "zip_code must be 5 digits" do
      assert {:error, changeset} = Partners.create_investor(@bad_zip_attrs)
      assert %{zip_code: ["has invalid format"]} = errors_on(changeset)
    end

    test "state must be one of the allowed values" do
      assert {:error, changeset} = Partners.create_investor(@bad_state_attrs)
      assert %{state: ["is invalid"]} = errors_on(changeset)
    end

    test "unique email constraint" do
      assert {:ok, _} = Partners.create_investor(@valid_investor_attrs)
      # Attempt to create again with same email
      dup_attrs = Map.put(@valid_investor_attrs, :first_name, "Jane")
      assert {:error, changeset} = Partners.create_investor(dup_attrs)
      assert %{email: ["has already been taken"]} = errors_on(changeset)
    end
  end

  describe "documents" do
    setup do
      {:ok, investor} = Partners.create_investor(@valid_investor_attrs)
      %{investor: investor}
    end

    @valid_doc_attrs %{filename: "doc.pdf", path: "/tmp/doc.pdf"}
    @invalid_doc_attrs %{investor_id: nil, filename: nil, path: nil}

    test "create_document/1 with valid data creates a document", %{investor: inv} do
      attrs = Map.put(@valid_doc_attrs, :investor_id, inv.id)
      assert {:ok, %Document{} = doc} = Partners.create_document(attrs)
      assert doc.investor_id == inv.id
      assert doc.filename == "doc.pdf"
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Partners.create_document(@invalid_doc_attrs)
    end

    test "list_documents_for_investor/1 returns all documents for that investor", %{investor: inv} do
      attrs = Map.put(@valid_doc_attrs, :investor_id, inv.id)
      {:ok, doc} = Partners.create_document(attrs)
      assert [^doc] = Partners.list_documents_for_investor(inv.id)
    end
  end
end
