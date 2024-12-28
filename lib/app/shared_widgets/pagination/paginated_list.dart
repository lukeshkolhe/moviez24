import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:moviez24/app/base/base_view.dart';
import 'package:moviez24/app/shared_widgets/loading/custom_loading_indicator.dart';
import 'package:moviez24/app/shared_widgets/pagination/paginated_list_controller.dart';

class PaginatedList<T> extends BaseView<PaginatedListController<T>> {
  const PaginatedList({
    super.key,
    required this.builder,
    required this.emptyViewBuilder,
    required this.controller,
  });

  @override
  final PaginatedListController<T> controller;

  /// Build individual widget of the list
  final Widget Function(T data, int index) builder;

  /// Build empty view i.e when no item is present in the list
  final Widget Function() emptyViewBuilder;

  @override
  Widget build(BuildContext context) => Obx(() {
        final List<T> list = controller.list.value;

        if (controller.isLoading.value) {
          return Container();
        }

        if (list.isEmpty) {
          /// Empty View
          return emptyViewBuilder();
        }

        bool isLoadingMore = controller.isLoadingMore.value;

        /// List View
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 24),
          physics: const BouncingScrollPhysics(),
          controller: controller.scrollController,
          itemCount: list.length + (isLoadingMore ? 1 : 0),
          itemBuilder: (ctx, index) => isLoadingMore && index == list.length
              ? const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: CustomLoadingIndicator(),
                )
              : builder(list[index], index),
        );
      });
}

class PaginatedGrid<T> extends PaginatedList<T> {
  const PaginatedGrid(
      {required super.builder,
      required super.emptyViewBuilder,
      required super.controller});

  @override
  Widget build(BuildContext context) => Obx(
        () {
          final List<T> list = controller.list.value;

          if (controller.isLoading.value) {
            return Container();
          }

          if (list.isEmpty) {
            /// Empty View
            return emptyViewBuilder();
          }

          bool isLoadingMore = controller.isLoadingMore.value;

          /// List View
          return GridView.builder(
            padding: const EdgeInsets.only(bottom: 24),
            physics: const BouncingScrollPhysics(),
            controller: controller.scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.5,
            ),
            itemCount: list.length + (isLoadingMore ? 1 : 0),
            itemBuilder: (ctx, index) {
              if (isLoadingMore && index == list.length) {
                return const Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: CustomLoadingIndicator(),
                );
              } else {
                return builder(list[index], index);
              }
            },
          );
        },
      );
}
