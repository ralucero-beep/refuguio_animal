import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

// ==================== MODELO ====================

class Mascota {
  final String nombre;
  final String raza;
  final String foto;
  final int edadMeses;
  final String Height;
  final String descripcion;

  // ⚠️ NO lleva "final" porque cambia con el botón de favorito (setState)
  bool favorito;

  Mascota({
    required this.nombre,
    required this.raza,
    required this.foto,
    required this.edadMeses,
    required this.Height,
    required this.descripcion,
    this.favorito = false,
  });

  // 🌐 Puente hacia la unidad de Web Services.
  factory Mascota.fromJson(Map<String, dynamic> json) {
    return Mascota(
      nombre: json['nombre'] as String,
      raza: json['raza'] as String,
      foto: json['foto'] as String,
      edadMeses: json['edadMeses'] as int,
      Height: json['Height'] as String,
      descripcion: json['descripcion'] as String,
      favorito: json['favorito'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'raza': raza,
      'foto': foto,
      'edadMeses': edadMeses,
      'Height': Height,
      'descripcion': descripcion,
      'favorito': favorito,
    };
  }
}

// Lista de ejemplo mientras no hay API conectada.
List<Mascota> mascotasDemo = [
  Mascota(
    nombre: "Rocky",
    raza: "Labrador",
    foto: "imagenes/gato.jpeg",
    edadMeses: 8,
    Height: "Grande",
    descripcion: "Muy juguetón y le encanta correr en el parque.",
  ),
  Mascota(
    nombre: "Michi",
    raza: "Criollo",
    foto: "imagenes/michi.jpeg",
    edadMeses: 5,
    Height: "Pequeño",
    descripcion: "Tranquilo, cariñoso y le gusta dormir al sol.",
  ),
  Mascota(
    nombre: "Max",
    raza: "Pastor Alemán",
    foto: "imagenes/lobo.jpeg",
    edadMeses: 24,
    Height: "Grande",
    descripcion: "Protector, inteligente y le encanta aprender trucos.",
  ),
  Mascota(
    nombre: "Toby",
    raza: "Beagle",
    foto: "imagenes/castor.jpeg",
    edadMeses: 12,
    Height: "Mediano",
    descripcion: "Activo y sociable.",
  ),

  Mascota(
    nombre: "Luna",
    raza: "Siamés",
    foto: "imagenes/pato.jpeg",
    edadMeses: 3,
    Height: "Pequeño",
    descripcion: "Curiosa y muy apegada a las personas.",
  ),
  Mascota(
    nombre: "Bella",
    raza: "Vulpes vulpes",
    foto: "imagenes/zorro.jpeg",
    edadMeses: 18,
    Height: "Grande",
    descripcion: "Amigable, juguetona y muy cariñosa.",
  ),
];

// ==================== APP ====================

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Refugio de Mascotas',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const RefugioScreen(),
    );
  }
}

// ==================== PANTALLA LISTA ====================

class RefugioScreen extends StatefulWidget {
  const RefugioScreen({super.key});

  @override
  State<RefugioScreen> createState() => _RefugioScreenState();
}

class _RefugioScreenState extends State<RefugioScreen> {
  final List<Mascota> mascotas = mascotasDemo;

  @override
  void initState() {
    super.initState();
    mascotas.sort((a, b) => a.nombre.compareTo(b.nombre)); // Orden alfabético
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Refugio de Mascotas")),
      body: Column(
        children: [
          // 📸 Lista horizontal de fotos
          SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mascotas.length,
              itemBuilder: (context, index) {
                final mascota = mascotas[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundImage: AssetImage(mascota.foto),
                  ),
                );
              },
            ),
          ),
          const Divider(color: Colors.orange, thickness: 1),

          // 📋 Lista vertical con separador
          Expanded(
            child: ListView.separated(
              itemCount: mascotas.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return _buildMascotaTile(mascotas[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMascotaTile(Mascota mascota) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: AssetImage(mascota.foto)),
      title: Text(mascota.nombre),
      subtitle: Text("${mascota.raza} · ${mascota.edadMeses} meses"),
      trailing: IconButton(
        icon: Icon(
          mascota.favorito ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: () {
          setState(() {
            mascota.favorito = !mascota.favorito;
          });
        },
      ),
      onTap: () async {
        // Esperamos a que regrese de la pantalla de detalles y actualizamos el estado
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalleMascotaScreen(mascota: mascota),
          ),
        );
        setState(() {}); // Refresca la lista principal al volver del detalle
      },
    );
  }
}

// ==================== PANTALLA DETALLE ====================

// Cambiado a StatefulWidget para permitir refrescar el icono de favorito dentro del detalle
class DetalleMascotaScreen extends StatefulWidget {
  final Mascota mascota;

  const DetalleMascotaScreen({super.key, required this.mascota});

  @override
  State<DetalleMascotaScreen> createState() => _DetalleMascotaScreenState();
}

class _DetalleMascotaScreenState extends State<DetalleMascotaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.mascota.nombre)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 90,
              backgroundImage: AssetImage(widget.mascota.foto),
            ),
            const SizedBox(height: 16),
            Text(
              widget.mascota.nombre,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(
                widget.mascota.favorito
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.red,
                size: 30,
              ),
              onPressed: () {
                setState(() {
                  widget.mascota.favorito = !widget.mascota.favorito;
                });
              },
            ),
            const SizedBox(height: 20),
            _buildDato("Raza", widget.mascota.raza),
            _buildDato("Edad", "${widget.mascota.edadMeses} meses"),
            _buildDato("Tamaño", widget.mascota.Height),
            _buildDato("Descripción", widget.mascota.descripcion),
          ],
        ),
      ),
    );
  }

  Widget _buildDato(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            etiqueta,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(valor, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

//sdfghjk
