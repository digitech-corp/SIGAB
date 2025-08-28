import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:balanced_foods/models/customer.dart';
import 'package:balanced_foods/models/entrega.dart';
import 'package:balanced_foods/providers/customers_provider.dart';
import 'package:balanced_foods/providers/entregas_provider.dart';
import 'package:balanced_foods/providers/facturas_provider.dart';
import 'package:balanced_foods/providers/users_provider.dart';
import 'package:balanced_foods/screens/Transportista/transport_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';

class EntregasPendientesScreen extends StatefulWidget {
  const EntregasPendientesScreen({super.key});

  @override
  State<EntregasPendientesScreen> createState() => _EntregasPendientesScreenState();
}

class _EntregasPendientesScreenState extends State<EntregasPendientesScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async{
      final customersProvider = Provider.of<CustomersProvider>(context, listen: false);
      final entregasProvider = Provider.of<EntregasProvider>(context, listen: false);

      final userProvider = Provider.of<UsersProvider>(context, listen: false);
      final idTransportista = userProvider.loggedUser?.idTransportista ?? null;
      final token = userProvider.token;

      await customersProvider.fetchCustomers(token!);
      await entregasProvider.fetchEntregas(token, DateFormat('yyyy-MM-dd').format(selectedDate), DateFormat('yyyy-MM-dd').format(selectedDate), idTransportista);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      final usersProvider = Provider.of<UsersProvider>(context, listen: false);
      final idTransportista = usersProvider.loggedUser?.idTransportista ?? null;
      final token = usersProvider.token;
      final entregasProvider = Provider.of<EntregasProvider>(context, listen: false);
      await entregasProvider.fetchEntregas(token!, DateFormat('yyyy-MM-dd').format(selectedDate), DateFormat('yyyy-MM-dd').format(selectedDate), idTransportista);
    }
  }

  @override
  Widget build(BuildContext context) {
    final entregasProvider = Provider.of<EntregasProvider>(context);
    final customersProvider = Provider.of<CustomersProvider>(context);
    final usersProvider = Provider.of<UsersProvider>(context, listen: false);
    final token = usersProvider.token;
    final entrega = entregasProvider.entregas;
    final isLoading = entregasProvider.isLoading;
    final customers = customersProvider.customers;

    final filteredEntregas = entrega.where((entrega) {
      final fecha = entrega.fechaProgramacion;
      final estadosPermitidos = [237, 238];
      if (fecha == null || token == null) return false;

      return fecha.year == selectedDate.year &&
            fecha.month == selectedDate.month &&
            fecha.day == selectedDate.day &&
            estadosPermitidos.contains(entrega.idEstado);
    }).toList();

    final Map<String, List<Entrega>> entregasPorZona = {};

    for (var e in filteredEntregas) {
      final zona = e.nombreRuta ?? 'Sin zona';
      entregasPorZona.putIfAbsent(zona, () => []).add(e);
    }

    // Prioridad ordenada: Alta > Media > Baja
    const prioridadOrden = {'Alta': 0, 'Media': 1, 'Baja': 2};

    // Ordenamos cada lista de entregas por prioridad
    entregasPorZona.forEach((zona, lista) {
      lista.sort((a, b) {
        final prioridadA = prioridadOrden[a.prioridad ?? 'Media'] ?? 1;
        final prioridadB = prioridadOrden[b.prioridad ?? 'Media'] ?? 1;
        return prioridadA.compareTo(prioridadB);
      });
    });
        
    return Scaffold(
      backgroundColor: AppColors.backgris,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
          child: AppBar(
            toolbarHeight: 80,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            title: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => TransportScreen()),
                    );
                  },
                ),
                const SizedBox(width: 1),
                Text('MODULO DE TRANSPORTISTA', style: AppTextStyles.title),
              ],
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pendientes del día', style: AppTextStyles.subtitle),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Text(DateFormat('dd/MM/yyyy').format(selectedDate), style: AppTextStyles.date),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.backgris, thickness: 1.0),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : entregasPorZona.isEmpty
                      ? const Center(child: Text('No hay pedidos disponibles'))
                      : ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                          children: entregasPorZona.entries.map((entry) {
                            final zona = entry.key;
                            final entregasZona = entry.value;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Zona: $zona',
                                  style: AppTextStyles.subtitle, // o cualquier estilo que uses
                                ),
                                const SizedBox(height: 6),
                                ...entregasZona.map((entrega) {
                                  final firstDetail = entrega.idCustomer;
                                  Customer? customer;
                                  try {
                                    customer = customers.firstWhere((c) => c.idCliente == firstDetail);
                                  } catch (_) {
                                    customer = null;
                                  }

                                  String persona = '--';
                                  String empresa = '--';
                                  String fullAddress = entrega.direccionEntrega ?? '--';
                                  String customerPhone = '--';
                                  String prioridad = entrega.prioridad!;

                                  if (customer != null) {
                                    persona = '${customer.nombres} ${customer.apellidos}';
                                    empresa = customer.razonSocialAfiliada.isNotEmpty
                                        ? customer.razonSocialAfiliada
                                        : "Sin empresa afiliada";
                                    customerPhone = customer.numero;
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    child: OrderCard(
                                      empresa: empresa,
                                      persona: persona,
                                      prioridad : prioridad,
                                      customerPhone: customerPhone,
                                      idOrder: entrega.idOrder,
                                      fullAddress: fullAddress,
                                    ),
                                  );
                                }).toList(),
                                const SizedBox(height: 20),
                              ],
                            );
                          }).toList(),
                        ),
            ),
          ],
        ),
      ),
    );
  } 
}

