defmodule PayCosern.Router.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :pay_cosern,
    error_handler: PayCosern.Utils.AuthErrorHandler,
    module: PayCosern.Guardian

    plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
    plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
    plug Guardian.Plug.LoadResource, allow_blank: true
end
