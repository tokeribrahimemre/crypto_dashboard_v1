import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/crypto_entity.dart';

class CryptoListTile extends StatelessWidget {
  final CryptoEntity crypto;
  final VoidCallback onFavoriteTapped;
  final VoidCallback onTap; 

  const CryptoListTile({
    super.key,
    required this.crypto,
    required this.onFavoriteTapped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = crypto.change >= 0;
    final changeColor = isPositive ? Colors.greenAccent : Colors.redAccent;
    final changeIcon = isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      color: Colors.white.withOpacity(0.05), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              SizedBox(
                width: 44,
                height: 44,
                child: crypto.iconUrl.toLowerCase().endsWith('.svg')
                    ? SvgPicture.network(
                        crypto.iconUrl,
                        placeholderBuilder: (context) => const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : Image.network(
                        crypto.iconUrl,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                      ),
              ),
              const SizedBox(width: 16),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      crypto.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      crypto.symbol,
                      style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    ),
                  ],
                ),
              ),
              
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${crypto.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Row(
                    children: [
                      Icon(changeIcon, color: changeColor, size: 20),
                      Text(
                        '${crypto.change.abs().toStringAsFixed(2)}%',
                        style: TextStyle(color: changeColor, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 8),
              
              IconButton(
                icon: Icon(
                  crypto.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: crypto.isFavorite ? Colors.redAccent : Colors.grey.shade600,
                ),
                onPressed: onFavoriteTapped,
              ),
            ],
          ),
        ),
      ),
    );
  }
}