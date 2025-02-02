import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:uas_mobile2/Backend/Provider/search_provider.dart';
import 'package:uas_mobile2/Warna_Tema/warna_tema.dart';

class SearchResultPage extends StatefulWidget {
  final String query;

  const SearchResultPage({super.key, required this.query});

  @override
  SearchResultPageState createState() => SearchResultPageState();
}

class SearchResultPageState extends State<SearchResultPage> {
  @override
  void initState() {
    super.initState();
    final searchProvider = Provider.of<SearchProvider>(context, listen: false);
    searchProvider.searchCoffees(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const Gap(40),
          buildHeader(),
          const Gap(8),
          buildGridCoffee(context),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const ImageIcon(
            AssetImage('assets/image/ic_arrow_left.png'),
          ),
        ),
        const Expanded(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Pencarian',
              style: TextStyle(
                fontFamily: "poppinsregular",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: warnaKopi,
              ),
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget buildGridCoffee(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, child) {
        if (searchProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (searchProvider.searchResult.isEmpty) {
          return const Center(child: Text('Tidak ada kopi ditemukan'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hasil Pencarian: ${widget.query}',
              style: const TextStyle(
                fontFamily: "poppinsregular",
                fontSize: 16,
                color: warnaKopi2,
              ),
            ),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: searchProvider.searchResult.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 238,
                crossAxisSpacing: 15,
                mainAxisSpacing: 24,
              ),
              itemBuilder: (context, index) {
                final coffee = searchProvider.searchResult[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/detail', arguments: coffee);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: coffee.image,
                            height: 128,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          coffee.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: "poppinsregular",
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: warnaKopi2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          coffee.category,
                          style: const TextStyle(
                            fontFamily: "poppinsregular",
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                            height:
                                8), 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              NumberFormat.currency(
                                decimalDigits: 0,
                                locale: 'id_ID',
                                symbol: 'Rp',
                              ).format(coffee.price),
                              style: const TextStyle(
                                fontFamily: "poppinsregular",
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: warnaKopi2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
