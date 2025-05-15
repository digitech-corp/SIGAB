import 'package:balanced_foods/screens/sales_module_screen.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class FollowScreen extends StatefulWidget {
  const FollowScreen({super.key});

  @override
  State<FollowScreen> createState() => _FollowScreenState();
}

class _FollowScreenState extends State<FollowScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bodyPadding = screenWidth * 0.06;
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: const FollowScreenHeader(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: bodyPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleAndDate(),
              const Divider(color: AppColors.grey, thickness: 1.0),
              const SizedBox(height: 10),
              const FollowOrderHeaderRow(),
              const Divider(color: AppColors.grey, thickness: 1.0),
              const SizedBox(height: 10),
              const OrderCard(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Pedidos del día', style: AppTextStyles.subtitle),
        Text('{20/05/2025}', style: AppTextStyles.date),
      ],
    );
  }
}

class FollowScreenHeader extends StatelessWidget implements PreferredSizeWidget {
  const FollowScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SalesModuleScreen()),
                );
              },
            ),
            const SizedBox(width: 1),
            Text('Modulo de Seguimiento de Pedidos', style: AppTextStyles.title),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class FollowOrderHeaderRow extends StatelessWidget {
  const FollowOrderHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Item', style: AppTextStyles.itemTable),
        Text('N° Pedido', style: AppTextStyles.itemTable),
        Text('Estado', style: AppTextStyles.itemTable),
        Text('F. entrega', style: AppTextStyles.itemTable),
        Text('Lugar', style: AppTextStyles.itemTable),
        Text('Detalle', style: AppTextStyles.itemTable),
      ],
    );
  }
}

class OrderCard extends StatefulWidget {
  const OrderCard({super.key});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          SizedBox(
            height: 30,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('{01}', style: AppTextStyles.weak),
                  Text('{P-51-2025}', style: AppTextStyles.weak),
                  Text('{Pendiente}', style: AppTextStyles.red),
                  Text('{20/05/25}', style: AppTextStyles.weak),
                  Text('{Chongoyape}', style: AppTextStyles.weak),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Image.asset(
                      _isExpanded 
                        ? 'assets/images/eyeOpen.png' 
                        : 'assets/images/eyeClose.png',
                      width: 15,
                      height: 15,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() => _isExpanded = !_isExpanded);
                    },
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) const OrderExpandedDetail(),
        ],
      ),
    );
  }
}

class OrderExpandedDetail extends StatelessWidget {
  const OrderExpandedDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resumen del Pedido:', style: AppTextStyles.strong),
          const SizedBox(height: 5),
          _buildResumenBox(),
          const SizedBox(height: 3),
          _buildTotalesBox(screenWidth),
          const SizedBox(height: 5),
          _buildPagoRow(screenWidth),
          const SizedBox(height: 10),
          _buildEntregaSection(screenWidth),
          const SizedBox(height: 10),
          Text('Ubicación Geográfica', style: AppTextStyles.strong),
          const SizedBox(height: 10),
          _buildMapBox(),
        ],
      ),
    );
  }

  Widget _buildResumenBox() => Container(
    height: 80,
    width: double.infinity,
    color: const Color(0xFFE5E7E7),
    child: const Center(
      child: Text('Tabla', style: TextStyle(fontSize: 10)),
    ),
  );
  
  Widget _buildTotalesBox(double screenWidth) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        height: 80,
        width: screenWidth*0.4,
        color: const Color(0xFFE5E7E7),
        child: const Center(
          child: Text('Totales', style: TextStyle(fontSize: 10)),
        ),
      ),
    ],
  );

  Widget _buildPagoRow(double screenWidth) => Row(
    children: [
      Text('Tipo de Pago', style: AppTextStyles.strong),
      SizedBox(width: min(screenWidth * 0.088, 350)),
      Text('Contado', style: AppTextStyles.weak),
    ],
  );

  Widget _buildEntregaSection(double screenWidth) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(children: [Text('Datos de Entrega', style: AppTextStyles.strong)]),
      SizedBox(width: screenWidth * 0.040),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Lugar:', style: AppTextStyles.weak),
          SizedBox(height: 5),
          Text('Fecha:', style: AppTextStyles.weak),
          SizedBox(height: 5),
          Text('Hora:', style: AppTextStyles.weak),
          SizedBox(height: 5),
          Text('Observación', style: AppTextStyles.weak),
        ],
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('{Dirección fiscal}', style: AppTextStyles.weak),
            SizedBox(height: 5),
            Text('{25/05/2025}', style: AppTextStyles.weak),
            SizedBox(height: 5),
            Text('{11:30 am}', style: AppTextStyles.weak),
            SizedBox(height: 5),
            Text('{Dejar frente al grifo San Antonio}', style: AppTextStyles.weak),
          ],
        ),
      ),
    ],
  );

  Widget _buildMapBox() => Container(
    height: 150,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Image.asset('assets/images/map.png', fit: BoxFit.cover),
    ),
  );
}


class AppTextStyles {
  static const base = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 10,
    color: AppColors.darkGrey,
    fontWeight: FontWeight.w400
  );
  static final weak = base.copyWith(fontWeight: FontWeight.w300);
  static final strong = base.copyWith();
  static final title = base.copyWith(fontSize: 16,fontWeight: FontWeight.w600);
  static final subtitle = base.copyWith(fontSize: 14,fontWeight: FontWeight.w500);
  static final date = base.copyWith(fontSize: 12,fontWeight: FontWeight.w300);
  static final itemTable = base.copyWith(fontSize: 12);
  static final red = base.copyWith(color: AppColors.red);
}

class AppColors {
  static const red = Color(0xFFE74C3C);
  static const darkGrey = Color(0xFF333333);
  static const grey = Color(0xFFBDBDBD);
  static const lightGrey = Color(0xFFECEFF1);
}