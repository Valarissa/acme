defmodule AcmeWeb.CurrentUser do
  import Plug.Conn
  alias Acme.UserManager

  def init(opts), do: opts

  def call(conn, _opts) do
    user = get_user_from_session(conn)

    conn
    |> assign(:current_user, user)
  end

  defp get_user_from_session(conn) do
    case get_session(conn, :current_user_id) do
      nil -> nil
      int -> UserManager.get_user(int)
    end
  end
end
