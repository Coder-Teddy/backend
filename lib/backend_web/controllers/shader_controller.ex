defmodule BackendWeb.ShaderController do
  use BackendWeb, :controller
  alias Backend.Shaders

  @openai_url "https://api.openai.com/v1/chat/completions"

  def generate(conn, %{"prompt" => description}) do
    prompt = """
      Generate a simple WebGL fragment shader based on the following description: #{description}

      Your response must include:
      1. A working GLSL fragment shader (WebGL-compatible)
      2. An array of 3–5 user-friendly ideas for similar visual effects — written in simple language, assuming the user has no knowledge of GLSL or programming.

      Shader requirements:
      - It must be a fragment shader
      - Use \`uniform float u_time\` for animation
      - Use \`uniform vec2 u_resolution\` for screen resolution
      - Output to \`gl_FragColor\`
      - Keep the shader simple and functional

      Response format:
      {
        "shader": "<GLSL_CODE_HERE>",
        "suggestions": [
          "Friendly description 1",
          "Friendly description 2",
          ...
        ]
      }

      Examples of user-friendly suggestions:
      - "Make the shape grow and shrink like it's breathing"
      - "Change the color from red to blue slowly"
      - "Make it fade in and out like it's glowing"

      Do not use technical terms like 'fragment shader', 'sine wave', 'step()', or 'alpha blending' in the suggestions section.
  """

    body = %{
      model: "gpt-4-turbo",
      messages: [
        %{role: "system", content: "You are a GLSL shader generator."},
        %{role: "user", content: prompt}
      ],
      max_tokens: 600
    } |> Jason.encode!()

    headers = [
      {"Authorization", "Bearer #{Application.fetch_env!(:backend, :openai_key)}"},
      {"Content-Type", "application/json"}
    ]

    case HTTPoison.post(@openai_url, body, headers, recv_timeout: 240_000, timeout: 240_000) do
      {:ok, %{status_code: 200, body: resp}} ->
        %{"choices" => [%{"message" => %{"content" => glsl}}]} = Jason.decode!(resp)

        # cleaned_glsl = glsl
        #   |> String.replace("```glsl\n", "")
        #   |> String.replace("```", "")
        #   |> String.trim()


        case Shaders.create_shader(%{
          shader_code: glsl,
          description: description
        }) do
          {:ok, shader} ->
            json(conn, %{
              id: shader.id,
              shader: shader.shader_code,
              description: shader.description,
              created_at: shader.inserted_at
            })

          {:error, changeset} ->
            json(conn, %{error: "Database error: #{inspect(changeset.errors)}"})
        end

      {:ok, resp} ->
        json(conn, %{error: "OpenAI #{resp.status_code}: #{resp.body}"})

      {:error, reason} ->
        json(conn, %{error: "HTTP error: #{inspect(reason)}"})
    end
  end

  def index(conn, _params) do
    shaders = Shaders.list_shaders()

    formatted_shaders = Enum.map(shaders, fn shader ->
      %{
        id: shader.id,
        shader: shader.shader_code,
        description: shader.description,
        created_at: shader.inserted_at
      }
    end)

    json(conn, %{shaders: formatted_shaders})
  end
end
