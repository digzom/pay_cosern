defmodule PayCosern.Utils.ErrorHandler do
  @derive {Jason.Encoder, only: [:code, :message, :bad_data]}
  defexception [:code, :message, :bad_data]

  @type status_code :: 400 | 500 | 401 | 403
  @type t :: %__MODULE__{code: status_code(), message: String.t(), bad_data: map()}

  @spec new(code :: status_code(), message :: String.t(), bad_data :: map()) ::
          __MODULE__.t()
  def new(code, message, bad_data) when is_binary(message) do
    %__MODULE__{code: code, message: message, bad_data: Map.new(bad_data)}
  end

  @spec not_found(message :: String.t(), bad_data :: map() | nil) :: __MODULE__.t()
  def not_found(message, bad_data \\ %{}) do
    new(404, message, bad_data)
  end

  @spec bad_request(changeset :: Ecto.Changeset.t()) :: __MODULE__.t()
  def bad_request(%Ecto.Changeset{} = changeset) do
    bad_data = get_changeset_errors(changeset)

    new(400, "bad_request_bro", bad_data)
  end

  @spec bad_request(message :: String.t(), bad_data :: map() | nil) :: __MODULE__.t()
  def bad_request(message, bad_data) do
    new(400, message, bad_data)
  end

  @spec internal(message :: String.t()) :: __MODULE__.t()
  def internal(message: message) do
    new(500, message, %{})
  end

  def get_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
