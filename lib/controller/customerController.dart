import 'package:get/get.dart';
import 'package:suryalita_sales_app/model/Customer.dart';
import 'package:suryalita_sales_app/services/customerService.dart';

class CustomerController extends GetxController {
  var isLoading = false.obs;
  var customers = <Customer>[].obs;
  var filteredCustomers = <Customer>[].obs;
  final CustomerService _service = CustomerService();
  var selectedCustomer = Rx<Customer?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchTokoCustomers();
  }

  void fetchTokoCustomers() async {
    isLoading.value = true;
    try {
      final result = await _service.getTokoCustomers();
      customers.assignAll(result);
      filteredCustomers.assignAll(customers);

    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void searchCustomer(String query) {
    if (query.isEmpty) {
      filteredCustomers.assignAll(customers);
    } else {
      filteredCustomers.assignAll(
        customers.where((customer) => customer.name.toLowerCase().contains(query.toLowerCase())).toList(),
      );
    }
  }

  void setSelectedCustomer(Customer customer) {
    selectedCustomer.value = customer;
  }
}
