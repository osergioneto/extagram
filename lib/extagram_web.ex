defmodule ExtagramWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use ExtagramWeb, :controller
      use ExtagramWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: ExtagramWeb

      import Plug.Conn
      import ExtagramWeb.Gettext
      alias ExtagramWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.LiveView,
        layout: {ExtagramWeb.LayoutView, "live.html"}

      unquote(view_helpers())
      # Added Start
      import ExtagramWeb.LiveHelpers

      alias Extagram.Accounts.User
      @impl true
      def handle_info(%{event: "logout_user", payload: %{user: %User{id: id}}}, socket) do
        with %User{id: ^id} <- socket.assigns.current_user do
          {:noreply,
           socket
           |> redirect(to: "/")
           |> put_flash(:info, "Logged out successfully.")}
        else
          _any -> {:noreply, socket}
        end
      end

      # Added END
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {ExtagramWeb.LayoutView, "live.html"}

      unquote(view_helpers())
      # Added Start
      import ExtagramWeb.LiveHelpers

      alias Extagram.Accounts.User
      @impl true
      def handle_info(%{event: "logout_user", payload: %{user: %User{id: id}}}, socket) do
        with %User{id: ^id} <- socket.assigns.current_user do
          {:noreply,
           socket
           |> redirect(to: "/")
           |> put_flash(:info, "Logged out successfully.")}
        else
          _any -> {:noreply, socket}
        end
      end

      @impl true
      def handle_params(_unsigned_params, uri, socket) do
        {:noreply,
         socket
         |> assign(current_uri_path: URI.parse(uri).path)}
      end
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import ExtagramWeb.Gettext
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import LiveView helpers (live_render, live_component, live_patch, etc)
      import Phoenix.LiveView.Helpers

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import ExtagramWeb.ErrorHelpers
      import ExtagramWeb.Gettext
      alias ExtagramWeb.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
