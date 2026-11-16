
# ==========================================
# CARGA DE ARCHIVOS
# ==========================================

Code.require_file("util.ex", __DIR__)
Code.require_file("procesos/persistencia.exs", __DIR__)

# MODELOS
Code.require_file("modelos/usuario.exs", __DIR__)
Code.require_file("modelos/zona.exs", __DIR__)
Code.require_file("modelos/sector.exs", __DIR__)
Code.require_file("modelos/punto_atencion.exs", __DIR__)
Code.require_file("modelos/necesidad.exs", __DIR__)
Code.require_file("modelos/centro_apoyo.exs", __DIR__)
Code.require_file("modelos/recurso.exs", __DIR__)
Code.require_file("modelos/asignacion_recurso.exs", __DIR__)
Code.require_file("modelos/movimiento.exs", __DIR__)
Code.require_file("modelos/persona.exs", __DIR__)
Code.require_file("modelos/mensaje.exs", __DIR__)
Code.require_file("modelos/mascota.exs", __DIR__)
Code.require_file("modelos/albergue.exs", __DIR__)
Code.require_file("modelos/historial_persona.exs", __DIR__)

# SERVICIOS
Code.require_file("servicios/usuarios.exs", __DIR__)
Code.require_file("servicios/zonas.exs", __DIR__)
Code.require_file("servicios/necesidades.exs", __DIR__)
Code.require_file("servicios/inventario.exs", __DIR__)
Code.require_file("servicios/personas.exs", __DIR__)
Code.require_file("servicios/mensajeria.exs", __DIR__)
Code.require_file("servicios/mascotas.exs", __DIR__)
Code.require_file("servicios/albergues.exs", __DIR__)
Code.require_file("servicios/reportes.exs", __DIR__)

# PROCESOS
Code.require_file("procesos/auditoria.exs", __DIR__)
Code.require_file("procesos/servicios_persistentes.exs", __DIR__)
Code.require_file("procesos/supervisor.exs", __DIR__)
Code.require_file("procesos/aplicacion.exs", __DIR__)


# ==========================================
# PROGRAMA PRINCIPAL
# ==========================================