class OrderCard extends StatefulWidget {
  final empresa;
  final persona;
  final prioridad;
  final customerPhone;
  final idOrder;
  final fullAddress;
  
  const OrderCard({super.key, required this.empresa, required this.prioridad, required this.persona, required this.customerPhone, required this.idOrder, required this.fullAddress});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isExpanded = false;
  final _formKey = GlobalKey<FormState>();
  final _incidencias = TextEditingController();
  final _firma = TextEditingController();
  final List<XFile> _images = [];

  @override
  Widget build(BuildContext context) {
    final codPedido = 'PEDIDO N° ${widget.idOrder.toString().padLeft(2, '0')}-2025';
    final prioridad = widget.prioridad;
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.empresa, style: AppTextStyles.company),
                      const SizedBox(height: 2),
                      Text(widget.persona, style: AppTextStyles.orderData),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(codPedido, style: AppTextStyles.orderData),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTextStyles.prioridadBackground(prioridad),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Text(
                              prioridad.toUpperCase(),
                              style: AppTextStyles.prioridadTextStyle(prioridad),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: SizedBox(
                    width: 20,
                    height: 20,
                    child: Image.asset(
                      'assets/images/gps.png',
                      color: AppColors.orange,
                    ),
                  ),
                  onPressed: () async {
                    final Uri mapsUri = Uri.parse(
                      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(widget.fullAddress)}',
                    );
                    if (await canLaunchUrl(mapsUri)) {
                      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
                    } else {
                      debugPrint('No se pudo abrir Google Maps');
                    }
                  },
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      IconButton(
                        iconSize: 20,
                        visualDensity: VisualDensity.compact,
                        icon: SizedBox(
                          width: 16,
                          height: 16,
                          child: Image.asset('assets/images/phone.png', color: AppColors.orange),
                        ),
                        onPressed: () async {
                          if (widget.customerPhone.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('No hay número registrado')),
                            );
                            return;
                          }
                          final Uri callUri = Uri(scheme: 'tel', path: '+51${widget.customerPhone}');
                          if (await canLaunchUrl(callUri)) {
                            await launchUrl(callUri);
                          } else {
                            debugPrint('No se pudo lanzar $callUri');
                          }
                        },
                      ),
                      IconButton(
                        iconSize: 20,
                        visualDensity: VisualDensity.compact,
                        icon: SizedBox(
                          width: 16,
                          height: 16,
                          child: Image.asset('assets/images/whatsapp.png', color: AppColors.orange),
                        ),
                        onPressed: () async {
                          if (widget.customerPhone.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('No hay número registrado')),
                            );
                            return;
                          }
                          final Uri whatsappUri = Uri.parse("https://wa.me/+51${widget.customerPhone}");
                          if (await canLaunchUrl(whatsappUri)) {
                            await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
                          } else {
                            debugPrint('No se pudo abrir WhatsApp para +51${widget.customerPhone}');
                          }
                        },
                      ),
                    ],
                  ),
                ),
                // Icono de archivo
                Expanded(
                  flex: 1,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        final facturaProvider = Provider.of<FacturasProvider>(context, listen: false);
                        final token = Provider.of<UsersProvider>(context, listen: false).token;
                        facturaProvider.generarTicket(token!, widget.idOrder);
                      },
                      child: const Icon(Icons.attach_file, color: Colors.black, size: 18),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      height: 22,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                            if (states.contains(WidgetState.pressed)) return AppColors.orange;
                            return Colors.white;
                          }),
                          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                            if (states.contains(WidgetState.pressed)) return Colors.white;
                            return AppColors.orange;
                          }),
                          side: WidgetStateProperty.all(const BorderSide(color: AppColors.orange)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          ),
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: Text('Detalles entrega', style: AppTextStyles.btnDetails),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_isExpanded)
              OrderExpandedDetail(
                idOrder: widget.idOrder,
                formKey: _formKey,
                incidencias: _incidencias,
                firma: _firma,
                images: _images,
              ),
          ],
        ),
      ),
    );
  }
}

