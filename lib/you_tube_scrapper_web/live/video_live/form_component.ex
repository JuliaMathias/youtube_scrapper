defmodule YouTubeScrapperWeb.VideoLive.FormComponent do
  use YouTubeScrapperWeb, :live_component

  alias YouTubeScrapper.Playlists

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage video records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="video-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:duration]} type="text" label="Duration" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:posted_on]} type="date" label="Posted on" />
        <.input field={@form[:url]} type="text" label="URL" />
        <.input field={@form[:playlist_id]} type="select" label="Playlist" options={@playlists} />
        <:actions>
          <.button phx-disable-with="Saving...">Save Video</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{video: video} = assigns, socket) do
    playlists = Playlists.list_playlists() |> Enum.map(&{&1.title, &1.id})
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:playlists, playlists)
     |> assign_new(:form, fn ->
       to_form(Playlists.change_video(video))
     end)}
  end

  @impl true
  def handle_event("validate", %{"video" => video_params}, socket) do
    changeset = Playlists.change_video(socket.assigns.video, video_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"video" => video_params}, socket) do
    save_video(socket, socket.assigns.action, video_params)
  end

  defp save_video(socket, :edit, video_params) do
    case Playlists.update_video(socket.assigns.video, video_params) do
      {:ok, video} ->
        notify_parent({:saved, video})

        {:noreply,
         socket
         |> put_flash(:info, "Video updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_video(socket, :new, video_params) do
    case Playlists.create_video(video_params) do
      {:ok, video} ->
        notify_parent({:saved, video})

        {:noreply,
         socket
         |> put_flash(:info, "Video created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
