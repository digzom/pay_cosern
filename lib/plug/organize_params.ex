defmodule PayCosern.Plug.OrganizeParams do
  alias Plug.Conn

  @behaviour Plug

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: _path} = conn, _opts) do
    {_, body, conn} = Plug.Conn.read_body(conn)
    %Conn{params: params} = conn = Plug.Conn.fetch_query_params(conn)

    body = decode_body(body)
    params = Map.merge(params, body)

    conn =
      Map.put(conn, :params, params)

    conn
  end

  def decode_body(body) when body in [nil, "", false], do: %{}

  def decode_body(body) do
    Jason.decode!(body)
  end
end
