import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_structure/core/common/widgets/app_snackber.dart';
import 'package:project_structure/features/producer/data/models/product_model.dart';
import 'package:project_structure/features/producer/presentation/controllers/product_list_controller.dart';

class ProductAddController extends GetxController {
  final RxList<String> imagePaths = <String>[].obs;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final RxString selectedCategory = ''.obs;
  final RxString selectedUnit = ''.obs;
  final RxBool isCertified = false.obs;

  final RxBool isFormValid = false.obs;

  final List<String> categories = [
    'Vegetables',
    'Fruits',
    'Grains & Cereals',
    'Spices & Herbs',
    'Processed Foods',
    'Dairy & Eggs',
    'Poultry & Meat',
    'Tubers & Roots',
    'Seafood & Fish',
    'Nuts & Seeds',
    'Beverages',
    'Legumes & Pulses',
    'Baked Goods',
  ];

  final List<String> units = [
    'kg',
    'g',
    'tonne',
    'bag',
    'crate',
    'basket',
    'box',
    'dozen',
    'litre',
    'piece',
    'bundle',
  ];

  @override
  void onInit() {
    super.onInit();
    productNameController.addListener(_checkFormValidation);
    priceController.addListener(_checkFormValidation);
    quantityController.addListener(_checkFormValidation);
    selectedCategory.listen((_) => _checkFormValidation());
    selectedUnit.listen((_) => _checkFormValidation());
  }

  @override
  void onClose() {
    productNameController.dispose();
    priceController.dispose();
    quantityController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void _checkFormValidation() {
    isFormValid.value = productNameController.text.trim().isNotEmpty &&
        selectedCategory.value.isNotEmpty &&
        priceController.text.trim().isNotEmpty &&
        selectedUnit.value.isNotEmpty &&
        quantityController.text.trim().isNotEmpty;
  }

  Future<void> pickImage() async {
    if (imagePaths.length >= 5) {
      AppSnackBar.error('You can only upload up to 5 photos.');
      return;
    }
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Photo Source',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                Get.back();
                final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
                if (photo != null) {
                  imagePaths.add(photo.path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Get.back();
                final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  imagePaths.add(image.path);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void removeImage(int index) {
    if (index >= 0 && index < imagePaths.length) {
      imagePaths.removeAt(index);
    }
  }

  void saveProduct() {
    if (!isFormValid.value) {
      AppSnackBar.error('Please fill in all required fields.');
      return;
    }

    final double price = double.tryParse(priceController.text.trim()) ?? 0.0;
    final int stock = int.tryParse(quantityController.text.trim()) ?? 0;

    final newProduct = ProductModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: productNameController.text.trim(),
      category: selectedCategory.value,
      price: price,
      unit: selectedUnit.value,
      stock: stock,
      status: 'Active',
      imageUrl: imagePaths.isNotEmpty 
          ? imagePaths.first 
          : 'https://images.unsplash.com/photo-1595855759920-86582396756a?w=400',
      sold: 0,
      rating: 0.0,
      ratingCount: 0,
      description: descriptionController.text.trim(),
      location: 'Kaduna State, Nigeria',
      listedDate: 'June 30, 2026',
    );

    if (Get.isRegistered<ProductListController>()) {
      final listController = Get.find<ProductListController>();
      listController.products.insert(0, newProduct);
    }

    AppSnackBar.success('Product added successfully!');
    Get.back();
  }
}
