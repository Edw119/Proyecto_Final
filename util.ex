defmodule Util do

  def mostrar_mensaje(mensaje) do
    mensaje
    |> String.trim()
    |> IO.puts()
  end

  def ingresar(:texto) do
    IO.gets("")
    |> String.trim()
  end

  def ingresar(:entero) do
    try do
      IO.gets("")
      |> String.trim()
      |> String.to_integer()
    rescue
      _ ->
        mostrar_mensaje("Error: debes ingresar un número entero.")
        ingresar(:entero)
    end
  end

end