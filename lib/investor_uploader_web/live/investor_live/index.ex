defmodule InvestorUploaderWeb.InvestorLive.Index do
  use InvestorUploaderWeb, :live_view

  alias InvestorUploader.Partners

  @impl true
  def mount(_params, _session, socket) do
    socket = list_investors(socket, %{page: 1, page_size: 5})

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    params = %{
      page: params["page"] || 1,
      page_size: params["page_size"] || 5
    }

    socket = list_investors(socket, params)

    {:noreply, socket}
  end

  defp list_investors(socket, params) do
    investors = Partners.list_investors(params)

    socket
    |> assign(:investors, investors.entries)
    |> assign(:page_number, investors.page_number)
    |> assign(:page_size, investors.page_size)
    |> assign(:total_entries, investors.total_entries)
    |> assign(:total_pages, investors.total_pages)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-5xl mx-auto p-4">
      <h1 class="text-2xl font-bold mb-4">All Investors</h1>
      <div class="mb-4">
        <.link
          patch={~p"/investors/new"}
          class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
        >
          Add New Investor
        </.link>
      </div>
      <table class="min-w-full border-collapse border">
        <thead>
          <tr class="bg-gray-100">
            <th class="px-4 py-2 border">First Name</th>
            <th class="px-4 py-2 border">Last Name</th>
            <th class="px-4 py-2 border">Email</th>
            <th class="px-4 py-2 border">DOB</th>
            <th class="px-4 py-2 border">Phone</th>
            <th class="px-4 py-2 border">State</th>
            <th class="px-4 py-2 border">ZIP</th>
            <th class="px-4 py-2 border">Action</th>
          </tr>
        </thead>
        <tbody>
          <%= for inv <- @investors do %>
            <tr class="hover:bg-gray-50">
              <td class="px-4 py-2 border">{inv.first_name}</td>
              <td class="px-4 py-2 border">{inv.last_name}</td>
              <td class="px-4 py-2 border">{inv.email}</td>
              <td class="px-4 py-2 border">{inv.dob}</td>
              <td class="px-4 py-2 border">{inv.phone}</td>
              <td class="px-4 py-2 border">{inv.state}</td>
              <td class="px-4 py-2 border">{inv.zip_code}</td>
              <td class="px-4 py-2 border">
                <.link patch={~p"/investors/#{inv.id}"} class="text-blue-600 hover:underline">
                  View
                </.link>
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>
      <div style="display: flex; flex-direction: row; padding: 2px;">
        <div class="px-4 py-2">
          <%= if @page_number > 1 do %>
            <.link
              patch={~p"/investors?page=#{@page_number - 1}"}
              class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
            >
              Previous
            </.link>
          <% end %>
        </div>
        <%= for page <- 1..@total_pages do %>
          <div class="px-4 py-2">
            <.link
              patch={~p"/investors?page=#{page}"}
              class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
            >
              {page}
            </.link>
          </div>
        <% end %>
        <div class="px-4 py-2">
          <%= if @page_number < @total_pages do %>
            <.link
              patch={~p"/investors?page=#{@page_number + 1}"}
              class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
            >
              Next
            </.link>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
