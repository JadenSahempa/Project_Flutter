import 'package:get/get.dart';

typedef FetchPageCallback<T> = Future<List<T>> Function(int page, int pageSize);

class PaginationController<T> {
  PaginationController({required this.pageSize, required this.fetchPage});

  /// jumlah item per halaman (page size), misal: 20
  final int pageSize;

  /// callback untuk ambil data per halaman
  final FetchPageCallback<T> fetchPage;

  /// data yang dipakai di UI
  final items = <T>[].obs;

  /// state
  final isLoadingFirstPage = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final error = RxnString();

  int _currentPage = 0;

  bool get isEmpty => items.isEmpty;

  /// Load ulang dari awal (first load / pull-to-refresh)
  Future<void> loadFirstPage() async {
    _currentPage = 0;
    hasMore.value = true;
    items.clear();
    await _loadPage(isFirstPage: true);
  }

  /// Load halaman berikutnya (dipanggil saat scroll bawah)
  Future<void> loadNextPage() async {
    if (!hasMore.value || isLoadingMore.value || isLoadingFirstPage.value) {
      return;
    }
    await _loadPage(isFirstPage: false);
  }

  Future<void> _loadPage({required bool isFirstPage}) async {
    try {
      if (isFirstPage) {
        isLoadingFirstPage.value = true;
      } else {
        isLoadingMore.value = true;
      }
      error.value = null;

      // Ambil data dari callback
      final newItems = await fetchPage(_currentPage, pageSize);

      // Tambahkan ke list
      items.addAll(newItems);

      // Kalau jumlah item < pageSize → sudah habis
      if (newItems.length < pageSize) {
        hasMore.value = false;
      } else {
        _currentPage++;
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      if (isFirstPage) {
        isLoadingFirstPage.value = false;
      } else {
        isLoadingMore.value = false;
      }
    }
  }
}
