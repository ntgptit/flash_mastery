// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Flash Mastery';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get folders => 'Folders';

  @override
  String get decks => 'Decks';

  @override
  String get flashcards => 'Flashcards';

  @override
  String get refresh => 'Refresh';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get create => 'Create';

  @override
  String get update => 'Update';

  @override
  String get search => 'Search';

  @override
  String get close => 'Close';

  @override
  String get edit => 'Edit';

  @override
  String get open => 'Open';

  @override
  String get save => 'Save';

  @override
  String get import => 'Import';

  @override
  String get continueAction => 'Continue';

  @override
  String get goBack => 'Go Back';

  @override
  String get viewAll => 'View all';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get heroTitle => 'Your flashcard HQ';

  @override
  String get heroSubtitle =>
      'Organize knowledge, launch study sessions, and keep momentum.';

  @override
  String get openFolders => 'Open folders';

  @override
  String get startStudying => 'Start studying';

  @override
  String get newFolder => 'New folder';

  @override
  String get totalFolders => 'Total folders';

  @override
  String get totalDecks => 'Total decks';

  @override
  String get createNow => 'Create now';

  @override
  String get stayOrganized => 'Stay organized';

  @override
  String get jumpToFolders => 'Jump to folders';

  @override
  String get topFolders => 'Top folders';

  @override
  String get recentActivity => 'Recent activity';

  @override
  String get folderCreatedSuccessfully => 'Folder created successfully';

  @override
  String get folderUpdatedSuccessfully => 'Folder updated successfully';

  @override
  String get folderDeleted => 'Folder deleted';

  @override
  String updatedAgo(String time) {
    return 'updated $time';
  }

  @override
  String nDecks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count decks',
      one: '1 deck',
      zero: '0 decks',
    );
    return '$_temp0';
  }

  @override
  String nSubfolders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subfolders',
      one: '1 subfolder',
      zero: '0 subfolders',
    );
    return '$_temp0';
  }

  @override
  String nCards(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cards',
      one: '1 card',
      zero: '0 cards',
    );
    return '$_temp0';
  }

  @override
  String nTerms(int count) {
    return '$count terms';
  }

  @override
  String get searchDecks => 'Search Decks';

  @override
  String get enterDeckName => 'Enter deck name...';

  @override
  String get organizeDecks => 'Organize and review your decks';

  @override
  String get createDeck => 'Create Deck';

  @override
  String get editDeck => 'Edit Deck';

  @override
  String get importDecks => 'Import decks';

  @override
  String intoFolder(String folderName) {
    return 'Into $folderName';
  }

  @override
  String get selectAFolder => 'Select a folder';

  @override
  String get createFolderBeforeDecks => 'Create a folder before adding decks';

  @override
  String get deleteDeck => 'Delete Deck';

  @override
  String deleteDeckConfirm(String name) {
    return 'Are you sure you want to delete \"$name\"?\nThis action cannot be undone.';
  }

  @override
  String get deckCreatedSuccessfully => 'Deck created successfully';

  @override
  String get deckUpdatedSuccessfully => 'Deck updated successfully';

  @override
  String get deckDeleted => 'Deck deleted';

  @override
  String get deleteFolder => 'Delete Folder';

  @override
  String deleteFolderConfirm(String name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String deleteSubfolderConfirm(String name) {
    return 'Delete subfolder \"$name\"?\nThis will remove it from this folder.';
  }

  @override
  String get subfolderCreatedSuccessfully => 'Subfolder created successfully';

  @override
  String get subfolderUpdated => 'Subfolder updated';

  @override
  String get selectFolder => 'Select folder';

  @override
  String get importOptions => 'Import options';

  @override
  String get vocabulary => 'Vocabulary';

  @override
  String get grammar => 'Grammar';

  @override
  String get fileHasHeaderRow => 'File has header row';

  @override
  String get importSummary => 'Import Summary';

  @override
  String get success => 'Success';

  @override
  String nDecksNCards(int deckCount, int cardCount) {
    return '$deckCount decks, $cardCount cards';
  }

  @override
  String decksCreated(int count) {
    return 'Decks created: $count';
  }

  @override
  String flashcardsImported(int count) {
    return 'Flashcards imported: $count';
  }

  @override
  String get skipped => 'Skipped';

  @override
  String decksSkippedDuplicate(int count) {
    return 'Decks skipped (duplicate): $count';
  }

  @override
  String flashcardsSkippedDuplicate(int count) {
    return 'Flashcards skipped (duplicate term): $count';
  }

  @override
  String get errors => 'Errors';

  @override
  String nInvalidRows(int count) {
    return '$count invalid rows';
  }

  @override
  String get noErrors => 'No errors';

  @override
  String invalidRows(int count) {
    return 'Invalid rows: $count';
  }

  @override
  String rowError(int row, String message) {
    return 'Row $row: $message';
  }

  @override
  String get noDecksYet => 'No decks yet';

  @override
  String get createDeckToStart => 'Create a deck to start adding flashcards';

  @override
  String get noDescription => 'No description';

  @override
  String get general => 'General';

  @override
  String get subfolders => 'Subfolders';

  @override
  String get newSubfolder => 'New subfolder';

  @override
  String get noSubfoldersYet =>
      'No subfolders yet. Create one to organize deeper.';

  @override
  String get back => 'Back';

  @override
  String get deckName => 'Deck Name';

  @override
  String get enterDeckNameHint => 'Enter deck name';

  @override
  String get pleaseEnterDeckName => 'Please enter a deck name';

  @override
  String nameTooShort(int min) {
    return 'Name must be at least $min characters';
  }

  @override
  String get descriptionOptional => 'Description (optional)';

  @override
  String get enterDeckDescription => 'Enter deck description';

  @override
  String descriptionTooLong(int max) {
    return 'Description must not exceed $max characters';
  }

  @override
  String get deckType => 'Deck type';

  @override
  String get folder => 'Folder';

  @override
  String get pleaseSelectFolder => 'Please select a folder';

  @override
  String cardsOfDeck(String deckName) {
    return 'Cards · $deckName';
  }

  @override
  String get noFlashcardsYet => 'No flashcards yet';

  @override
  String get createFlashcardsToStart => 'Create flashcards to start practicing';

  @override
  String get createFlashcard => 'Create Flashcard';

  @override
  String get editFlashcard => 'Edit Flashcard';

  @override
  String get searchFlashcards => 'Search Flashcards';

  @override
  String get enterKeyword => 'Enter keyword...';

  @override
  String sectionDeckName(String name) {
    return 'Section: $name';
  }

  @override
  String get sharedDeck => 'Shared deck';

  @override
  String get study => 'Study';

  @override
  String get test => 'Test';

  @override
  String get yourProgress => 'Your progress';

  @override
  String get notStarted => 'Not started';

  @override
  String get inProgress => 'In progress';

  @override
  String get mastered => 'Mastered';

  @override
  String get cards => 'Cards';

  @override
  String get originalOrder => 'Original order';

  @override
  String get sort => 'Sort';

  @override
  String get playAudio => 'Play audio';

  @override
  String get deleteFlashcard => 'Delete Flashcard';

  @override
  String get deleteFlashcardConfirm =>
      'Are you sure you want to delete this flashcard?';

  @override
  String get flashcardCreated => 'Flashcard created';

  @override
  String get flashcardUpdated => 'Flashcard updated';

  @override
  String get flashcardDeleted => 'Flashcard deleted';

  @override
  String get question => 'Question';

  @override
  String get enterQuestion => 'Enter question';

  @override
  String get answer => 'Answer';

  @override
  String get enterAnswer => 'Enter answer';

  @override
  String get hintOptional => 'Hint (optional)';

  @override
  String get enterHint => 'Enter hint';

  @override
  String get type => 'Type';

  @override
  String get switchToListView => 'Switch to list view';

  @override
  String get switchToGridView => 'Switch to grid view';

  @override
  String get noFoldersYet => 'No folders yet';

  @override
  String get createFirstFolder =>
      'Create your first folder to organize your decks';

  @override
  String get createFolder => 'Create Folder';

  @override
  String get editFolder => 'Edit Folder';

  @override
  String get createNewFolder => 'Create New Folder';

  @override
  String get searchFolders => 'Search Folders';

  @override
  String get enterFolderName => 'Enter folder name...';

  @override
  String get thisFolderContains => 'This folder contains:';

  @override
  String get actionCannotBeUndone => 'This action cannot be undone.';

  @override
  String get allContentsDeleted => 'All contents will be permanently deleted.';

  @override
  String get addSubfolder => 'Add subfolder';

  @override
  String get parentFolder => 'Parent folder';

  @override
  String get noParentRoot => 'No parent (root)';

  @override
  String get pathLabel => 'Path: ';

  @override
  String get folderName => 'Folder Name';

  @override
  String get enterFolderNameHint => 'Enter folder name';

  @override
  String get pleaseEnterFolderName => 'Please enter a folder name';

  @override
  String nameTooLong(int max) {
    return 'Name must not exceed $max characters';
  }

  @override
  String get enterFolderDescription => 'Enter folder description';

  @override
  String get chooseColor => 'Choose Color';

  @override
  String get unknownFolder => 'Unknown folder';

  @override
  String get startingStudySession => 'Starting Study Session';

  @override
  String get testMode => 'Test Mode';

  @override
  String studyMode(String mode) {
    return 'Study - $mode';
  }

  @override
  String get exitTest => 'Exit Test?';

  @override
  String get exitStudySession => 'Exit Study Session?';

  @override
  String get saveProgressQuestion => 'Do you want to save your progress?';

  @override
  String get progressSaved => 'Study progress saved';

  @override
  String get sessionCancelled => 'Study session cancelled';

  @override
  String get sessionCompleted => 'Study session completed!';

  @override
  String failedToLoadFlashcards(String error) {
    return 'Failed to load flashcards: $error';
  }

  @override
  String get noFlashcardsInBatch => 'No flashcards in this batch';

  @override
  String get meaning => 'Meaning';

  @override
  String get term => 'Term';

  @override
  String get show => 'Show';

  @override
  String get remembered => 'Remembered';

  @override
  String get forgot => 'Forgot';

  @override
  String get matchTermsWithMeanings => 'Match terms with their meanings';

  @override
  String matchesProgress(int current, int total) {
    return 'Matches: $current / $total';
  }

  @override
  String get terms => 'Terms';

  @override
  String get meanings => 'Meanings';

  @override
  String get incorrectMatch => 'Incorrect match. Try again.';

  @override
  String get typeTheTerm => 'Type the term';

  @override
  String get enterYourAnswer => 'Enter your answer';

  @override
  String get correctAnswer => 'Correct Answer';

  @override
  String get correct => 'Correct!';

  @override
  String progressCount(int current, int total) {
    return '$current / $total';
  }

  @override
  String toReview(int count) {
    return 'To Review: $count';
  }

  @override
  String timerSeconds(int seconds) {
    return '$seconds s';
  }

  @override
  String errorPrefix(String message) {
    return 'Error: $message';
  }

  @override
  String get emptyStateTitle => 'No Items Found';

  @override
  String get emptyStateMessage =>
      'There are no items to display at the moment.';

  @override
  String get noResultsFound => 'No Results Found';

  @override
  String noResultsForQuery(String query) {
    return 'No results found for \"$query\"';
  }

  @override
  String get tryAdjustingSearch => 'Try adjusting your search criteria.';

  @override
  String get clearSearch => 'Clear Search';

  @override
  String get noFavoritesYet => 'No Favorites Yet';

  @override
  String get addFavoritesMessage =>
      'Start adding items to your favorites to see them here.';

  @override
  String get browseItems => 'Browse Items';

  @override
  String get noNotifications => 'No Notifications';

  @override
  String get allCaughtUp => 'You\'re all caught up! No new notifications.';

  @override
  String get noConnection => 'No Connection';

  @override
  String get unableToLoadData =>
      'Unable to load data. Please check your internet connection.';

  @override
  String get retry => 'Retry';

  @override
  String get connectionError => 'Connection Error';

  @override
  String get checkInternetConnection =>
      'Please check your internet connection and try again.';

  @override
  String get serverError => 'Server Error';

  @override
  String get serverErrorMessage =>
      'Something went wrong on our end. Please try again later.';

  @override
  String get notFound => 'Not Found';

  @override
  String get notFoundMessage =>
      'The resource you are looking for could not be found.';

  @override
  String get accessDenied => 'Access Denied';

  @override
  String get accessDeniedMessage =>
      'You do not have permission to access this resource.';

  @override
  String get tryAgain => 'Try Again';
}
