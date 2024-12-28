import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:moviez24/app/base/base_controller.dart';
import 'package:moviez24/app/shared_widgets/messages/error_message.dart';
import 'package:moviez24/app/shared_widgets/pagination/models/pagination_details.dart';
import '../../../../../utils/network/result.dart';

typedef DataRequester<T> = Future<Result<List<T>, PaginationDetails>> Function(
    PaginationDetails);

class PaginatedListController<T> extends BaseController {
  final Rx<List<T>> list = Rx([]);
  RxBool isLoadingMore = false.obs;
  final int perPage;

  late PaginationDetails paginationDetails = defaultPaginationDetails;

  PaginationDetails get defaultPaginationDetails => PaginationDetails(
        totalPages: 1,
        total: 20,
        lastPage: 1,
        currentPage: 0,
        perPage: perPage,
      );

  bool get hasMore =>
      paginationDetails.currentPage < paginationDetails.totalPages;

  DataRequester<T> onDataRequested;

  PaginatedListController({required this.onDataRequested, this.perPage = 20}) {
    scrollController.addListener(_checkIfLoadMoreNeeded);
    requestData();
  }

  reload() {
    _clearData();
    requestData();
  }

  void _clearData() {
    paginationDetails = defaultPaginationDetails;
    list.value.clear();
  }

  requestData() async {
    if (list.value.isEmpty) {
      startLoading();
    } else {
      showLoadingMore();
    }
    paginationDetails.currentPage++;
    Result<List<T>, PaginationDetails> result =
        await onDataRequested(paginationDetails);
    stopLoading();
    hideLoadingMore();
    result.handle(
      onSuccess: (data) {
        List<T> generatedList = List.from(list.value);
        generatedList.addAll(data);
        list.value = generatedList;
        paginationDetails = result.metaData!;
      },
      onFailure: (err) {
        ErrorMessage(message: err.errorMsg).show();
      },
    );
  }

  showLoadingMore() {
    isLoadingMore.value = true;
  }

  hideLoadingMore() {
    isLoadingMore.value = false;
  }

  final ScrollController scrollController = ScrollController();

  void _checkIfLoadMoreNeeded() {
    if (scrollController.position.maxScrollExtent <= scrollController.offset) {
      if (hasMore && !isLoadingMore.value) {
        isLoadingMore.value = true;
        requestData();
      }
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
