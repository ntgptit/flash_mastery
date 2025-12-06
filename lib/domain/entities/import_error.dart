class ImportError {
  final int rowIndex;
  final String message;
  final String? deckName;
  final String? term;

  const ImportError({
    required this.rowIndex,
    required this.message,
    this.deckName,
    this.term,
  });
}
