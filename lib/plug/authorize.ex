defmodule PayCosern.Plug.Authorize do
  alias Plug.Conn
  import Plug.Conn

  @behaviour Plug
  @authenticated_routes ["/last_bill", "/bills", "/cosern_account"]

  def init(opts), do: opts

  def call(%Plug.Conn{request_path: path} = conn, opts) when path in @authenticated_routes do
    call(conn, opts, :auth)
  end

  def call(%Plug.Conn{req_headers: headers}, _opts, :auth) do
    [token] = Conn.get_req_header(conn, "authorization")

    if is_nil(token) do
      conn
      |> put_resp_header("content-type", "application/json")
      |> send_resp(401, "Unauthorized")
    else
      resource = PayCosern.Guardian.resource_from_token(token)

      conn |> assign(:user, resource)
    end
  end

  def decode_body(body) when body in [nil, "", false], do: %{}

  def decode_body(body) do
    Jason.decode!(body)
  end
end
