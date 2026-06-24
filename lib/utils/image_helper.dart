String normalizeImageUrl(String rawUrl) {
  final url = rawUrl.trim();

  if (url.isEmpty) return '';

  if (url.startsWith('http')) {
    return url;
  }

  return 'https://prakrutitech.xyz/${url.replaceAll(RegExp(r'^/+'), '')}';
}
