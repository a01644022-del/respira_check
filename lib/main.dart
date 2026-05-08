import 'package:flutter/material.dart';

void main() {
  runApp(const RespiraCheckApp());
}

class RespiraCheckApp extends StatelessWidget {
  const RespiraCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RespiraCheck Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF009688),
        ),
        scaffoldBackgroundColor: const Color(0xFFF3FAFA),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFD2E7E7)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFF009688),
              width: 2,
            ),
          ),
        ),
      ),
      home: const RespiraCheckHome(),
    );
  }
}

class EvaluationRecord {
  final String fecha;
  final String nivel;
  final String orientacion;
  final String recomendacion;
  final int puntaje;
  final int edad;
  final String sexo;
  final double temperatura;
  final int dias;
  final List<String> sintomas;
  final Color color;
  final IconData icono;

  EvaluationRecord({
    required this.fecha,
    required this.nivel,
    required this.orientacion,
    required this.recomendacion,
    required this.puntaje,
    required this.edad,
    required this.sexo,
    required this.temperatura,
    required this.dias,
    required this.sintomas,
    required this.color,
    required this.icono,
  });
}

class RespiraCheckHome extends StatefulWidget {
  const RespiraCheckHome({super.key});

  @override
  State<RespiraCheckHome> createState() => _RespiraCheckHomeState();
}

class _RespiraCheckHomeState extends State<RespiraCheckHome> {
  final TextEditingController edadController = TextEditingController();

  int paginaActual = 0;

  String sexo = 'No especificado';
  double temperatura = 36.5;
  int diasSintomas = 1;

  bool tos = false;
  bool fiebre = false;
  bool congestion = false;
  bool dolorGarganta = false;
  bool estornudos = false;
  bool ojosLlorosos = false;
  bool dolorCuerpo = false;
  bool fatiga = false;
  bool perdidaOlfato = false;
  bool dificultadRespirar = false;

  bool asma = false;
  bool fumador = false;
  bool defensasBajas = false;

  String nivel = 'Sin evaluación';
  String resultado = 'Pendiente de evaluación';
  String recomendacion =
      'Completa los datos, selecciona los síntomas y presiona evaluar.';
  int puntaje = 0;
  Color colorResultado = const Color(0xFF607D8B);
  IconData iconoResultado = Icons.info_outline;

  final List<EvaluationRecord> historial = [];

  @override
  void dispose() {
    edadController.dispose();
    super.dispose();
  }

  String fechaActual() {
    final now = DateTime.now();
    final dia = now.day.toString().padLeft(2, '0');
    final mes = now.month.toString().padLeft(2, '0');
    final hora = now.hour.toString().padLeft(2, '0');
    final minuto = now.minute.toString().padLeft(2, '0');
    return '$dia/$mes/${now.year} - $hora:$minuto';
  }

  List<String> sintomasSeleccionados() {
    final sintomas = <String>[];

    if (tos) sintomas.add('Tos');
    if (fiebre) sintomas.add('Fiebre');
    if (congestion) sintomas.add('Congestión nasal');
    if (dolorGarganta) sintomas.add('Dolor de garganta');
    if (estornudos) sintomas.add('Estornudos');
    if (ojosLlorosos) sintomas.add('Ojos llorosos o comezón');
    if (dolorCuerpo) sintomas.add('Dolor de cuerpo');
    if (fatiga) sintomas.add('Fatiga');
    if (perdidaOlfato) sintomas.add('Pérdida de olfato/gusto');
    if (dificultadRespirar) sintomas.add('Dificultad para respirar');

    return sintomas;
  }

