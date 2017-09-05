defmodule Acme.UserManager.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Acme.UserManager.User
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]


  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password_hash])
    |> validate_required([:name, :email, :password_hash])
    |> unique_constraint(:email)
  end

  @doc false
  def registration_changeset(%User{} = user, attrs) do
    fields = [:name, :email, :password, :password_confirmation]
    user
    |> cast(attrs, fields)
    |> validate_required(fields)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/@.+\..+/)
    |> validate_length(:password, min: 12)
    |> validate_confirmation(:password, message: "DOES NOT MATCH!")
    |> unique_constraint(:email)
    |> maybe_hash_password()
  end

  defp maybe_hash_password(%{valid?: true, changes: %{password: password}} = changeset),
    do: put_change(changeset, :password_hash, hashpwsalt(password))
  defp maybe_hash_password(changeset),
    do: changeset
end
