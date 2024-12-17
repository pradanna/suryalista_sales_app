import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:suryalita_sales_app/model/Item.dart';
import 'package:suryalita_sales_app/model/paginationMeta.dart';
import 'package:suryalita_sales_app/services/itemService.dart';

class SearchProductController extends GetxController {
  final ItemService _itemService = ItemService();

  var items = <Item>[].obs;
  var isEmpty = false.obs;
  var isLoading = false.obs;
  var isLoadingLoadMore = false.obs;
  var currentPage = 1.obs;
  var totalPages = 2.obs;
  var hasNextPage = true.obs;
  PaginationMeta? pagination;

  // Filter dan parameter pencarian
  var categoryId = ''.obs;
  var categoryName = ''.obs;
  var search = ''.obs;
  var sortBy = 'name'.obs;
  var sortByText = 'name A-Z'.obs;
  var sortByvalue = 'nameasc'.obs;
  var sortOrder = 'asc'.obs;

  final Logger logger = Logger();

  @override
  void onInit() {
    super.onInit();
    // Ambil data pertama kali
  }

  // Fungsi untuk mengambil data item
  Future<void> fetchItems({bool reset = false}) async {

    if (isLoading == false && isLoadingLoadMore == false) {
      print("current page " + currentPage.value.toString());

      if (reset) {
        print("Reset currentpage");
        if (isLoading.value) return;
        isLoading.value = true;
        currentPage.value = 1;
        totalPages.value = 2;
        items.clear();
      } else {
        isLoadingLoadMore.value = true;
        print("LOAD MORE");
      }

      if (totalPages <= currentPage.value) {
        // showSnackbarError('Data Item sudah ditampilkan semua', '');
        isLoadingLoadMore.value = false;
      } else {
        print("kategori idnya "+categoryId.value);
        print("Sort by "+sortBy.value);
        print("Sort Order "+sortOrder.value);
        print("Sort Val "+sortByvalue.value);

        if(sortByvalue == "ascname"){
          sortOrder = "asc".obs;
        }else if(sortByvalue == "descname"){
          sortOrder = "desc".obs;
        }else{
          sortOrder = "asc".obs;
        }
        try {
          final fetchedItems = await _itemService.fetchItems(
            categoryId: categoryId.value.isEmpty ? null : categoryId.value,
            search: search.value.isEmpty ? null : search.value,
            sortBy: sortBy.value,
            sortOrder: sortOrder.value,
            page: currentPage.value,
          );

          if (fetchedItems['items'] == null) {
            if (!isLoadingLoadMore.value) {
              isEmpty.value = true;
            }
            hasNextPage.value = false;
          } else {
            items.addAll(fetchedItems['items']);
            pagination = fetchedItems['pagination'];

            totalPages.value = pagination!.totalPages;
            currentPage.value = currentPage.value + 1;
            isEmpty.value = false;
          }
        } catch (e) {
          // Get.snackbar('Error', 'Failed to load items: $e');
          print("fetching data error $e");
        } finally {
          isLoading.value = false;
          isLoadingLoadMore.value = false;
          print("isEmtpty $isEmpty");
        }
      }
    }
  }

  // Fungsi untuk reset filter dan pencarian
  void resetFilters() {
    categoryId.value = '';
    search.value = '';
    sortBy.value = 'name';
    sortOrder.value = 'asc';
    fetchItems(reset: true);
  }
}
