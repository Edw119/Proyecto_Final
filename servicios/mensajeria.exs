defmodule Mensajeria do

  def enviar(mensajes, mensaje) do
    existe = Enum.any?(mensajes, fn m -> m.id == mensaje.id end)

    if existe do
      {:error, "El mensaje ya existe."}
    else
      nuevo_mensaje = %{mensaje | estado: :pendiente}
      {:ok, [nuevo_mensaje | mensajes]}
    end
  end

  def listar(mensajes) do
    mensajes
  end

  def buscar(mensajes, id) do
    Enum.find(mensajes, fn m -> m.id == id end)
  end

  def por_destinatario(mensajes, destinatario) do
    Enum.filter(mensajes, fn m ->
      m.destinatario == destinatario
    end)
  end

  def marcar_entregado(mensajes, id) do
    mensaje = buscar(mensajes, id)

    if mensaje == nil do
      {:error, "Mensaje no encontrado."}
    else
      nuevos = Enum.map(mensajes, fn m ->
        if m.id == id, do: %{m | estado: :entregado}, else: m
      end)

      {:ok, nuevos}
    end
  end

  def pendientes(mensajes) do
    Enum.filter(mensajes, fn m ->
      m.estado == :pendiente
    end)
  end

end