class OrderExpandedDetail extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController  incidencias;
  final TextEditingController  firma;
  final List<XFile> images;
  final idOrder;
  
  const OrderExpandedDetail({
    super.key,
    required this.formKey,
    required this.incidencias,
    required this.firma,
    required this.images,
    required this.idOrder,
  });

  @override
  State<OrderExpandedDetail> createState() => _OrderExpandedDetailState();
}

class _OrderExpandedDetailState extends State<OrderExpandedDetail> {
  DateTime selectedDate = DateTime.now();
  final ImagePicker _picker = ImagePicker();
  Uint8List? _firmaImage;
  XFile? _selectedImage;
  String? _base64Image;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      final mimeType = lookupMimeType(image.path);
      final base64Image = 'data:$mimeType;base64,${base64Encode(bytes)}';
      setState(() {
        _selectedImage = image;
        _base64Image = base64Image;
      });
    }
  }

  SignatureController? _firmaController;

  @override
  void initState() {
    super.initState();
    _firmaController = SignatureController(
      penStrokeWidth: 2,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _firmaController?.dispose();
    super.dispose();
  }

  void _abrirDialogoFirma() {
    if (_firmaController == null) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Firmar'),
          content: SizedBox(
            width: 320,
            height: 400,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                    child: Signature(controller: _firmaController!),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _firmaController?.clear(),
                      child: const Text('Borrar'),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_firmaController != null && _firmaController!.isNotEmpty) {
                          final image = await _firmaController!.toPngBytes();
                          if (image != null) {
                            final base64 = base64Encode(image);
                            widget.firma.text = 'data:image/png;base64,$base64';
                            setState(() {
                              _firmaImage = image;
                            });
                          }
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text('Guardar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.all(16),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Text(
            'Detalles de Entrega:',
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 10, fontWeight: FontWeight.w400),
          ),
        ),
        const Divider(color: Color(0xFFBDBDBD), thickness: 1.0, height: 0),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildEntregaSection(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildEntregaSection() {
    assert(_firmaController != null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFieldRow('Registro de Incidencias:', TextFormField(
          controller: widget.incidencias,
          style: const TextStyle(fontSize: 10),
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            border: UnderlineInputBorder(),
          ),
        )),
        const SizedBox(height: 10),
        _buildFieldRow(
          'Firma del cliente:',
          GestureDetector(
            onTap: _abrirDialogoFirma,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey)),
              ),
              width: double.infinity,
              child: _firmaImage != null
                  ? Image.memory(_firmaImage!, height: 50)
                  : const Text(
                      'Toque para firmar',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildFieldRow('Fotos de entrega:', GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey),
            ),
            child: const Icon(Icons.add_photo_alternate, size: 20),
          ),
        )),
        const SizedBox(height: 10),
        if (_selectedImage != null)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.file(
                  File(_selectedImage!.path),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedImage = null;
                      widget.images.clear();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: const Icon(Icons.close, size: 14, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        const SizedBox(height: 16),
        btnConfirmar(
          idOrder: widget.idOrder,
          firma: widget.firma,
          incidencias: widget.incidencias,
          archivoEvidencia: _base64Image ?? '',
        ),
      ],
    );
  }

  Widget _buildFieldRow(String label, Widget field) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: field),
      ],
    );
  }
}

class btnConfirmar extends StatefulWidget {
  final idOrder;
  final TextEditingController firma;
  final TextEditingController incidencias;
  final String? archivoEvidencia;

  const btnConfirmar({
    super.key,
    required this.idOrder,
    required this.firma,
    required this.incidencias,
    required this.archivoEvidencia,
  });

