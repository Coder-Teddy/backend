defmodule Backend.Repo.Migrations.CreateShaders do
  use Ecto.Migration

  def change do
    create table(:shaders) do
      add :shader_code, :text, null: false
      add :description, :text

      timestamps(type: :utc_datetime)
    end

    create index(:shaders, [:inserted_at])
  end
end
