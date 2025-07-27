defmodule Backend.Shaders do
  @moduledoc """
  The Shaders context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo
  alias Backend.Shaders.Shader

  @doc """
  Returns the list of shaders.

  ## Examples

      iex> list_shaders()
      [%Shader{}, ...]

  """
  def list_shaders do
    Repo.all(from s in Shader, order_by: [desc: s.inserted_at])
  end

  @doc """
  Gets a single shader.

  Raises `Ecto.NoResultsError` if the Shader does not exist.

  ## Examples

      iex> get_shader!(123)
      %Shader{}

      iex> get_shader!(456)
      ** (Ecto.NoResultsError)

  """
  def get_shader!(id), do: Repo.get!(Shader, id)

  @doc """
  Creates a shader.

  ## Examples

      iex> create_shader(%{field: value})
      {:ok, %Shader{}}

      iex> create_shader(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_shader(attrs \\ %{}) do
    %Shader{}
    |> Shader.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a shader.

  ## Examples

      iex> update_shader(shader, %{field: new_value})
      {:ok, %Shader{}}

      iex> update_shader(shader, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_shader(%Shader{} = shader, attrs) do
    shader
    |> Shader.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a shader.

  ## Examples

      iex> delete_shader(shader)
      {:ok, %Shader{}}

      iex> delete_shader(shader)
      {:error, %Ecto.Changeset{}}

  """
  def delete_shader(%Shader{} = shader) do
    Repo.delete(shader)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking shader changes.

  ## Examples

      iex> change_shader(shader)
      %Ecto.Changeset{data: %Shader{}}

  """
  def change_shader(%Shader{} = shader, attrs \\ %{}) do
    Shader.changeset(shader, attrs)
  end
end
