defmodule CacheDbTest.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias CacheDbTest.Repo

  alias CacheDbTest.Accounts.User
  alias CacheDbTest.Cache

  @users_cache_table_name :users

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    # Repo.all(User)
    Cache.get_all(@users_cache_table_name)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    case Cache.get(@users_cache_table_name, id) do
      %User{} = user -> user
      _ -> get_user_from_db(id)
    end
  end

  @doc "
    Получаем запись user из ETS
    по id
  "
  def get_user_from_db(id) do
    user = Repo.get!(User, id)
    Cache.put(@users_cache_table_name, user)
    user
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    {:ok, user} = %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    Cache.put(@users_cache_table_name, user)
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    {:ok, new_user} = user
      |> User.changeset(attrs)
      |> Repo.update()
    Cache.put(@users_cache_table_name, new_user)
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Cache.delete(@users_cache_table_name, user.id)
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
