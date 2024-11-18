import 'package:agriplant/models/cubit/user/user_cubit.dart';
import 'package:agriplant/models/tree.dart';
import 'package:agriplant/utils/contants.dart';
import 'package:agriplant/widgets/custom_icon.dart';
import 'package:agriplant/widgets/drawer.dart';
import 'package:agriplant/widgets/tree_card.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

import 'package:badges/badges.dart' as badges;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().fetchUser(null);
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton.filledTonal(
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
        title: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is UserError) {
              return Text(state.message);
            }
            if (state is UserLoaded) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BounceInDown(
                    child: Text(
                      "Hi ${state.user?.name}",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text("Xin chào", style: Theme.of(context).textTheme.bodySmall)
                ],
              );
            }
            return const SizedBox();
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton.filledTonal(
              onPressed: () {
                context.push("/notifications");
              },
              icon: badges.Badge(
                badgeContent: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                position: badges.BadgePosition.topEnd(top: -15, end: -12),
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: primaryColor,
                ),
                child: const CustomIcon(FontAwesomeIcons.bell),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                Expanded(
                  child: BounceInLeft(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search here...",
                        isDense: true,
                        contentPadding: const EdgeInsets.all(12.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(
                            Radius.circular(99),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(99),
                          ),
                        ),
                        prefixIcon: const Icon(IconlyLight.search),
                      ),
                    ),
                  ),
                ),
                BounceInRight(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: IconButton.filled(
                        onPressed: () {}, icon: const Icon(IconlyLight.filter)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: SizedBox(
              height: 170,
              child: FadeInRight(
                child: Card(
                  color: Colors.green.shade50,
                  elevation: 0.1,
                  shadowColor: Colors.green.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Hỗ trợ miễn phí",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                      color: Colors.green.shade700,
                                    ),
                              ),
                              const Text("Liên hệ với chúng tôi"),
                              FilledButton(
                                onPressed: () {},
                                child: const Text("GỌI NGAY"),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          'assets/contact_us.png',
                          width: 140,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Danh sách Cây xoài",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {},
                child: const Text("Xem tất cả"),
              ),
            ],
          ),
          GridView.builder(
            itemCount: trees.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.9,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              return TreeCard(tree: trees[index]);
            },
          )
        ],
      ),
    );
  }
}
