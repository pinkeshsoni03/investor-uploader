defmodule InvestorUploaderWeb.InvestorLive.New do
  use InvestorUploaderWeb, :live_view

  alias InvestorUploader.Partners
  alias InvestorUploader.Partners.Investor

  @impl true
  def mount(_params, _session, socket) do
    changeset = Partners.change_investor(%Investor{})

    socket =
      socket
      |> assign(:form, to_form(changeset))
      |> assign(:states, Investor.states())
      |> allow_upload(:file,
        accept: ~w(.pdf .png .jpg .jpeg),
        max_entries: 1,
        max_file_size: 3_000_000
      )

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-lg mx-auto p-4">
      <h1 class="text-2xl font-bold mb-4">New Investor</h1>

      <.form for={@form} phx-change="validate" phx-submit="save" multipart>
        <.input field={@form[:first_name]} type="text" label="First Name" />
        <.input field={@form[:last_name]} type="text" label="Last Name" />
        <.input field={@form[:email]} type="email" label="Email" />
        <.input field={@form[:dob]} type="date" label="Date of Birth" />
        <.input field={@form[:phone]} type="text" label="Phone Number" />
        <.input field={@form[:street_address]} type="text" label="Street Address" />
        <.input
          field={@form[:state]}
          type="select"
          label="State"
          options={@states}
          prompt="Select a state"
        />
        <.input field={@form[:zip_code]} type="text" label="ZIP Code" />
        <button type="submit" class="mt-6 px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
          Submit
        </button>
      </.form>
    </div>
    """
  end

  @impl true
  def handle_event("validate", %{"investor" => params}, socket) do
    form =
      %Investor{}
      |> Partners.change_investor(params)
      |> to_form(action: :validate)

    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_event("save", %{"investor" => params}, socket) do
    # Save uploaded file to "uploads/" and get its path
    case Partners.create_investor(params) do
      {:ok, _inv} ->
        {:noreply, socket |> redirect(to: "/investors")}

      {:error, %Ecto.Changeset{} = cs} ->
        {:noreply, assign(socket, form: to_form(cs))}
    end
  end
end
