defmodule Albergue do

  defstruct [
    :id,
    :nombre,
    :direccion,
    :zona_id,
    :capacidad,
    ocupacion: 0,
    personas: [],
    recursos: [],
    necesidades: []
  ]

end
