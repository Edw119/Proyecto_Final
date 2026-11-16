defmodule Persona do

  defstruct [
    :id,
    :nombre,
    :documento,
    :edad,
    :zona_id,
    :estado,
    :albergue_id,
    historial: []
  ]

end
