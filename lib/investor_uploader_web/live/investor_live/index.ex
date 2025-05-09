defmodule InvestorUploaderWeb.InvestorLive.Index do
  use InvestorUploaderWeb, :live_view

  alias InvestorUploader.Partners

  @impl true
  def mount(_params, _session, socket) do
    investors = Partners.list_investors()

    socket =
      socket
      |> assign(:investors, investors)

    {:ok, socket}
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
    </div>
    """
  end
end
