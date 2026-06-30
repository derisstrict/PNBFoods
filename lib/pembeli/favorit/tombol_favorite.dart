import 'package:flutter/material.dart';
import 'package:pnbfoods/services/favorit_service.dart';

class TombolFavorit extends StatefulWidget {
  final int produkId;

  const TombolFavorit({super.key, required this.produkId});

  @override
  State<TombolFavorit> createState() => _TombolFavoritState();
}

class _TombolFavoritState extends State<TombolFavorit> {
  bool _isFavorit = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cekStatus();
  }

  Future<void> _cekStatus() async {
    try {
      final result = await cekFavorit(widget.produkId);
      if (mounted) {
        setState(() {
          _isFavorit = result['is_favorit'] as bool;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _toggle() async {
    setState(() => _isLoading = true);
    try {
      final result = await toggleFavorit(widget.produkId);
      if (mounted) {
        setState(() {
          _isFavorit = result['is_favorit'] as bool;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFavorit
                  ? 'Ditambahkan ke favorit ❤️'
                  : 'Dihapus dari favorit',
            ),
            backgroundColor: _isFavorit ? Colors.red : Colors.grey[700],
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return IconButton(
          onPressed: null, 
          icon: const Icon(Icons.favorite, size: 28, color: Colors.black12,)
        );
    }

    return IconButton(
      icon: Icon(
        _isFavorit ? Icons.favorite : Icons.favorite_border,
        color: _isFavorit ? Colors.red : Colors.grey,
        size: 28,
      ),
      onPressed: _toggle,
      tooltip: _isFavorit ? 'Hapus dari favorit' : 'Tambah ke favorit',
    );
  }
}