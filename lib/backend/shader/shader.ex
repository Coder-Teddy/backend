defmodule Backend.Shaders.Shader do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shaders" do
    field :title, :string
    field :shader_code, :string
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(shader, attrs) do
    shader
    |> cast(attrs, [:title, :shader_code, :description])
    |> validate_required([:title, :shader_code])
    |> validate_length(:title, min: 1, max: 255)
    |> validate_length(:shader_code, min: 1)
  end
end
