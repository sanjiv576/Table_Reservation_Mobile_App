import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/api_endpoints.dart';
import '../../../../config/themes/constant.dart';
import '../../../../core/common/widget/custom_appbar_widget.dart';
import '../viewmodel/reviews_view_model.dart';

class OwnerReviewView extends ConsumerWidget {
  const OwnerReviewView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsState = ref.watch(reviewsViewModelProvider);
    return Scaffold(
      appBar: const CustomAppBarWidget(
        title: 'Reviews',
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 0,
          ),
          if (reviewsState.isLoading) ...{
            const Center(
              child: CircularProgressIndicator(),
            ),
          } else if (reviewsState.error != null) ...{
            Text(
              'Error: ${reviewsState.error!}',
              style: const TextStyle(color: Colors.red),
            ),
          } else if (reviewsState.allReviews.isEmpty) ...{
            Expanded(
              flex: 3,
              child: Center(
                child: Text('No Reviews Available',
                    style:
                        kTextStyle.copyWith(fontSize: 20, color: Colors.white)),
              ),
            )
          } else if (reviewsState.allReviews.isNotEmpty) ...{
            Expanded(
              child: ListView.separated(
                  itemBuilder: ((context, index) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      leading: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          // 'https://static.thenounproject.com/png/5034901-200.png',
                          ApiEndpoints.imageUrl +
                              reviewsState.allReviews[index].userPicture,
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reviewsState.allReviews[index].userName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            reviewsState.allReviews[index].text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  separatorBuilder: ((context, index) => const Divider(
                        color: Colors.transparent,
                      )),
                  itemCount: reviewsState.allReviews.length),
            )
          },
        ],
      ),
    );
  }
}