  void evaluarSintomas() {
    final edad = int.tryParse(edadController.text) ?? 0;

    if (edad <= 0) {
      setState(() {
        nivel = 'Datos incompletos';
        resultado = 'Edad no válida';
        recomendacion = 'Ingresa una edad válida para continuar.';
        puntaje = 0;
        colorResultado = Colors.grey;
        iconoResultado = Icons.warning_amber_rounded;
      });
      return;
    }

    int puntosAlergia = 0;
    int puntosResfriado = 0;
    int puntosInfeccion = 0;
    int puntosAlerta = 0;

    if (estornudos) puntosAlergia += 2;
    if (ojosLlorosos) puntosAlergia += 2;
    if (congestion) puntosAlergia += 1;

    if (tos) puntosResfriado += 1;
    if (congestion) puntosResfriado += 2;
    if (dolorGarganta) puntosResfriado += 2;
    if (estornudos) puntosResfriado += 1;
    if (fatiga) puntosResfriado += 1;

    if (fiebre) puntosInfeccion += 2;
    if (temperatura >= 38.0) puntosInfeccion += 2;
    if (dolorCuerpo) puntosInfeccion += 2;
    if (tos) puntosInfeccion += 1;
    if (fatiga) puntosInfeccion += 1;
    if (perdidaOlfato) puntosInfeccion += 2;
    if (diasSintomas >= 3) puntosInfeccion += 1;

    if (dificultadRespirar) puntosAlerta += 5;
    if (temperatura >= 39.0) puntosAlerta += 4;
    if (edad <= 5 || edad >= 65) puntosAlerta += 2;
    if (asma) puntosAlerta += 2;
    if (defensasBajas) puntosAlerta += 2;
    if (fumador) puntosAlerta += 1;

    int nuevoPuntaje = 0;
    String nuevoNivel = '';
    String nuevaOrientacion = '';
    String nuevaRecomendacion = '';
    Color nuevoColor = const Color(0xFF607D8B);
    IconData nuevoIcono = Icons.info_outline;

    if (puntosAlerta >= 5) {
      nuevoNivel = 'Alto';
      nuevaOrientacion = 'Signos de alerta respiratoria';
      nuevaRecomendacion =
          'Se recomienda acudir a valoración médica. La presencia de dificultad para respirar, fiebre alta o factores de riesgo puede requerir atención prioritaria.';
      nuevoPuntaje = 90;
      nuevoColor = Colors.red;
      nuevoIcono = Icons.emergency;
    } else if (puntosInfeccion >= 5 &&
        puntosInfeccion >= puntosResfriado &&
        puntosInfeccion >= puntosAlergia) {
      nuevoNivel = 'Moderado';
      nuevaOrientacion = 'Posible cuadro infeccioso respiratorio';
      nuevaRecomendacion =
          'Mantén hidratación, reposo y monitoreo de temperatura. Si la fiebre persiste, los síntomas empeoran o aparece dificultad respiratoria, busca atención médica.';
      nuevoPuntaje = 70;
      nuevoColor = Colors.orange;
      nuevoIcono = Icons.coronavirus;
    } else if (puntosAlergia >= 3 && puntosAlergia > puntosResfriado) {
      nuevoNivel = 'Bajo';
      nuevaOrientacion = 'Compatible con alergia respiratoria';
      nuevaRecomendacion =
          'Evita exposición a polvo, polen, humo o irritantes. Si los síntomas persisten o afectan tus actividades, considera consultar a un profesional de salud.';
      nuevoPuntaje = 35;
      nuevoColor = Colors.green;
      nuevoIcono = Icons.eco;
    } else if (puntosResfriado >= 3) {
      nuevoNivel = 'Bajo a moderado';
      nuevaOrientacion = 'Compatible con resfriado común';
      nuevaRecomendacion =
          'Se sugiere descanso, hidratación y observación. Acude a revisión si aparece fiebre alta, dificultad para respirar o síntomas prolongados.';
      nuevoPuntaje = 50;
      nuevoColor = Colors.blue;
      nuevoIcono = Icons.air;
    } else {
      nuevoNivel = 'Bajo';
      nuevaOrientacion = 'Síntomas leves o poco específicos';
      nuevaRecomendacion =
          'Continúa observando la evolución. Si aparecen nuevos síntomas o aumenta la intensidad, busca orientación médica.';
      nuevoPuntaje = 20;
      nuevoColor = const Color(0xFF607D8B);
      nuevoIcono = Icons.info_outline;
    }

    final nuevoRegistro = EvaluationRecord(
      fecha: fechaActual(),
      nivel: nuevoNivel,
      orientacion: nuevaOrientacion,
      recomendacion: nuevaRecomendacion,
      puntaje: nuevoPuntaje,
      edad: edad,
      sexo: sexo,
      temperatura: temperatura,
      dias: diasSintomas,
      sintomas: sintomasSeleccionados(),
      color: nuevoColor,
      icono: nuevoIcono,
    );

    setState(() {
      nivel = nuevoNivel;
      resultado = nuevaOrientacion;
      recomendacion = nuevaRecomendacion;
      puntaje = nuevoPuntaje;
      colorResultado = nuevoColor;
      iconoResultado = nuevoIcono;
      historial.insert(0, nuevoRegistro);
    });
  }

