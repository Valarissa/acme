defmodule AcmeWeb.RegistrationController do
  use AcmeWeb, :controller
  alias Acme.UserManager
  alias UserManager.User

  def new(conn, _params) do
    changeset = User.registration_changeset(%User{}, %{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    case UserManager.register_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Success!")
        |> put_session(:current_user_id, user.id)
        |> configure_session(renew: true)
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end
end