defmodule Programa do

  def main do
    Aplicacion.iniciar()
    menu()
    Supervisor.stop(SGESupervisor)
  end


  # ==========================================
  # MENU PRINCIPAL
  # ==========================================

  defp menu do
    IO.puts("\n====================================")
    IO.puts(" SISTEMA DE GESTION DE EMERGENCIAS")
    IO.puts("====================================")
    IO.puts("1. Gestion de usuarios")
    IO.puts("2. Gestion de zonas")
    IO.puts("3. Gestion de necesidades")
    IO.puts("4. Gestion de recursos")
    IO.puts("5. Gestion de personas y mensajes")
    IO.puts("6. Gestion de mascotas")
    IO.puts("7. Gestion de albergues")
    IO.puts("8. Reportes y estadisticas")
    IO.puts("9. Consultar auditoria")
    IO.puts("0. Salir")

    opcion = Util.ingresar(:entero)

    case opcion do
      1 -> menu_usuarios()
      2 -> menu_zonas()
      3 -> menu_necesidades()
      4 -> menu_recursos()
      5 -> menu_personas()
      6 -> menu_mascotas()
      7 -> menu_albergues()
      8 -> menu_reportes()
      9 -> consultar_auditoria()
      0 -> IO.puts("Cerrando el sistema...")
      _ -> IO.puts("Opcion no valida.")
    end

    if opcion != 0 do
      menu()
    end
  end


  # ==========================================
  # SUBMENUS
  # ==========================================

  defp menu_usuarios do
    submenu("GESTION DE USUARIOS", [
      {"Registrar usuario", fn -> registrar_usuario() end},
      {"Listar usuarios", fn -> listar_usuarios() end},
      {"Conectar usuario", fn -> conectar_usuario() end},
      {"Desconectar usuario", fn -> desconectar_usuario() end}
    ])
  end

  defp menu_zonas do
    submenu("GESTION DE ZONAS", [
      {"Registrar zona", fn -> registrar_zona() end},
      {"Listar zonas", fn -> listar_zonas() end},
      {"Registrar sector", fn -> registrar_sector() end},
      {"Registrar punto de atencion", fn -> registrar_punto() end}
    ])
  end

  defp menu_necesidades do
    submenu("GESTION DE NECESIDADES", [
      {"Registrar necesidad", fn -> registrar_necesidad() end},
      {"Listar necesidades", fn -> listar_necesidades() end},
      {"Cambiar estado de necesidad", fn -> cambiar_estado_necesidad() end}
    ])
  end

  defp menu_recursos do
    submenu("GESTION DE RECURSOS", [
      {"Registrar recurso", fn -> registrar_recurso() end},
      {"Listar recursos", fn -> listar_recursos() end},
      {"Asignar recurso a necesidad", fn -> asignar_recurso() end},
      {"Transferir recurso", fn -> transferir_recurso() end},
      {"Consultar movimientos", fn -> consultar_movimientos() end}
    ])
  end

  defp menu_personas do
    submenu("PERSONAS Y MENSAJES", [
      {"Registrar persona afectada", fn -> registrar_persona() end},
      {"Listar personas", fn -> listar_personas() end},
      {"Buscar persona", fn -> buscar_persona() end},
      {"Cambiar estado de persona", fn -> cambiar_estado_persona() end},
      {"Enviar mensaje familiar", fn -> enviar_mensaje() end},
      {"Listar mensajes", fn -> listar_mensajes() end},
      {"Consultar mensajes pendientes", fn -> mensajes_pendientes() end},
      {"Marcar mensaje como entregado", fn -> marcar_mensaje() end}
    ])
  end

  defp menu_mascotas do
    submenu("GESTION DE MASCOTAS", [
      {"Registrar mascota perdida", fn -> registrar_mascota(:perdida) end},
      {"Registrar mascota encontrada", fn -> registrar_mascota(:encontrada) end},
      {"Listar reportes", fn -> listar_mascotas() end},
      {"Buscar coincidencias", fn -> buscar_coincidencias() end},
      {"Confirmar coincidencia", fn -> confirmar_coincidencia() end}
    ])
  end

  defp menu_albergues do
    submenu("GESTION DE ALBERGUES", [
      {"Registrar albergue", fn -> registrar_albergue() end},
      {"Listar albergues", fn -> listar_albergues() end},
      {"Consultar albergue y cupos disponibles", fn -> consultar_albergue() end},
      {"Registrar entrada de persona", fn -> registrar_entrada() end},
      {"Registrar salida de persona", fn -> registrar_salida() end}
    ])
  end

  defp menu_reportes do
    submenu("REPORTES Y ESTADISTICAS", [
      {"Consultar resumen general", fn -> resumen_general() end},
      {"Consultar recursos criticos", fn -> recursos_criticos() end},
      {"Consultar necesidades pendientes", fn -> necesidades_pendientes() end},
      {"Consultar ocupacion de albergues", fn -> ocupacion_albergues() end},
      {"Consultar personas por zona", fn -> personas_por_zona() end},
      {"Consultar necesidades por estado", fn -> necesidades_por_estado() end}
    ])
  end


  # ==========================================
  # FUNCION GENERAL PARA LOS SUBMENUS
  # ==========================================

  defp submenu(titulo, opciones) do
    IO.puts("\n========== #{titulo} ==========")

    Enum.with_index(opciones, 1)
    |> Enum.each(fn {{nombre, _funcion}, numero} ->
      IO.puts("#{numero}. #{nombre}")
    end)

    IO.puts("0. Volver")

    opcion = Util.ingresar(:entero)

    case Enum.at(opciones, opcion - 1) do
      {_nombre, funcion} when opcion > 0 ->
        funcion.()

      _ when opcion == 0 ->
        :ok

      _ ->
        IO.puts("Opcion no valida.")
    end

    if opcion != 0 do
      submenu(titulo, opciones)
    end
  end


  # ==========================================
  # USUARIOS
  # ==========================================

  defp registrar_usuario do
    IO.puts("\n--- REGISTRAR USUARIO ---")

    nombre = ingresar_obligatorio("Nombre:")
    correo = ingresar_obligatorio("Correo:")
    contrasena = ingresar_obligatorio("Contrasena:")
    rol = ingresar_rol()
    zona_id = ingresar_zona_opcional()

    usuario = %Usuario{
      id: System.unique_integer([:positive]),
      nombre: nombre,
      correo: correo,
      contrasena: contrasena,
      rol: rol,
      zona_id: zona_id,
      conectado: false
    }

    case cargar_lista("usuarios.txt") do
      {:ok, usuarios} ->
        case Usuarios.registrar(usuarios, usuario) do
          {:ok, nuevos} ->
            guardar_lista("usuarios.txt", nuevos)
            registrar_auditoria(correo, "REGISTRO", "Registro de usuario")
            mostrar_resultado({:ok, usuario})

          error ->
            mostrar_resultado(error)
        end

      error ->
        mostrar_resultado(error)
    end
  end

  defp listar_usuarios do
    IO.puts("\n--- USUARIOS REGISTRADOS ---")

    case cargar_lista("usuarios.txt") do
      {:ok, usuarios} ->
        mostrar_resultado(Usuarios.listar(usuarios))

      error ->
        mostrar_resultado(error)
    end
  end

  defp conectar_usuario do
    IO.puts("\n--- CONECTAR USUARIO ---")
    correo = ingresar_obligatorio("Correo:")
    contrasena = ingresar_obligatorio("Contrasena:")

    case cargar_lista("usuarios.txt") do
      {:ok, usuarios} ->
        case Usuarios.autenticar(usuarios, correo, contrasena) do
          {:ok, usuario} ->
            nuevos = Enum.map(usuarios, fn u ->
              if u.id == usuario.id, do: %{u | conectado: true}, else: u
            end)

            guardar_lista("usuarios.txt", nuevos)
            registrar_auditoria(correo, "CONEXION", "Usuario conectado")
            mostrar_resultado({:ok, "Usuario conectado correctamente."})

          error ->
            mostrar_resultado(error)
        end

      error ->
        mostrar_resultado(error)
    end
  end

  defp desconectar_usuario do
    IO.puts("\n--- DESCONECTAR USUARIO ---")
    correo = ingresar_obligatorio("Correo del usuario:")

    case cargar_lista("usuarios.txt") do
      {:ok, usuarios} ->
        usuario = Enum.find(usuarios, fn u -> u.correo == correo end)

        if usuario == nil do
          mostrar_resultado({:error, "Usuario no encontrado."})
        else
          nuevos = Enum.map(usuarios, fn u ->
            if u.id == usuario.id, do: %{u | conectado: false}, else: u
          end)

          guardar_lista("usuarios.txt", nuevos)
          registrar_auditoria(correo, "DESCONEXION", "Usuario desconectado")
          mostrar_resultado({:ok, "Usuario desconectado."})
        end

      error ->
        mostrar_resultado(error)
    end
  end


  # ==========================================
  # ZONAS, SECTORES Y PUNTOS DE ATENCION
  # ==========================================

  defp registrar_zona do
    IO.puts("\n--- REGISTRAR ZONA ---")

    zona = %Zona{
      id: System.unique_integer([:positive]),
      nombre: ingresar_obligatorio("Nombre de la zona:"),
      nivel_afectacion: ingresar_nivel(),
      personas_afectadas: ingresar_entero_positivo("Personas afectadas:"),
      sectores: []
    }

    case cargar_lista("zonas.txt") do
      {:ok, zonas} ->
        case Zonas.registrar(zonas, zona) do
          {:ok, nuevas} ->
            guardar_lista("zonas.txt", nuevas)
            registrar_auditoria("Sistema", "REGISTRO", "Registro de zona")
            mostrar_resultado({:ok, zona})

          error ->
            mostrar_resultado(error)
        end

      error ->
        mostrar_resultado(error)
    end
  end

  defp listar_zonas do
    IO.puts("\n--- ZONAS REGISTRADAS ---")

    case cargar_lista("zonas.txt") do
      {:ok, zonas} ->
        mostrar_resultado(Zonas.listar(zonas))

      error ->
        mostrar_resultado(error)
    end
  end

  defp registrar_sector do
    IO.puts("\n--- REGISTRAR SECTOR ---")
    zona_id = ingresar_id_zona()

    sector = %Sector{
      id: System.unique_integer([:positive]),
      nombre: ingresar_obligatorio("Nombre del sector:"),
      descripcion: ingresar_obligatorio("Descripcion:"),
      puntos_atencion: []
    }

    case cargar_lista("zonas.txt") do
      {:ok, zonas} ->
        case Zonas.agregar_sector(zonas, zona_id, sector) do
          {:ok, nuevas} ->
            guardar_lista("zonas.txt", nuevas)
            mostrar_resultado({:ok, sector})

          error ->
            mostrar_resultado(error)
        end

      error ->
        mostrar_resultado(error)
    end
  end

  defp registrar_punto do
    IO.puts("\n--- REGISTRAR PUNTO DE ATENCION ---")
    zona_id = ingresar_id_zona()
    sector_id = ingresar_entero_positivo("ID del sector:")

    punto = %PuntoAtencion{
      id: System.unique_integer([:positive]),
      nombre: ingresar_obligatorio("Nombre del punto:"),
      tipo: ingresar_obligatorio("Tipo de punto:"),
      direccion: ingresar_obligatorio("Direccion:"),
      estado: :activo
    }

    case cargar_lista("zonas.txt") do
      {:ok, zonas} ->
        case Zonas.agregar_punto(zonas, zona_id, sector_id, punto) do
          {:ok, nuevas} ->
            guardar_lista("zonas.txt", nuevas)
            mostrar_resultado({:ok, punto})

          error ->
            mostrar_resultado(error)
        end

      error ->
        mostrar_resultado(error)
    end
  end


  # ==========================================
  # NECESIDADES
  # ==========================================

  defp registrar_necesidad do
    IO.puts("\n--- REGISTRAR NECESIDAD ---")

    necesidad = %Necesidad{
      id: System.unique_integer([:positive]),
      tipo: ingresar_tipo_necesidad(),
      descripcion: ingresar_obligatorio("Descripcion:"),
      cantidad: ingresar_entero_positivo("Cantidad:"),
      zona_id: ingresar_id_zona(),
      prioridad: ingresar_prioridad(),
      estado: :pendiente,
      reportado_por: ingresar_obligatorio("Nombre de quien reporta:"),
      responsable: nil
    }

    case cargar_lista("necesidades.txt") do
      {:ok, necesidades} ->
        case Necesidades.registrar(necesidades, necesidad) do
          {:ok, nuevas} ->
            guardar_lista("necesidades.txt", nuevas)
            registrar_auditoria(necesidad.reportado_por, "REGISTRO", "Registro de necesidad")
            mostrar_resultado({:ok, necesidad})

          error ->
            mostrar_resultado(error)
        end

      error ->
        mostrar_resultado(error)
    end
  end

  defp listar_necesidades do
    IO.puts("\n--- NECESIDADES REGISTRADAS ---")

    case cargar_lista("necesidades.txt") do
      {:ok, necesidades} ->
        mostrar_resultado(Necesidades.listar(necesidades))

      error ->
        mostrar_resultado(error)
    end
  end

  defp cambiar_estado_necesidad do
    IO.puts("\n--- CAMBIAR ESTADO DE NECESIDAD ---")
    id = ingresar_entero_positivo("ID de la necesidad:")
    IO.puts("Estados: pendiente, asignada, en_progreso, atendida, cancelada")
    estado = ingresar_obligatorio("Nuevo estado:") |> String.downcase() |> String.to_atom()

    case cargar_lista("necesidades.txt") do
      {:ok, necesidades} ->
        case Necesidades.cambiar_estado(necesidades, id, estado) do
          {:ok, nuevas} ->
            guardar_lista("necesidades.txt", nuevas)
            mostrar_resultado({:ok, nuevas})

          error ->
            mostrar_resultado(error)
        end

      error ->
        mostrar_resultado(error)
    end
  end


  # ==========================================
  # INVENTARIO Y RECURSOS
  # ==========================================

  defp registrar_recurso do
    IO.puts("\n--- REGISTRAR RECURSO ---")

    recurso = %Recurso{
      codigo: ingresar_obligatorio("Codigo:"),
      nombre: ingresar_obligatorio("Nombre:"),
      categoria: ingresar_obligatorio("Categoria:"),
      cantidad: ingresar_entero_positivo("Cantidad:"),
      unidad: ingresar_obligatorio("Unidad:"),
      ubicacion: ingresar_obligatorio("Ubicacion:"),
      centro_id: nil
    }

    resultado = Inventario.registrar(recurso)
    registrar_auditoria("Sistema", "RECURSO", "Registro de recurso")
    mostrar_resultado(resultado)
  end

  defp listar_recursos do
    IO.puts("\n--- INVENTARIO DE RECURSOS ---")
    mostrar_resultado(Inventario.listar())
  end

  defp asignar_recurso do
    IO.puts("\n--- ASIGNAR RECURSO ---")

    codigo = ingresar_obligatorio("Codigo del recurso:")
    cantidad = ingresar_entero_positivo("Cantidad a asignar:")
    necesidad_id = ingresar_entero_positivo("ID de la necesidad:")
    responsable = ingresar_obligatorio("Responsable:")

    resultado = Inventario.asignar(codigo, cantidad, necesidad_id, responsable)

    case resultado do
      {:ok, _} ->
        registrar_auditoria(responsable, "ASIGNACION", "Asignacion de recurso")

      _ ->
        :ok
    end

    mostrar_resultado(resultado)
  end

  defp transferir_recurso do
    IO.puts("\n--- TRANSFERIR RECURSO ---")

    codigo = ingresar_obligatorio("Codigo del recurso:")
    cantidad = ingresar_entero_positivo("Cantidad a transferir:")
    destino = ingresar_obligatorio("Ubicacion de destino:")
    responsable = ingresar_obligatorio("Responsable:")

    resultado = Inventario.transferir(codigo, cantidad, destino, responsable)

    case resultado do
      {:ok, _} ->
        registrar_auditoria(responsable, "TRANSFERENCIA", "Transferencia de recurso")

      _ ->
        :ok
    end

    mostrar_resultado(resultado)
  end

  defp consultar_movimientos do
    IO.puts("\n--- MOVIMIENTOS DEL INVENTARIO ---")
    mostrar_resultado(Inventario.movimientos())
  end


  # ==========================================
  # PERSONAS AFECTADAS
  # ==========================================

  defp registrar_persona do
    IO.puts("\n--- REGISTRAR PERSONA AFECTADA ---")

    persona = %Persona{
      id: System.unique_integer([:positive]),
      nombre: ingresar_obligatorio("Nombre:"),
      documento: ingresar_obligatorio("Documento:"),
      edad: ingresar_entero_positivo("Edad:"),
      zona_id: ingresar_id_zona(),
      estado: :desaparecida,
      albergue_id: nil,
      historial: []
    }

    case cargar_lista("personas.txt") do
      {:ok, personas} ->
        case Personas.registrar(personas, persona) do
          {:ok, nuevas} ->
            guardar_lista("personas.txt", nuevas)
            registrar_auditoria(persona.documento, "REGISTRO", "Registro de persona afectada")
            mostrar_resultado({:ok, persona})

          error ->
            mostrar_resultado(error)
        end

      error ->
        mostrar_resultado(error)
    end
  end

  defp listar_personas do
    IO.puts("\n--- PERSONAS REGISTRADAS ---")

    case cargar_lista("personas.txt") do
      {:ok, personas} ->
        mostrar_resultado(Personas.listar(personas))

      error ->
        mostrar_resultado(error)
    end
  end

  defp buscar_persona do
    IO.puts("\n--- BUSCAR PERSONA ---")
    documento = ingresar_obligatorio("Documento o ID:")

    case cargar_lista("personas.txt") do
      {:ok, personas} ->
        resultado =
          case Integer.parse(documento) do
            {id, ""} -> Personas.buscar(personas, id) || Personas.buscar(personas, documento)
            _ -> Personas.buscar(personas, documento)
          end

        mostrar_resultado(resultado)

      error ->
        mostrar_resultado(error)
    end
  end

  defp cambiar_estado_persona do
    IO.puts("\n--- CAMBIAR ESTADO DE PERSONA ---")
    id = ingresar_entero_positivo("ID de la persona:")
    IO.puts("Estados: desaparecida, localizada, atendida, albergada")
    estado = ingresar_obligatorio("Nuevo estado:") |> String.downcase() |> String.to_atom()

    case cargar_lista("personas.txt") do
      {:ok, personas} ->
        case Personas.cambiar_estado(personas, id, estado) do
          {:ok, nuevas} ->
            guardar_lista("personas.txt", nuevas)
            mostrar_resultado({:ok, nuevas})

          error ->
            mostrar_resultado(error)
        end

      error ->
        mostrar_resultado(error)
    end
  end


  # ==========================================
  # MENSAJERIA FAMILIAR
  # ==========================================

  defp enviar_mensaje do
    IO.puts("\n--- ENVIAR MENSAJE FAMILIAR ---")

    mensaje = %Mensaje{
      id: System.unique_integer([:positive]),
      fecha: DateTime.utc_now(),
      remitente: ingresar_obligatorio("Remitente:"),
      destinatario: ingresar_obligatorio("Destinatario:"),
      contenido: ingresar_obligatorio("Contenido del mensaje:"),
      estado: :pendiente
    }

    case cargar_lista("mensajes.txt") do
      {:ok, mensajes} ->
        case Mensajeria.enviar(mensajes, mensaje) do
          {:ok, nuevos} ->
            guardar_lista("mensajes.txt", nuevos)
            registrar_auditoria(mensaje.remitente, "MENSAJE", "Envio de mensaje familiar")
            mostrar_resultado({:ok, mensaje})

          error ->
            mostrar_resultado(error)
        end

      error ->
        mostrar_resultado(error)
    end
  end

  defp listar_mensajes do
    IO.puts("\n--- MENSAJES REGISTRADOS ---")

    case cargar_lista("mensajes.txt") do
      {:ok, mensajes} ->
        mostrar_resultado(Mensajeria.listar(mensajes))

      error ->
        mostrar_resultado(error)
    end
  end

  defp mensajes_pendientes do
    IO.puts("\n--- MENSAJES PENDIENTES ---")

    case cargar_lista("mensajes.txt") do
      {:ok, mensajes} ->
        mostrar_resultado(Mensajeria.pendientes(mensajes))

      error ->
        mostrar_resultado(error)
    end
  end

  defp marcar_mensaje do
    IO.puts("\n--- MARCAR MENSAJE COMO ENTREGADO ---")
    id = ingresar_entero_positivo("ID del mensaje:")

    case cargar_lista("mensajes.txt") do
      {:ok, mensajes} ->
        case Mensajeria.marcar_entregado(mensajes, id) do
          {:ok, nuevos} ->
            guardar_lista("mensajes.txt", nuevos)
            mostrar_resultado({:ok, "Mensaje marcado como entregado."})

          error ->
            mostrar_resultado(error)
        end

      error ->
        mostrar_resultado(error)
    end
  end


  # ==========================================
  # MASCOTAS
  # ==========================================

  defp registrar_mascota(tipo_reporte) do
    IO.puts("\n--- REGISTRAR MASCOTA ---")

    mascota = %Mascota{
      id: System.unique_integer([:positive]),
      tipo_reporte: tipo_reporte,
      especie: ingresar_obligatorio("Especie:"),
      nombre: ingresar_obligatorio("Nombre (si no tiene, escriba Desconocido):"),
      caracteristicas: ingresar_obligatorio("Caracteristicas:"),
      color: ingresar_obligatorio("Color:"),
      tamano: ingresar_obligatorio("Tamano:"),
      zona_id: ingresar_id_zona(),
      contacto: ingresar_obligatorio("Datos de contacto:"),
      estado: :activa,
      coincidencia_id: nil
    }

    case cargar_lista("mascotas.txt") do
      {:ok, mascotas} ->
        case Mascotas.registrar(mascotas, mascota) do
          {:ok, nuevas} ->
            guardar_lista("mascotas.txt", nuevas)
            registrar_auditoria(mascota.contacto, "REGISTRO", "Registro de mascota")
            mostrar_resultado({:ok, mascota})

          error ->
            mostrar_resultado(error)
        end

      error ->
        mostrar_resultado(error)
    end
  end

  defp listar_mascotas do
    IO.puts("\n--- MASCOTAS REGISTRADAS ---")

    case cargar_lista("mascotas.txt") do
      {:ok, mascotas} ->
        mostrar_resultado(Mascotas.listar(mascotas))

      error ->
        mostrar_resultado(error)
    end
  end

  defp buscar_coincidencias do
    IO.puts("\n--- COINCIDENCIAS DE MASCOTAS ---")

    case cargar_lista("mascotas.txt") do
      {:ok, mascotas} ->
        mostrar_resultado(Mascotas.buscar_coincidencias(mascotas))

      error ->
        mostrar_resultado(error)
    end
  end

  defp confirmar_coincidencia do
    IO.puts("\n--- CONFIRMAR COINCIDENCIA ---")
    id_perdida = ingresar_entero_positivo("ID de mascota perdida:")
    id_encontrada = ingresar_entero_positivo("ID de mascota encontrada:")

    case cargar_lista("mascotas.txt") do
      {:ok, mascotas} ->
        case Mascotas.confirmar_coincidencia(mascotas, id_perdida, id_encontrada) do
          {:ok, nuevas} ->
            guardar_lista("mascotas.txt", nuevas)
            registrar_auditoria("Sistema", "COINCIDENCIA", "Coincidencia confirmada")
            mostrar_resultado({:ok, nuevas})

          error ->
            mostrar_resultado(error)
        end

      error ->
        mostrar_resultado(error)
    end
  end


  # ==========================================
  # ALBERGUES
  # ==========================================

  defp registrar_albergue do
    IO.puts("\n--- REGISTRAR ALBERGUE ---")

    albergue = %Albergue{
      id: System.unique_integer([:positive]),
      nombre: ingresar_obligatorio("Nombre:"),
      direccion: ingresar_obligatorio("Direccion:"),
      zona_id: ingresar_id_zona(),
      capacidad: ingresar_entero_positivo("Capacidad maxima:"),
      ocupacion: 0,
      personas: [],
      recursos: [],
      necesidades: []
    }

    resultado = Albergues.registrar(albergue)

    case resultado do
      :ok ->
        registrar_auditoria("Sistema", "REGISTRO", "Registro de albergue")
        mostrar_resultado({:ok, albergue})

      error ->
        mostrar_resultado(error)
    end
  end

  defp listar_albergues do
    IO.puts("\n--- ALBERGUES REGISTRADOS ---")
    mostrar_resultado(Albergues.listar())
  end

  defp consultar_albergue do
    IO.puts("\n--- CONSULTAR ALBERGUE ---")
    id = ingresar_entero_positivo("ID del albergue:")
    mostrar_resultado(Albergues.consultar(id))
  end

  defp registrar_entrada do
    IO.puts("\n--- REGISTRAR ENTRADA A ALBERGUE ---")
    id = ingresar_entero_positivo("ID del albergue:")
    persona_id = ingresar_entero_positivo("ID de la persona:")

    resultado = Albergues.registrar_entrada(id, persona_id)

    case resultado do
      :ok ->
        actualizar_albergue_persona(persona_id, id)
        registrar_auditoria("Sistema", "ENTRADA", "Ingreso a albergue")

      _ ->
        :ok
    end

    mostrar_resultado(resultado)
  end

  defp registrar_salida do
    IO.puts("\n--- REGISTRAR SALIDA DE ALBERGUE ---")
    id = ingresar_entero_positivo("ID del albergue:")
    persona_id = ingresar_entero_positivo("ID de la persona:")

    resultado = Albergues.registrar_salida(id, persona_id)

    case resultado do
      :ok ->
        actualizar_albergue_persona(persona_id, nil)
        registrar_auditoria("Sistema", "SALIDA", "Salida de albergue")

      _ ->
        :ok
    end

    mostrar_resultado(resultado)
  end

  defp actualizar_albergue_persona(persona_id, albergue_id) do
    case cargar_lista("personas.txt") do
      {:ok, personas} ->
        nuevas = Enum.map(personas, fn persona ->
          if persona.id == persona_id do
            %{persona |
              albergue_id: albergue_id,
              estado: if(albergue_id == nil, do: :localizada, else: :albergada)
            }
          else
            persona
          end
        end)

        guardar_lista("personas.txt", nuevas)

      _ ->
        :ok
    end
  end


  # ==========================================
  # REPORTES
  # ==========================================

  defp resumen_general do
    IO.puts("\n--- RESUMEN GENERAL ---")

    with {:ok, usuarios} <- cargar_lista("usuarios.txt"),
         {:ok, zonas} <- cargar_lista("zonas.txt"),
         {:ok, necesidades} <- cargar_lista("necesidades.txt"),
         {:ok, personas} <- cargar_lista("personas.txt") do
      mostrar_resultado(Reportes.resumen(usuarios, zonas, necesidades, personas))
    else
      error -> mostrar_resultado(error)
    end
  end

  defp recursos_criticos do
    IO.puts("\n--- RECURSOS CRITICOS ---")
    limite = ingresar_entero_positivo("Cantidad limite:")

    mostrar_resultado(
      Inventario.listar()
      |> Reportes.recursos_criticos(limite)
    )
  end

  defp necesidades_pendientes do
    IO.puts("\n--- NECESIDADES PENDIENTES ---")

    case cargar_lista("necesidades.txt") do
      {:ok, necesidades} ->
        mostrar_resultado(Reportes.necesidades_pendientes(necesidades))

      error ->
        mostrar_resultado(error)
    end
  end

  defp ocupacion_albergues do
    IO.puts("\n--- OCUPACION DE ALBERGUES ---")
    mostrar_resultado(Reportes.albergues_mas_ocupados(Albergues.listar()))
  end

  defp personas_por_zona do
    IO.puts("\n--- PERSONAS POR ZONA ---")

    case cargar_lista("personas.txt") do
      {:ok, personas} ->
        mostrar_resultado(Reportes.personas_por_zona(personas))

      error ->
        mostrar_resultado(error)
    end
  end

  defp necesidades_por_estado do
    IO.puts("\n--- NECESIDADES POR ESTADO ---")

    case cargar_lista("necesidades.txt") do
      {:ok, necesidades} ->
        mostrar_resultado(Reportes.necesidades_por_estado(necesidades))

      error ->
        mostrar_resultado(error)
    end
  end


  # ==========================================
  # AUDITORIA
  # ==========================================

  defp consultar_auditoria do
    IO.puts("\n--- REGISTRO DE AUDITORIA ---")
    mostrar_resultado(Auditoria.listar())
  end

  defp registrar_auditoria(usuario, accion, descripcion) do
    Auditoria.registrar(usuario, accion, descripcion)
  end


  # ==========================================
  # PERSISTENCIA Y VALIDACIONES
  # ==========================================

  defp cargar_lista(archivo) do
    case Persistencia.cargar(archivo) do
      {:ok, datos} when is_list(datos) -> {:ok, datos}
      {:ok, _} -> {:error, "El archivo #{archivo} no contiene una lista."}
      error -> error
    end
  end

  defp guardar_lista(archivo, datos) do
    mostrar_resultado(Persistencia.guardar(archivo, datos))
  end

  defp ingresar_obligatorio(mensaje) do
    IO.puts(mensaje)
    valor = Util.ingresar(:texto)

    if valor == "" do
      IO.puts("Este campo no puede estar vacio.")
      ingresar_obligatorio(mensaje)
    else
      valor
    end
  end

  defp ingresar_entero_positivo(mensaje) do
    IO.puts(mensaje)
    valor = Util.ingresar(:entero)

    if valor <= 0 do
      IO.puts("Debe ingresar un numero mayor que cero.")
      ingresar_entero_positivo(mensaje)
    else
      valor
    end
  end

  defp ingresar_id_zona do
    IO.puts("\nZonas registradas:")

    case cargar_lista("zonas.txt") do
      {:ok, zonas} when zonas != [] ->
        Enum.each(zonas, fn zona ->
          IO.puts("ID: #{zona.id} - #{zona.nombre}")
        end)

        id = ingresar_entero_positivo("ID de la zona:")

        if Enum.any?(zonas, fn zona -> zona.id == id end) do
          id
        else
          IO.puts("La zona no existe.")
          ingresar_id_zona()
        end

      _ ->
        IO.puts("Primero debe registrar una zona.")
        registrar_zona()
        ingresar_id_zona()
    end
  end

  defp ingresar_zona_opcional do
    case cargar_lista("zonas.txt") do
      {:ok, []} ->
        IO.puts("No hay zonas registradas. El usuario quedara sin zona asignada.")
        nil

      {:ok, zonas} ->
        Enum.each(zonas, fn zona ->
          IO.puts("ID: #{zona.id} - #{zona.nombre}")
        end)

        ingresar_entero_positivo("ID de la zona:")

      _ ->
        nil
    end
  end

  defp ingresar_rol do
    IO.puts("Roles: ciudadano, voluntario, coordinador, administrador")
    rol = ingresar_obligatorio("Rol:") |> String.downcase()

    case rol do
      "ciudadano" -> :ciudadano
      "voluntario" -> :voluntario
      "coordinador" -> :coordinador
      "administrador" -> :administrador
      _ ->
        IO.puts("Rol no valido.")
        ingresar_rol()
    end
  end

  defp ingresar_nivel do
    IO.puts("Niveles: critico, alto, medio, bajo")
    valor = ingresar_obligatorio("Nivel de afectacion:") |> String.downcase()

    case valor do
      "critico" -> :critico
      "alto" -> :alto
      "medio" -> :medio
      "bajo" -> :bajo
      _ ->
        IO.puts("Nivel no valido.")
        ingresar_nivel()
    end
  end

  defp ingresar_prioridad do
    IO.puts("Prioridades: critica, alta, media, baja")
    valor = ingresar_obligatorio("Prioridad:") |> String.downcase()

    case valor do
      "critica" -> :critica
      "alta" -> :alta
      "media" -> :media
      "baja" -> :baja
      _ ->
        IO.puts("Prioridad no valida.")
        ingresar_prioridad()
    end
  end

  defp ingresar_tipo_necesidad do
    IO.puts("Tipos: agua, alimentos, medicamentos, primeros_auxilios, refugio, transporte, rescate, otro")
    valor = ingresar_obligatorio("Tipo de necesidad:") |> String.downcase()

    case valor do
      "agua" -> :agua
      "alimentos" -> :alimentos
      "medicamentos" -> :medicamentos
      "primeros_auxilios" -> :primeros_auxilios
      "refugio" -> :refugio
      "transporte" -> :transporte
      "rescate" -> :rescate
      "otro" -> :otro
      _ ->
        IO.puts("Tipo no valido.")
        ingresar_tipo_necesidad()
    end
  end


  # ==========================================
  # MOSTRAR RESULTADOS
  # ==========================================

  defp mostrar_resultado(:ok) do
    IO.puts("Operacion realizada correctamente.")
  end

  defp mostrar_resultado({:ok, datos}) do
    IO.puts("Operacion realizada correctamente.")
    IO.inspect(datos, limit: :infinity)
  end

  defp mostrar_resultado({:error, mensaje}) do
    IO.puts("Error: #{mensaje}")
  end

  defp mostrar_resultado(nil) do
    IO.puts("No se encontro informacion.")
  end

  defp mostrar_resultado(datos) do
    IO.inspect(datos, limit: :infinity)
  end

end

Programa.main()