  void limpiarFormulario() {
    setState(() {
      edadController.clear();
      sexo = 'No especificado';
      temperatura = 36.5;
      diasSintomas = 1;

      tos = false;
      fiebre = false;
      congestion = false;
      dolorGarganta = false;
      estornudos = false;
      ojosLlorosos = false;
      dolorCuerpo = false;
      fatiga = false;
      perdidaOlfato = false;
      dificultadRespirar = false;

      asma = false;
      fumador = false;
      defensasBajas = false;

      nivel = 'Sin evaluación';
      resultado = 'Pendiente de evaluación';
      recomendacion =
          'Completa los datos, selecciona los síntomas y presiona evaluar.';
      puntaje = 0;
      colorResultado = const Color(0xFF607D8B);
      iconoResultado = Icons.info_outline;
    });
  }

  Widget tarjeta({required Widget child}) {
    return Card(
      elevation: 2,
      shadowColor: Colors.teal.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: child,
      ),
    );
  }

  Widget tituloSeccion(String titulo, IconData icono) {
    return Row(
      children: [
        Icon(icono, color: const Color(0xFF00796B)),
        const SizedBox(width: 8),
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF163B3B),
          ),
        ),
      ],
    );
  }

  Widget chipSeleccion({
    required String texto,
    required bool seleccionado,
    required Function(bool) onSelected,
  }) {
    return FilterChip(
      label: Text(texto),
      selected: seleccionado,
      onSelected: onSelected,
      selectedColor: const Color(0xFFB2DFDB),
      checkmarkColor: const Color(0xFF00695C),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color(0xFFCFE5E5)),
      labelStyle: TextStyle(
        color: seleccionado ? const Color(0xFF004D40) : Colors.black87,
        fontWeight: seleccionado ? FontWeight.bold : FontWeight.normal,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    );
  }

  Widget encabezado() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF00695C),
            Color(0xFF009688),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.health_and_safety,
            color: Colors.white,
            size: 46,
          ),
          SizedBox(height: 12),
          Text(
            'RespiraCheck Pro',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Orientación educativa para síntomas respiratorios comunes',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget paginaEvaluacion() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              encabezado(),

              const SizedBox(height: 18),

              tarjeta(
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF00796B)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Esta app no emite diagnósticos. Su función es mostrar una orientación educativa basada en síntomas, temperatura y factores de riesgo.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              tarjeta(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tituloSeccion('Datos del usuario', Icons.person),
                    const SizedBox(height: 16),
                    TextField(
                      controller: edadController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Edad',
                        prefixIcon: Icon(Icons.cake),
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: sexo,
                      decoration: const InputDecoration(
                        labelText: 'Sexo',
                        prefixIcon: Icon(Icons.wc),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'No especificado',
                          child: Text('No especificado'),
                        ),
                        DropdownMenuItem(
                          value: 'Femenino',
                          child: Text('Femenino'),
                        ),
                        DropdownMenuItem(
                          value: 'Masculino',
                          child: Text('Masculino'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          sexo = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              tarjeta(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tituloSeccion(
                      'Variables de seguimiento',
                      Icons.monitor_heart,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Temperatura corporal: ${temperatura.toStringAsFixed(1)} °C',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Slider(
                      value: temperatura,
                      min: 35.0,
                      max: 40.5,
                      divisions: 55,
                      label: '${temperatura.toStringAsFixed(1)} °C',
                      activeColor: const Color(0xFF009688),
                      onChanged: (value) {
                        setState(() {
                          temperatura = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Días con síntomas: $diasSintomas',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Slider(
                      value: diasSintomas.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: '$diasSintomas días',
                      activeColor: const Color(0xFF009688),
                      onChanged: (value) {
                        setState(() {
                          diasSintomas = value.round();
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              tarjeta(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tituloSeccion('Síntomas', Icons.checklist),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        chipSeleccion(
                          texto: 'Tos',
                          seleccionado: tos,
                          onSelected: (value) {
                            setState(() => tos = value);
                          },
                        ),
                        chipSeleccion(
                          texto: 'Fiebre',
                          seleccionado: fiebre,
                          onSelected: (value) {
                            setState(() => fiebre = value);
                          },
                        ),
                        chipSeleccion(
                          texto: 'Congestión nasal',
                          seleccionado: congestion,
                          onSelected: (value) {
                            setState(() => congestion = value);
                          },
                        ),
                        chipSeleccion(
                          texto: 'Dolor de garganta',
                          seleccionado: dolorGarganta,
                          onSelected: (value) {
                            setState(() => dolorGarganta = value);
                          },
                        ),
                        chipSeleccion(
                          texto: 'Estornudos frecuentes',
                          seleccionado: estornudos,
                          onSelected: (value) {
                            setState(() => estornudos = value);
                          },
                        ),
                        chipSeleccion(
                          texto: 'Ojos llorosos o comezón',
                          seleccionado: ojosLlorosos,
                          onSelected: (value) {
                            setState(() => ojosLlorosos = value);
                          },
                        ),
                        chipSeleccion(
                          texto: 'Dolor de cuerpo',
                          seleccionado: dolorCuerpo,
                          onSelected: (value) {
                            setState(() => dolorCuerpo = value);
                          },
                        ),
                        chipSeleccion(
                          texto: 'Fatiga',
                          seleccionado: fatiga,
                          onSelected: (value) {
                            setState(() => fatiga = value);
                          },
                        ),
                        chipSeleccion(
                          texto: 'Pérdida de olfato/gusto',
                          seleccionado: perdidaOlfato,
                          onSelected: (value) {
                            setState(() => perdidaOlfato = value);
                          },
                        ),
                        chipSeleccion(
                          texto: 'Dificultad para respirar',
                          seleccionado: dificultadRespirar,
                          onSelected: (value) {
                            setState(() => dificultadRespirar = value);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              tarjeta(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tituloSeccion('Factores de riesgo', Icons.shield),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        chipSeleccion(
                          texto: 'Asma o enfermedad respiratoria',
                          seleccionado: asma,
                          onSelected: (value) {
                            setState(() => asma = value);
                          },
                        ),
                        chipSeleccion(
                          texto: 'Tabaquismo',
                          seleccionado: fumador,
                          onSelected: (value) {
                            setState(() => fumador = value);
                          },
                        ),
                        chipSeleccion(
                          texto: 'Defensas bajas',
                          seleccionado: defensasBajas,
                          onSelected: (value) {
                            setState(() => defensasBajas = value);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: evaluarSintomas,
                      icon: const Icon(Icons.search),
                      label: const Text('Evaluar síntomas'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF00796B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: limpiarFormulario,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Limpiar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF00796B),
                        side: const BorderSide(
                          color: Color(0xFF00796B),
                          width: 1.4,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              tarjetaResultado(),

              const SizedBox(height: 24),

              const Center(
                child: Text(
                  'RespiraCheck Pro | Evidencia individual Flutter',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget tarjetaResultado() {
    return Card(
      elevation: 4,
      shadowColor: colorResultado.withOpacity(0.2),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(
          color: colorResultado,
          width: 1.4,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: colorResultado.withOpacity(0.14),
                  child: Icon(
                    iconoResultado,
                    color: colorResultado,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nivel,
                        style: TextStyle(
                          fontSize: 14,
                          color: colorResultado,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        resultado,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colorResultado,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        recomendacion,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            Text(
              'Puntaje orientativo: $puntaje / 100',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: puntaje / 100,
                minHeight: 12,
                backgroundColor: Colors.grey.shade200,
                color: colorResultado,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget paginaHistorial() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              encabezadoSecundario(
                titulo: 'Historial',
                subtitulo:
                    'Registro temporal de las evaluaciones realizadas durante esta sesión.',
                icono: Icons.history,
              ),

              const SizedBox(height: 18),

              if (historial.isEmpty)
                tarjeta(
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Text(
                        'Aún no hay evaluaciones registradas.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            historial.clear();
                          });
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Borrar historial'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...historial.map((registro) {
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    registro.color.withOpacity(0.15),
                                child: Icon(
                                  registro.icono,
                                  color: registro.color,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      registro.orientacion,
                                      style: TextStyle(
                                        color: registro.color,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${registro.fecha} | Nivel: ${registro.nivel} | Puntaje: ${registro.puntaje}/100',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Edad: ${registro.edad}, Sexo: ${registro.sexo}, Temp: ${registro.temperatura.toStringAsFixed(1)} °C, Días: ${registro.dias}',
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      registro.sintomas.isEmpty
                                          ? 'Síntomas: No especificados'
                                          : 'Síntomas: ${registro.sintomas.join(", ")}',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget paginaInformacion() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              encabezadoSecundario(
                titulo: 'Información de la app',
                subtitulo:
                    'Descripción del funcionamiento, alcance y lógica general.',
                icono: Icons.science,
              ),

              const SizedBox(height: 18),

              tarjeta(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tituloSeccion('Objetivo', Icons.flag),
                    const SizedBox(height: 12),
                    const Text(
                      'RespiraCheck Pro es una aplicación educativa desarrollada en Flutter para orientar al usuario de forma básica según síntomas respiratorios comunes, datos demográficos y temperatura corporal.',
                      style: TextStyle(fontSize: 15, height: 1.4),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              tarjeta(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tituloSeccion('Variables usadas', Icons.data_object),
                    const SizedBox(height: 12),
                    const Text(
                      '• Edad\n'
                      '• Sexo\n'
                      '• Temperatura corporal\n'
                      '• Días con síntomas\n'
                      '• Síntomas respiratorios\n'
                      '• Factores de riesgo',
                      style: TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              tarjeta(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tituloSeccion('Lógica general', Icons.account_tree),
                    const SizedBox(height: 12),
                    const Text(
                      'La app asigna puntos a diferentes grupos de síntomas. Con base en esos puntos, clasifica la orientación en alergia respiratoria, resfriado común, posible cuadro infeccioso o signos de alerta. También considera factores de riesgo para aumentar el nivel de precaución.',
                      style: TextStyle(fontSize: 15, height: 1.4),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              tarjeta(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tituloSeccion('Aviso importante', Icons.warning_amber),
                    const SizedBox(height: 12),
                    const Text(
                      'Esta aplicación no sustituye una consulta médica profesional. Su objetivo es demostrar el desarrollo de una app funcional en Flutter con lógica condicional, interfaz gráfica, manejo de estado e historial temporal.',
                      style: TextStyle(fontSize: 15, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget encabezadoSecundario({
    required String titulo,
    required String subtitulo,
    required IconData icono,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF00695C),
            Color(0xFF009688),
          ],
        ),
      ),
      child: Row(
        children: [
          Icon(
            icono,
            color: Colors.white,
            size: 46,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitulo,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget paginaSeleccionada() {
    if (paginaActual == 0) {
      return paginaEvaluacion();
    } else if (paginaActual == 1) {
      return paginaHistorial();
    } else {
      return paginaInformacion();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: paginaSeleccionada(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: paginaActual,
        onDestinationSelected: (index) {
          setState(() {
            paginaActual = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.health_and_safety_outlined),
            selectedIcon: Icon(Icons.health_and_safety),
            label: 'Evaluación',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'Historial',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'Información',
          ),
        ],
      ),
    );
  }
}