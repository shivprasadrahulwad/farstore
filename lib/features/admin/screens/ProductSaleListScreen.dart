import 'package:farstore/models/bestProducts.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ProductSaleListScreen extends StatefulWidget {
  const ProductSaleListScreen({Key? key}) : super(key: key);

  @override
  _ProductSaleListScreenState createState() => _ProductSaleListScreenState();
}

class _ProductSaleListScreenState extends State<ProductSaleListScreen> {
  late Box<BestProduct> _bestProductBox;
  String _sortColumn = ''; // Track which column is being sorted
  bool _isAscending = true; // Track sort direction

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    _bestProductBox = await Hive.openBox<BestProduct>('bestProductsBox');
    setState(() {}); // Trigger a rebuild to show data
  }

  // Sort function
  void _sort(String column) {
    setState(() {
      if (_sortColumn == column) {
        // If clicking the same column, reverse the sort direction
        _isAscending = !_isAscending;
      } else {
        // New column, set it as sort column and default to ascending
        _sortColumn = column;
        _isAscending = true;
      }
    });
  }

  // Get sorted list of products
  List<BestProduct> _getSortedProducts() {
    List<BestProduct> products = _bestProductBox.values.toList();

    switch (_sortColumn) {
      case 'name':
        products.sort((a, b) => _isAscending
            ? a.name.compareTo(b.name)
            : b.name.compareTo(a.name));
        break;
      case 'quantity':
        products.sort((a, b) => _isAscending
            ? a.quantity.compareTo(b.quantity)
            : b.quantity.compareTo(a.quantity));
        break;
      case 'basePrice':
        products.sort((a, b) => _isAscending
            ? a.basePrice!.compareTo(b.basePrice!.toDouble())
            : b.basePrice!.compareTo(a.basePrice!.toDouble()));
        break;
      case 'sellingPrice':
        products.sort((a, b) => _isAscending
            ? a.sellingPrice!.compareTo(b.sellingPrice!.toDouble())
            : b.sellingPrice!.compareTo(a.sellingPrice!.toDouble()));
        break;
      case 'discountPrice':
        products.sort((a, b) => _isAscending
            ? a.discountPrice!.compareTo(b.discountPrice!.toDouble())
            : b.discountPrice!.compareTo(a.discountPrice!.toDouble()));
        break;
      case 'profit':
        products.sort((a, b) {
          double profitA = a.basePrice! - a.discountPrice!.toDouble();
          double profitB = b.basePrice! - b.discountPrice!.toDouble();
          return _isAscending
              ? profitA.compareTo(profitB)
              : profitB.compareTo(profitA);
        });
        break;
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Products Sales",style: TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 1000,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTableHeader(),
                const Divider(color: Colors.black, thickness: 1),
                Expanded(
                  child: _buildProductList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          // Sr. No Column
          const SizedBox(
            width: 80,
            child: Text(
              'Sr. No',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 16),

          // Product Name Column
          SizedBox(
            width: 200,
            child: InkWell(
              onTap: () => _sort('name'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Product Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (_sortColumn == 'name')
                    Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Quantity Column
          SizedBox(
            width: 100,
            child: InkWell(
              onTap: () => _sort('quantity'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Quantity',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (_sortColumn == 'quantity')
                    Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Base Price Column
          SizedBox(
            width: 120,
            child: InkWell(
              onTap: () => _sort('basePrice'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Base Price',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (_sortColumn == 'basePrice')
                    Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Selling Price Column
          SizedBox(
            width: 120,
            child: InkWell(
              onTap: () => _sort('sellingPrice'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Selling Price',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (_sortColumn == 'sellingPrice')
                    Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Discount Price Column
          SizedBox(
            width: 130,
            child: InkWell(
              onTap: () => _sort('discountPrice'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Discount Price',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (_sortColumn == 'discountPrice')
                    Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Profit Column
          SizedBox(
            width: 120,
            child: InkWell(
              onTap: () => _sort('profit'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Profit',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (_sortColumn == 'profit')
                    Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList() {
    if (_bestProductBox == null || _bestProductBox.isEmpty) {
      return const Center(
        child: Text(
          'No products found',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    final sortedProducts = _getSortedProducts();

    return ListView.separated(
      itemCount: sortedProducts.length,
      separatorBuilder: (context, index) => Divider(color: Colors.grey[300]),
      itemBuilder: (context, index) {
        final product = sortedProducts[index];
        final profit = (product.basePrice)! - (product.discountPrice!.toDouble());

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  '${index + 1}',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 16),

              SizedBox(
                width: 200,
                child: Text(
                  product.name,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 16),

              SizedBox(
                width: 100,
                child: Text(
                  '${product.quantity}',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 16),

              SizedBox(
                width: 120,
                child: Text(
                  '\₹${product.basePrice!.toStringAsFixed(0)}',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 16),

              SizedBox(
                width: 120,
                child: Text(
                  '\₹${product.sellingPrice!.toStringAsFixed(0)}',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 16),

              SizedBox(
                width: 120,
                child: Text(
                  '\₹${product.discountPrice!.toStringAsFixed(0)}',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 16),

              SizedBox(
                width: 120,
                child: Text(
                  '\₹${profit.toStringAsFixed(0)}',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _bestProductBox.close();
    super.dispose();
  }
}