defmodule Usuario do

  defstruct [
    :id,
    :nombre,
    :correo,
    :contrasena,
    :rol,
    :zona_id,
    conectado: false
  ]

end
