defmodule PayCosern.Utils.BsonEncoder do
  defimpl Jason.Encoder, for: BSON.ObjectId do
    def encode(id, _opts \\ []) do
      with {:ok, encoded_id} <- BSON.ObjectId.encode(id) do
        Jason.encode!(encoded_id)
      else
        error -> throw(error)
      end
    end
  end
end
