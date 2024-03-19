import gleam/list
import gleam/dict
import gleam/io

pub fn validate_bill_structure(
  from dictionary: dict.Dict(String, String),
) -> #(String, dict.Dict(String, String)) {
  let keys = [
    "reference_month", "charge_period", "due_to", "amount", "status", "paid_at",
  ]

  let all_ok = list.all(keys, fn(key) { dict.has_key(dictionary, key) })

  io.debug(all_ok)

  case all_ok {
    True -> #("ok", dictionary)
    False -> #("error", dictionary)
  }
}
