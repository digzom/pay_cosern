defmodule PayCosern.Repo do
  use Mongo.Repo, otp_app: :pay_cosern, topology: :mongo
end