  @override
  State<btnConfirmar> createState() => _btnConfirmarState();
}

class _btnConfirmarState extends State<btnConfirmar> {
  final formKey = GlobalKey<FormState>();

  Future<void> _registerDelivery({required int idEstadoNuevo, bool denied = false}) async {
    final entregasProvider = Provider.of<EntregasProvider>(context, listen: false); 
    final token = Provider.of<UsersProvider>(context, listen: false).token;
    await entregasProvider.fetchEstadoEntrega(token!, widget.idOrder);
    final entregaAnterior = entregasProvider.entregaAnterior;

    final entrega = Entrega(
      idEstadoAnterior: entregaAnterior.first.id,
      idEstadoNuevo: idEstadoNuevo,
      incidencias: widget.incidencias.text,
      archivoEvidencia: widget.archivoEvidencia,
      firma: denied ? '' : widget.firma.text,
    );

    final success = await entregasProvider.registerEntrega(token, entrega);

    if (success) {
      setState(() {
        widget.incidencias.clear();
        widget.firma.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(denied ? 'No entregado' : 'Entrega registrada exitosamente')),
      );
    }
  }

  Future<void> _showConfirmationDialog({required bool isDenegar}) async {
    final entregasProvider = Provider.of<EntregasProvider>(context, listen: false); 
    final token = Provider.of<UsersProvider>(context, listen: false).token;
    final userProvider = Provider.of<UsersProvider>(context, listen: false);
    final idTransportista = userProvider.loggedUser?.idTransportista ?? null;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isDenegar ? 'No Entregado' : 'Confirmar Entrega'),
        content: Text(isDenegar
            ? '¿Estás seguro de que deseas no confirmar esta entrega?'
            : '¿Estás seguro de que deseas confirmar esta entrega?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.orange),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final int estado = isDenegar ? 240 : 239;
      await _registerDelivery(idEstadoNuevo: estado, denied: isDenegar);

      await Future.delayed(const Duration(seconds: 1));
      await entregasProvider.fetchEntregas(
        token!,
        DateFormat('yyyy-MM-dd').format(DateTime.now()),
        DateFormat('yyyy-MM-dd').format(DateTime.now()),
        idTransportista,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 22,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightGris,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: () => _showConfirmationDialog(isDenegar: true),
            child: Text('No Entregado', style: AppTextStyles.btnDetails),
          ),
        ),
        SizedBox(
          height: 22,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: () => _showConfirmationDialog(isDenegar: false),
            child: Text('Confirmar Entrega', style: AppTextStyles.btnConfirmar),
          ),
        ),
      ],
    );
  }
}

class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w300,
    fontSize: 10,
    color: Colors.black
  );
  static final title = base.copyWith(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.gris);
  static final subtitle = base.copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.gris);
  static final date = base.copyWith(fontSize: 12, color: AppColors.gris);
  static final company = base.copyWith(fontSize: 12, color: AppColors.orange, fontWeight: FontWeight.w500);
  static final orderData = base.copyWith();
  static final btnDetails = base.copyWith(fontWeight: FontWeight.w400, color: AppColors.orange);
  static final detailsHead = base.copyWith(fontWeight: FontWeight.w400);
  static final btnConfirmar = base.copyWith(fontWeight: FontWeight.w400, color: Colors.white);

  static TextStyle prioridadTextStyle(String prioridad) {
    Color color;
    switch (prioridad.toLowerCase()) {
      case 'alta':
        color = AppColors.red;
        break;
      case 'media':
        color = AppColors.orangeLight;
        break;
      case 'baja':
        color = AppColors.green;
        break;
      default:
        color = AppColors.gris;
    }
    return base.copyWith(fontSize: 9, fontWeight: FontWeight.w400, color: color);
  }

  static Color prioridadBackground(String prioridad) {
    switch (prioridad.toLowerCase()) {
      case 'alta':
        return Color(0xFFFEE2E2);
      case 'media':
        return Color(0xFFFeF9C3);
      case 'baja':
        return Color(0xFFDCFCE7);
      default:
        return Color(0xFFEEEEEE);
    }
  }
}

class AppColors {
  static const orange = Color(0xFFFF6600);
  static const gris = Color(0xFF333333);
  static const backgris = Color(0xFFECEFF1);
  static const lightGris = Color(0xFFBDBDBD);
  static const red = Color(0xFF991B1B);
  static const orangeLight = Color(0xFF854D0E);
  static const green = Color(0xFF166534);
}