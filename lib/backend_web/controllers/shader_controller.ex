defmodule BackendWeb.ShaderController do
  use BackendWeb, :controller
  @openai_url "https://api.openai.com/v1/chat/completions"

  def generate(conn, %{"prompt" => description}) do
    prompt = """
    Generate a simple WebGL fragment shader based on this description: #{description}

    Return only the GLSL fragment shader code that can be used with WebGL.
    The shader should:
    - Be a fragment shader
    - Use uniform float u_time for animation
    - Use uniform vec2 u_resolution for screen resolution
    - Output to gl_FragColor
    - Be simple and working

    Example format:
    precision mediump float;
    uniform float u_time;
    uniform vec2 u_resolution;

    void main() {
      vec2 uv = gl_FragCoord.xy / u_resolution.xy;
      gl_FragColor = vec4(uv, 0.5 + 0.5 * sin(u_time), 1.0);
    }
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
        json(conn, %{shader: glsl})

      {:ok, resp} ->
        json(conn, %{error: "OpenAI #{resp.status_code}: #{resp.body}"})

      {:error, reason} ->
        json(conn, %{error: "HTTP error: #{inspect(reason)}"})
    end
  end
end
