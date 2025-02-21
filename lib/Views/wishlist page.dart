import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_emergio/Widgets/custom_profile_appbar_widget.dart';
import 'package:project_emergio/generated/constants.dart';
import 'package:project_emergio/services/wishlist.dart';
import '../Widgets/wishlist shimmer.dart';
import '../controller/wishlist controller.dart';
import 'detail page/business deatil page.dart';
import 'detail page/franchise detail page.dart';
import 'detail page/invester detail page.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final WishlistController wishlistController = Get.put(WishlistController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBarWidget(
        title: "Wishlist",
        isBackIcon: false,
      ),
      body: SafeArea(
        child: Obx(() => wishlistController.isLoading.value
            ? WishlistShimmer.buildShimmerLoading()
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _buildHeader(),
                const SizedBox(height: 20),
                _buildCollectionTitle(),
                const SizedBox(height: 20),
                if (wishlistController.businessItems.isNotEmpty) ...[
                  _buildBusinessSection(),
                  const SizedBox(height: 20),
                ],
                if (wishlistController.franchiseItems.isNotEmpty) ...[
                  _buildFranchiseSection(),
                  const SizedBox(height: 20),
                ],
                if (wishlistController.investorItems.isNotEmpty)
                  _buildInvestorSection(),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Widget _buildCollectionTitle() {
    return Obx(() {
      final totalItems = wishlistController.businessItems.length +
          wishlistController.franchiseItems.length +
          wishlistController.investorItems.length;
      return Row(
        children: [
          Text('My Collections',
              style:
              AppTheme.titleText(lightTextColor).copyWith(fontSize: 18.sp)),
          const SizedBox(width: 8),
          Text('( $totalItems )',
              style:
              AppTheme.titleText(lightTextColor).copyWith(fontSize: 18.sp)),
        ],
      );
    });
  }

  Widget _buildBusinessSection() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xff6B89B7),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.business, color: Color(0xff6B89B7)),
                  ),
                  const SizedBox(width: 8),
                  Text('Business',
                      style: AppTheme.titleText(Colors.white)
                          .copyWith(fontSize: 18.sp)),
                ],
              ),
              const Spacer(),
              Text('(${wishlistController.businessItems.length})',
                  style: AppTheme.titleText(Colors.white)
                      .copyWith(fontSize: 18.sp)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildItemGrid(wishlistController.businessItems.value, 'business'),
      ],
    ));
  }

  Widget _buildFranchiseSection() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xffF3D55E),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.store, color: buttonColor),
                  ),
                  SizedBox(width: 8),
                  Text('Franchise',
                      style: AppTheme.titleText(Colors.white)
                          .copyWith(fontSize: 18.sp)),
                ],
              ),
              const Spacer(),
              Text('( ${wishlistController.franchiseItems.length} )',
                  style: AppTheme.titleText(Colors.white)
                      .copyWith(fontSize: 18.sp)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildItemGrid(
            wishlistController.franchiseItems.value, 'franchise'),
      ],
    ));
  }

  Widget _buildInvestorSection() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xffBDD0E7),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.store, color: Color(0xffBDD0E7)),
                  ),
                  SizedBox(width: 8),
                  Text('Investor',
                      style: AppTheme.titleText(Colors.white)
                          .copyWith(fontSize: 18.sp)),
                ],
              ),
              const Spacer(),
              Text(
                '( ${wishlistController.investorItems.length} )',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildItemGrid(wishlistController.investorItems.value, 'investor'),
      ],
    ));
  }

  Widget _buildItemGrid(List<ProductDetails> items, String type) {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () async {
              if (type == 'business') {
                final businessItem = wishlistController.wishlistAllItems
                    .firstWhereOrNull((element) => element.id == item.id);

                if (businessItem != null) {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BusinessDetailPage(
                        buisines: businessItem,
                        imageUrl: businessItem.imageUrl,
                        image2: businessItem.image2 ?? '',
                        image3: businessItem.image3 ?? '',
                        image4: businessItem.image4 ?? '',
                        name: businessItem.title,
                        industry: businessItem.industry ?? '',
                        establish_yr: businessItem.establish_yr ?? '',
                        description: businessItem.description ?? '',
                        address_1: businessItem.address_1 ?? '',
                        address_2: businessItem.address_2 ?? '',
                        pin: businessItem.pin ?? '',
                        city: businessItem.city,
                        state: businessItem.state ?? '',
                        employees: businessItem.employees ?? '',
                        entity: businessItem.entity ?? '',
                        avg_monthly: businessItem.avg_monthly ?? '',
                        latest_yearly: businessItem.latest_yearly ?? '',
                        ebitda: businessItem.ebitda ?? '',
                        rate: businessItem.rate ?? '',
                        type_sale: businessItem.type_sale ?? '',
                        url: businessItem.url ?? '',
                        features: businessItem.features ?? '',
                        facility: businessItem.facility ?? '',
                        income_source: businessItem.income_source ?? '',
                        reason: businessItem.reason ?? '',
                        postedTime: businessItem.postedTime,
                        topSelling: businessItem.topSelling ?? '',
                        id: businessItem.id,
                        showEditOption: false,
                        // onRemoveFromWishlist: () async {
                        // await wishlistController.removeFromWishlist(businessItem.id);
                        // },
                      ),
                    ),
                  );

                  if (result == true) {
                    await wishlistController.fetchWishlistItems();
                  }
                }
              } else if (type == 'franchise') {
                final franchiseItem = wishlistController.wishlistFranchiseItems
                    .firstWhereOrNull((element) => element.id == item.id);

                if (franchiseItem != null) {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FranchiseDetailPage(
                        franchise: franchiseItem,
                        id: franchiseItem.id,
                        imageUrl: franchiseItem.imageUrl,
                        image2: franchiseItem.image2 ?? '',
                        image3: franchiseItem.image3 ?? '',
                        image4: franchiseItem.image4 ?? '',
                        brandName: franchiseItem.title ?? '',
                        city: franchiseItem.city,
                        postedTime: franchiseItem.postedTime,
                        state: franchiseItem.state ?? '',
                        industry: franchiseItem.industry ?? '',
                        description: franchiseItem.description ?? '',
                        url: franchiseItem.url ?? '',
                        initialInvestment: franchiseItem.initialInvestment ?? '',
                        projectedRoi: franchiseItem.projectedRoi ?? '',
                        iamOffering: franchiseItem.iamOffering ?? '',
                        currentNumberOfOutlets:
                        franchiseItem.currentNumberOfOutlets ?? '',
                        franchiseTerms: franchiseItem.franchiseTerms ?? '',
                        locationsAvailable:
                        franchiseItem.locationsAvailable ?? '',
                        kindOfSupport: franchiseItem.kindOfSupport ?? '',
                        allProducts: franchiseItem.allProducts ?? '',
                        brandStartOperation:
                        franchiseItem.brandStartOperation ?? '',
                        spaceRequiredMin: franchiseItem.spaceRequiredMin ?? '',
                        spaceRequiredMax: franchiseItem.spaceRequiredMax ?? '',
                        totalInvestmentFrom:
                        franchiseItem.totalInvestmentFrom ?? '',
                        totalInvestmentTo: franchiseItem.totalInvestmentTo ?? '',
                        brandFee: franchiseItem.brandFee ?? '',
                        avgNoOfStaff: franchiseItem.avgNoOfStaff ?? '',
                        avgMonthlySales: franchiseItem.avgMonthlySales ?? '',
                        avgEBITDA: franchiseItem.avgEBITDA ?? '',
                        showEditOption: false,
                        // onRemoveFromWishlist: () async {
                        // await wishlistController.removeFromWishlist(franchiseItem.id);
                        // },
                      ),
                    ),
                  );

                  if (result == true) {
                    await wishlistController.fetchWishlistItems();
                  }
                }
              } else if (type == 'investor') {
                final investorItem = wishlistController.wishlistAllItems
                    .firstWhereOrNull((element) => element.id == item.id);

                if (investorItem != null) {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InvestorDetailPage(
                        investor: investorItem,
                        imageUrl: investorItem.imageUrl,
                        name: investorItem.title,
                        city: investorItem.city,
                        postedTime: investorItem.postedTime,
                        state: investorItem.state ?? '',
                        industry: investorItem.industry ?? '',
                        description: investorItem.description ?? '',
                        url: investorItem.url ?? '',
                        rangeStarting: investorItem.rangeStarting ?? '',
                        rangeEnding: investorItem.rangeEnding ?? '',
                        evaluatingAspects: investorItem.evaluatingAspects ?? '',
                        CompanyName: investorItem.companyName ?? '',
                        locationInterested: investorItem.locationIntrested ?? '',
                        id: investorItem.id,
                        showEditOption: false,
                        image2: investorItem.image2 ?? '',
                        image3: investorItem.image3 ?? '',
                        image4: investorItem.image4 ?? '',
                        // onRemoveFromWishlist: () async {
                        // await wishlistController.removeFromWishlist(investorItem.id);
                        // },
                      ),
                    ),
                  );

                  if (result == true) {
                    await wishlistController.fetchWishlistItems();
                  }
                }
              }
            },
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(item.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Text(
                              item.title!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    item.city,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
          },
        );
    }
}
