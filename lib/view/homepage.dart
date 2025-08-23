import 'package:bid4style/utils/extention.dart';
import 'package:bid4style/view/ProductDetail/productdetail.dart';
import 'package:bid4style/viewModal/DashboardViewModel/dashboardviewmodel.dart';
import 'package:bid4style/viewModal/ProfileViewmodal.darrt/userDetailViewMode.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/Appcolor.dart';
import '../../widgets/CustomTextstyle.dart';
import '../../widgets/TextFieldWidget.dart';
import '../../widgets/filterChip.dart';
import '../../widgets/flip_clock.dart';

class AuctionPage extends StatefulWidget {
  const AuctionPage({super.key});

  @override
  State<AuctionPage> createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {
  final ScrollController _outerController = ScrollController();
  final ScrollController _gridController = ScrollController();
  bool _gridAtTop = true;
  ValueNotifier<int> _currentCarouselIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final vm = context.read<AuctionPageViewModel>();
      vm.fetchBanners();
      vm.fetchCategories();
    });
    Future.microtask(() {
      Provider.of<UserDetailViewmodel>(context, listen: false).loadProfile();
    });
    _gridController.addListener(() {
      if (_gridController.offset <= 0) {
        _gridAtTop = true;
      } else {
        _gridAtTop = false;
      }
    });
  }

  void _scrollOuterToTop() {
    _outerController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userVM = context.read<UserDetailViewmodel>();
    return Consumer<AuctionPageViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(
            title: Consumer<UserDetailViewmodel>(
              builder: (context, userVM, child) {
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: userVM.getProfileImageProvider(),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: context.mediaQueryWidth * 0.3,
                      child: Text(
                        "Hi ${userVM.profiledata?.data?.userName ?? ''}",
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyle.heading20,
                      ),
                    ),
                  ],
                );
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
            ],
          ),
          body: NestedScrollView(
            controller: _outerController,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverToBoxAdapter(
                child: TexfieldWidget(
                  allMargin: 10,
                  allPadding: 0,
                  boxborder: Border.all(color: AppColors.grey200),
                  controller: TextEditingController(),
                  hintstyle: CustomTextStyle.text14.copyWith(
                    color: AppColors.grey,
                  ),
                  hint: "Search Anything...",
                  suffix: Icon(
                    Icons.filter_alt_outlined,
                    size: 18,
                    color: AppColors.themecolor,
                  ),
                  prefixWidget: Icon(
                    Icons.search,
                    size: 18,
                    color: AppColors.grey,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: vm.isLoadingBanners
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 150,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      )
                    : vm.banners.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text("No offers available"),
                        ),
                      )
                    : Column(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 150,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              viewportFraction: 0.9,
                              onPageChanged: (index, reason) {
                                _currentCarouselIndex.value = index;
                              },
                            ),
                            items: vm.banners.map((banner) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 2,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.grey100,
                                    width: 2,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: banner.imageUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            color: Colors.grey[300],
                                            width: double.infinity,
                                            height: 150,
                                          ),
                                        ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                          Icons.error,
                                          size: 30,
                                          color: Colors.grey,
                                        ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 6),
                          ValueListenableBuilder<int>(
                            valueListenable: _currentCarouselIndex,
                            builder: (context, value, child) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: vm.banners.asMap().entries.map((e) {
                                  return Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: value == e.key
                                          ? AppColors.themecolor
                                          : Colors.grey,
                                    ),
                                  );
                                }).toList(),
                              );
                            },
                          ),
                        ],
                      ),
              ),
              SliverToBoxAdapter(
                child: AuctionBanner(
                  endTime: DateTime.now().add(
                    const Duration(days: 1, hours: 5),
                  ),
                  imageUrl: "assets/images/timebanner.png",
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: vm.isLoadingCategories
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 44, // Approximate height of chips row
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )
                          : BidTabChips(
                              tabTitles: vm.categories
                                  .map((c) => c.name)
                                  .toList(),
                              selectedIndex: vm.categories.indexWhere(
                                (c) => c.id == vm.selectedCategoryId,
                              ),
                              indicatorColor: AppColors.themecolor,
                              unselectedLabelColor: Colors.grey,
                              onTabSelected: (index) {
                                final cat = vm.categories[index];
                                vm.fetchItemsForCategory(cat.id);
                              },
                            ),
                    ),
                  ),
                ),
              ),
            ],
            body: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification &&
                    notification.metrics.pixels <= 0 &&
                    notification.metrics.axis == Axis.vertical &&
                    _gridAtTop &&
                    notification.scrollDelta! < 0) {
                  _scrollOuterToTop();
                  return true;
                }
                return false;
              },
              child: CustomScrollView(
                controller: _gridController,
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate([
                      if (vm.isLoadingItems)
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            height:
                                200, // Approximate height for grid item placeholder
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        )
                      else if (vm.items.isEmpty)
                        const Center(
                          child: Text(
                            "No items found",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                    ]),
                  ),
                  if (!vm.isLoadingItems && vm.items.isNotEmpty)
                    SliverFillRemaining(
                      child: GridView.builder(
                        controller: _gridController,
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 220,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        itemCount: vm.items.length,
                        itemBuilder: (context, index) {
                          final item = vm.items[index];
                          return GestureDetector(
                            onTap: () {
                              print("ITEM SLUG----${item.slug}");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailPage(slug: item.slug),
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: item.imageUrl,
                                      height: 100,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: Container(
                                              color: Colors.grey[300],
                                              width: double.infinity,
                                              height: 120,
                                            ),
                                          ),
                                      errorWidget: (context, z, error) {
                                        print("IMAGE URL----${item.imageUrl}");
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.error,
                                              size: 20,
                                              color: Colors.grey,
                                            ),
                                            const Text("Failed to load"),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      "Current Bid ${item.price}",
                                      style: const TextStyle(
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text("Size - ${item.size}"),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      item.location,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverTabBarDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: child);
  }

  @override
  double get maxExtent => 60;
  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant _SliverTabBarDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}
