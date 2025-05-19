defmodule InvestorUploaderWeb.InvestorLive.Show do
  use InvestorUploaderWeb, :live_view

  alias InvestorUploader.Partners

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    investor = Partners.get_investor!(id)

    socket =
      socket
      |> assign(:investor, investor)
      |> assign(:uploaded_files, [])
      |> allow_upload(:doc,
        accept: ~w(.pdf .png .jpg .jpeg),
        max_entries: 3,
        max_file_size: 3_000_000
      )

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-lg mx-auto p-4">
      <h1 class="text-2xl font-bold mb-4">Investor Details</h1>

      <div class="space-y-2">
        <p><strong>First Name:</strong> {@investor.first_name}</p>
        <p><strong>Last Name:</strong> {@investor.last_name}</p>
        <p><strong>Email:</strong> {@investor.email}</p>
        <p><strong>DOB:</strong> {@investor.dob}</p>
        <p><strong>Phone:</strong> {@investor.phone}</p>
        <p>
          <strong>Address:</strong> {@investor.street_address}, {@investor.state} {@investor.zip_code}
        </p>
      </div>

      <h2 class="mt-6 text-xl font-semibold">Documents</h2>
      <form id="upload-form" phx-submit="save" phx-change="validate">
        <.live_file_input upload={@uploads.doc} />
        <%= for entry <- @uploads.doc.entries do %>
          <div class="row">
            <div class="column">
              {entry.client_name}
              <%= if entry.valid? do %>
                <span class="text-green-600"> File Valid</span>
              <% else %>
                <span class="text-red-600">
                  Error: Should be (.pdf .png .jpg .jpeg) and less then 3MB File
                </span>
              <% end %>
              <a
                href="#"
                phx-click="cancel-upload"
                phx-value-ref={entry.ref}
                class="text-red-600 hover:underline"
              >
                Cancel
              </a>
            </div>
          </div>
        <% end %>
        <button type="submit" class="px-3 py-1 bg-blue-600 text-white rounded hover:bg-blue-700">
          Upload
        </button>
      </form>
      <ul class="list-disc pl-5">
        <%= for doc <- @investor.documents do %>
          <li>
            <p class="text-blue-600">
              {doc.filename}
            </p>
          </li>
        <% end %>
      </ul>

      <.link
        patch={~p"/investors"}
        class="mt-6 inline-block px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
      >
        Back to Investors
      </.link>
    </div>
    """
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :doc, ref)}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save", _params, socket) do
    consume_uploaded_entries(socket, :doc, fn %{path: path}, %{client_name: name} ->
      dest =
        Path.join(
          Application.app_dir(:investor_uploader, "priv/static/uploads"),
          socket.assigns.investor.id <> "-" <> name
        )

      File.cp!(path, dest)

      Partners.create_document(%{
        filename: name,
        path: dest,
        investor_id: socket.assigns.investor.id
      })
    end)

    socket =
      socket
      |> update(:investor, fn inv ->
        Partners.get_investor!(inv.id)
      end)

    {:noreply, socket}
  end
end
