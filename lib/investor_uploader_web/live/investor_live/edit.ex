defmodule InvestorUploaderWeb.InvestorLive.Edit do
  use InvestorUploaderWeb, :live_view

  alias InvestorUploader.Partners
  alias InvestorUploader.Partners.Investor

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    investor = Partners.get_investor!(id)
    changeset = Partners.change_investor(investor)

    socket =
      socket
      |> assign(:investor, investor)
      |> assign(:form, to_form(changeset))
      |> assign(:states, Investor.states())

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-lg mx-auto p-4">
      <h1 class="text-2xl font-bold mb-4">Edit Investor</h1>

      <.form for={@form} phx-change="validate" phx-submit="save">
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

        <div class="mt-6 flex space-x-2">
          <button type="submit" class="px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700">
            Save Changes
          </button>
          <.link
            patch={~p"/investors/#{@investor.id}"}
            class="px-4 py-2 bg-gray-300 rounded hover:bg-gray-400"
          >
            Cancel
          </.link>
        </div>
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
    case Partners.update_investor(socket.assigns.investor, params) do
      {:ok, investor} ->
        {:noreply,
         socket
         |> put_flash(:info, "Investor updated successfully.")
         |> redirect(to: "/investors/#{investor.id}")}

      {:error, %Ecto.Changeset{} = cs} ->
        {:noreply, assign(socket, form: to_form(cs))}
    end
  end
end
