import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Flash Mastery'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @folders.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get folders;

  /// No description provided for @decks.
  ///
  /// In en, this message translates to:
  /// **'Decks'**
  String get decks;

  /// No description provided for @flashcards.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get flashcards;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @heroTitle.
  ///
  /// In en, this message translates to:
  /// **'Your flashcard HQ'**
  String get heroTitle;

  /// No description provided for @heroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Organize knowledge, launch study sessions, and keep momentum.'**
  String get heroSubtitle;

  /// No description provided for @openFolders.
  ///
  /// In en, this message translates to:
  /// **'Open folders'**
  String get openFolders;

  /// No description provided for @startStudying.
  ///
  /// In en, this message translates to:
  /// **'Start studying'**
  String get startStudying;

  /// No description provided for @newFolder.
  ///
  /// In en, this message translates to:
  /// **'New folder'**
  String get newFolder;

  /// No description provided for @totalFolders.
  ///
  /// In en, this message translates to:
  /// **'Total folders'**
  String get totalFolders;

  /// No description provided for @totalDecks.
  ///
  /// In en, this message translates to:
  /// **'Total decks'**
  String get totalDecks;

  /// No description provided for @createNow.
  ///
  /// In en, this message translates to:
  /// **'Create now'**
  String get createNow;

  /// No description provided for @stayOrganized.
  ///
  /// In en, this message translates to:
  /// **'Stay organized'**
  String get stayOrganized;

  /// No description provided for @jumpToFolders.
  ///
  /// In en, this message translates to:
  /// **'Jump to folders'**
  String get jumpToFolders;

  /// No description provided for @topFolders.
  ///
  /// In en, this message translates to:
  /// **'Top folders'**
  String get topFolders;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get recentActivity;

  /// No description provided for @folderCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Folder created successfully'**
  String get folderCreatedSuccessfully;

  /// No description provided for @folderUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Folder updated successfully'**
  String get folderUpdatedSuccessfully;

  /// No description provided for @folderDeleted.
  ///
  /// In en, this message translates to:
  /// **'Folder deleted'**
  String get folderDeleted;

  /// No description provided for @updatedAgo.
  ///
  /// In en, this message translates to:
  /// **'updated {time}'**
  String updatedAgo(String time);

  /// No description provided for @nDecks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 decks} =1{1 deck} other{{count} decks}}'**
  String nDecks(int count);

  /// No description provided for @nSubfolders.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 subfolders} =1{1 subfolder} other{{count} subfolders}}'**
  String nSubfolders(int count);

  /// No description provided for @nCards.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 cards} =1{1 card} other{{count} cards}}'**
  String nCards(int count);

  /// No description provided for @nTerms.
  ///
  /// In en, this message translates to:
  /// **'{count} terms'**
  String nTerms(int count);

  /// No description provided for @searchDecks.
  ///
  /// In en, this message translates to:
  /// **'Search Decks'**
  String get searchDecks;

  /// No description provided for @enterDeckName.
  ///
  /// In en, this message translates to:
  /// **'Enter deck name...'**
  String get enterDeckName;

  /// No description provided for @organizeDecks.
  ///
  /// In en, this message translates to:
  /// **'Organize and review your decks'**
  String get organizeDecks;

  /// No description provided for @createDeck.
  ///
  /// In en, this message translates to:
  /// **'Create Deck'**
  String get createDeck;

  /// No description provided for @editDeck.
  ///
  /// In en, this message translates to:
  /// **'Edit Deck'**
  String get editDeck;

  /// No description provided for @importDecks.
  ///
  /// In en, this message translates to:
  /// **'Import decks'**
  String get importDecks;

  /// No description provided for @intoFolder.
  ///
  /// In en, this message translates to:
  /// **'Into {folderName}'**
  String intoFolder(String folderName);

  /// No description provided for @selectAFolder.
  ///
  /// In en, this message translates to:
  /// **'Select a folder'**
  String get selectAFolder;

  /// No description provided for @createFolderBeforeDecks.
  ///
  /// In en, this message translates to:
  /// **'Create a folder before adding decks'**
  String get createFolderBeforeDecks;

  /// No description provided for @deleteDeck.
  ///
  /// In en, this message translates to:
  /// **'Delete Deck'**
  String get deleteDeck;

  /// No description provided for @deleteDeckConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?\nThis action cannot be undone.'**
  String deleteDeckConfirm(String name);

  /// No description provided for @deckCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Deck created successfully'**
  String get deckCreatedSuccessfully;

  /// No description provided for @deckUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Deck updated successfully'**
  String get deckUpdatedSuccessfully;

  /// No description provided for @deckDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deck deleted'**
  String get deckDeleted;

  /// No description provided for @deleteFolder.
  ///
  /// In en, this message translates to:
  /// **'Delete Folder'**
  String get deleteFolder;

  /// No description provided for @deleteFolderConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String deleteFolderConfirm(String name);

  /// No description provided for @deleteSubfolderConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete subfolder \"{name}\"?\nThis will remove it from this folder.'**
  String deleteSubfolderConfirm(String name);

  /// No description provided for @subfolderCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Subfolder created successfully'**
  String get subfolderCreatedSuccessfully;

  /// No description provided for @subfolderUpdated.
  ///
  /// In en, this message translates to:
  /// **'Subfolder updated'**
  String get subfolderUpdated;

  /// No description provided for @selectFolder.
  ///
  /// In en, this message translates to:
  /// **'Select folder'**
  String get selectFolder;

  /// No description provided for @importOptions.
  ///
  /// In en, this message translates to:
  /// **'Import options'**
  String get importOptions;

  /// No description provided for @vocabulary.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary'**
  String get vocabulary;

  /// No description provided for @grammar.
  ///
  /// In en, this message translates to:
  /// **'Grammar'**
  String get grammar;

  /// No description provided for @fileHasHeaderRow.
  ///
  /// In en, this message translates to:
  /// **'File has header row'**
  String get fileHasHeaderRow;

  /// No description provided for @importSummary.
  ///
  /// In en, this message translates to:
  /// **'Import Summary'**
  String get importSummary;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @nDecksNCards.
  ///
  /// In en, this message translates to:
  /// **'{deckCount} decks, {cardCount} cards'**
  String nDecksNCards(int deckCount, int cardCount);

  /// No description provided for @decksCreated.
  ///
  /// In en, this message translates to:
  /// **'Decks created: {count}'**
  String decksCreated(int count);

  /// No description provided for @flashcardsImported.
  ///
  /// In en, this message translates to:
  /// **'Flashcards imported: {count}'**
  String flashcardsImported(int count);

  /// No description provided for @skipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get skipped;

  /// No description provided for @decksSkippedDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Decks skipped (duplicate): {count}'**
  String decksSkippedDuplicate(int count);

  /// No description provided for @flashcardsSkippedDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Flashcards skipped (duplicate term): {count}'**
  String flashcardsSkippedDuplicate(int count);

  /// No description provided for @errors.
  ///
  /// In en, this message translates to:
  /// **'Errors'**
  String get errors;

  /// No description provided for @nInvalidRows.
  ///
  /// In en, this message translates to:
  /// **'{count} invalid rows'**
  String nInvalidRows(int count);

  /// No description provided for @noErrors.
  ///
  /// In en, this message translates to:
  /// **'No errors'**
  String get noErrors;

  /// No description provided for @invalidRows.
  ///
  /// In en, this message translates to:
  /// **'Invalid rows: {count}'**
  String invalidRows(int count);

  /// No description provided for @rowError.
  ///
  /// In en, this message translates to:
  /// **'Row {row}: {message}'**
  String rowError(int row, String message);

  /// No description provided for @noDecksYet.
  ///
  /// In en, this message translates to:
  /// **'No decks yet'**
  String get noDecksYet;

  /// No description provided for @createDeckToStart.
  ///
  /// In en, this message translates to:
  /// **'Create a deck to start adding flashcards'**
  String get createDeckToStart;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get noDescription;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @subfolders.
  ///
  /// In en, this message translates to:
  /// **'Subfolders'**
  String get subfolders;

  /// No description provided for @newSubfolder.
  ///
  /// In en, this message translates to:
  /// **'New subfolder'**
  String get newSubfolder;

  /// No description provided for @noSubfoldersYet.
  ///
  /// In en, this message translates to:
  /// **'No subfolders yet. Create one to organize deeper.'**
  String get noSubfoldersYet;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @deckName.
  ///
  /// In en, this message translates to:
  /// **'Deck Name'**
  String get deckName;

  /// No description provided for @enterDeckNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter deck name'**
  String get enterDeckNameHint;

  /// No description provided for @pleaseEnterDeckName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a deck name'**
  String get pleaseEnterDeckName;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least {min} characters'**
  String nameTooShort(int min);

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// No description provided for @enterDeckDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter deck description'**
  String get enterDeckDescription;

  /// No description provided for @descriptionTooLong.
  ///
  /// In en, this message translates to:
  /// **'Description must not exceed {max} characters'**
  String descriptionTooLong(int max);

  /// No description provided for @deckType.
  ///
  /// In en, this message translates to:
  /// **'Deck type'**
  String get deckType;

  /// No description provided for @folder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get folder;

  /// No description provided for @pleaseSelectFolder.
  ///
  /// In en, this message translates to:
  /// **'Please select a folder'**
  String get pleaseSelectFolder;

  /// No description provided for @cardsOfDeck.
  ///
  /// In en, this message translates to:
  /// **'Cards · {deckName}'**
  String cardsOfDeck(String deckName);

  /// No description provided for @noFlashcardsYet.
  ///
  /// In en, this message translates to:
  /// **'No flashcards yet'**
  String get noFlashcardsYet;

  /// No description provided for @createFlashcardsToStart.
  ///
  /// In en, this message translates to:
  /// **'Create flashcards to start practicing'**
  String get createFlashcardsToStart;

  /// No description provided for @createFlashcard.
  ///
  /// In en, this message translates to:
  /// **'Create Flashcard'**
  String get createFlashcard;

  /// No description provided for @editFlashcard.
  ///
  /// In en, this message translates to:
  /// **'Edit Flashcard'**
  String get editFlashcard;

  /// No description provided for @searchFlashcards.
  ///
  /// In en, this message translates to:
  /// **'Search Flashcards'**
  String get searchFlashcards;

  /// No description provided for @enterKeyword.
  ///
  /// In en, this message translates to:
  /// **'Enter keyword...'**
  String get enterKeyword;

  /// No description provided for @sectionDeckName.
  ///
  /// In en, this message translates to:
  /// **'Section: {name}'**
  String sectionDeckName(String name);

  /// No description provided for @sharedDeck.
  ///
  /// In en, this message translates to:
  /// **'Shared deck'**
  String get sharedDeck;

  /// No description provided for @study.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get study;

  /// No description provided for @test.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get test;

  /// No description provided for @yourProgress.
  ///
  /// In en, this message translates to:
  /// **'Your progress'**
  String get yourProgress;

  /// No description provided for @notStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get notStarted;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgress;

  /// No description provided for @mastered.
  ///
  /// In en, this message translates to:
  /// **'Mastered'**
  String get mastered;

  /// No description provided for @cards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get cards;

  /// No description provided for @originalOrder.
  ///
  /// In en, this message translates to:
  /// **'Original order'**
  String get originalOrder;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @playAudio.
  ///
  /// In en, this message translates to:
  /// **'Play audio'**
  String get playAudio;

  /// No description provided for @deleteFlashcard.
  ///
  /// In en, this message translates to:
  /// **'Delete Flashcard'**
  String get deleteFlashcard;

  /// No description provided for @deleteFlashcardConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this flashcard?'**
  String get deleteFlashcardConfirm;

  /// No description provided for @flashcardCreated.
  ///
  /// In en, this message translates to:
  /// **'Flashcard created'**
  String get flashcardCreated;

  /// No description provided for @flashcardUpdated.
  ///
  /// In en, this message translates to:
  /// **'Flashcard updated'**
  String get flashcardUpdated;

  /// No description provided for @flashcardDeleted.
  ///
  /// In en, this message translates to:
  /// **'Flashcard deleted'**
  String get flashcardDeleted;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @enterQuestion.
  ///
  /// In en, this message translates to:
  /// **'Enter question'**
  String get enterQuestion;

  /// No description provided for @answer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get answer;

  /// No description provided for @enterAnswer.
  ///
  /// In en, this message translates to:
  /// **'Enter answer'**
  String get enterAnswer;

  /// No description provided for @hintOptional.
  ///
  /// In en, this message translates to:
  /// **'Hint (optional)'**
  String get hintOptional;

  /// No description provided for @enterHint.
  ///
  /// In en, this message translates to:
  /// **'Enter hint'**
  String get enterHint;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @switchToListView.
  ///
  /// In en, this message translates to:
  /// **'Switch to list view'**
  String get switchToListView;

  /// No description provided for @switchToGridView.
  ///
  /// In en, this message translates to:
  /// **'Switch to grid view'**
  String get switchToGridView;

  /// No description provided for @noFoldersYet.
  ///
  /// In en, this message translates to:
  /// **'No folders yet'**
  String get noFoldersYet;

  /// No description provided for @createFirstFolder.
  ///
  /// In en, this message translates to:
  /// **'Create your first folder to organize your decks'**
  String get createFirstFolder;

  /// No description provided for @createFolder.
  ///
  /// In en, this message translates to:
  /// **'Create Folder'**
  String get createFolder;

  /// No description provided for @editFolder.
  ///
  /// In en, this message translates to:
  /// **'Edit Folder'**
  String get editFolder;

  /// No description provided for @createNewFolder.
  ///
  /// In en, this message translates to:
  /// **'Create New Folder'**
  String get createNewFolder;

  /// No description provided for @searchFolders.
  ///
  /// In en, this message translates to:
  /// **'Search Folders'**
  String get searchFolders;

  /// No description provided for @enterFolderName.
  ///
  /// In en, this message translates to:
  /// **'Enter folder name...'**
  String get enterFolderName;

  /// No description provided for @thisFolderContains.
  ///
  /// In en, this message translates to:
  /// **'This folder contains:'**
  String get thisFolderContains;

  /// No description provided for @actionCannotBeUndone.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get actionCannotBeUndone;

  /// No description provided for @allContentsDeleted.
  ///
  /// In en, this message translates to:
  /// **'All contents will be permanently deleted.'**
  String get allContentsDeleted;

  /// No description provided for @addSubfolder.
  ///
  /// In en, this message translates to:
  /// **'Add subfolder'**
  String get addSubfolder;

  /// No description provided for @parentFolder.
  ///
  /// In en, this message translates to:
  /// **'Parent folder'**
  String get parentFolder;

  /// No description provided for @noParentRoot.
  ///
  /// In en, this message translates to:
  /// **'No parent (root)'**
  String get noParentRoot;

  /// No description provided for @pathLabel.
  ///
  /// In en, this message translates to:
  /// **'Path: '**
  String get pathLabel;

  /// No description provided for @folderName.
  ///
  /// In en, this message translates to:
  /// **'Folder Name'**
  String get folderName;

  /// No description provided for @enterFolderNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter folder name'**
  String get enterFolderNameHint;

  /// No description provided for @pleaseEnterFolderName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a folder name'**
  String get pleaseEnterFolderName;

  /// No description provided for @nameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Name must not exceed {max} characters'**
  String nameTooLong(int max);

  /// No description provided for @enterFolderDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter folder description'**
  String get enterFolderDescription;

  /// No description provided for @chooseColor.
  ///
  /// In en, this message translates to:
  /// **'Choose Color'**
  String get chooseColor;

  /// No description provided for @unknownFolder.
  ///
  /// In en, this message translates to:
  /// **'Unknown folder'**
  String get unknownFolder;

  /// No description provided for @startingStudySession.
  ///
  /// In en, this message translates to:
  /// **'Starting Study Session'**
  String get startingStudySession;

  /// No description provided for @testMode.
  ///
  /// In en, this message translates to:
  /// **'Test Mode'**
  String get testMode;

  /// No description provided for @studyMode.
  ///
  /// In en, this message translates to:
  /// **'Study - {mode}'**
  String studyMode(String mode);

  /// No description provided for @exitTest.
  ///
  /// In en, this message translates to:
  /// **'Exit Test?'**
  String get exitTest;

  /// No description provided for @exitStudySession.
  ///
  /// In en, this message translates to:
  /// **'Exit Study Session?'**
  String get exitStudySession;

  /// No description provided for @saveProgressQuestion.
  ///
  /// In en, this message translates to:
  /// **'Do you want to save your progress?'**
  String get saveProgressQuestion;

  /// No description provided for @progressSaved.
  ///
  /// In en, this message translates to:
  /// **'Study progress saved'**
  String get progressSaved;

  /// No description provided for @sessionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Study session cancelled'**
  String get sessionCancelled;

  /// No description provided for @sessionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Study session completed!'**
  String get sessionCompleted;

  /// No description provided for @failedToLoadFlashcards.
  ///
  /// In en, this message translates to:
  /// **'Failed to load flashcards: {error}'**
  String failedToLoadFlashcards(String error);

  /// No description provided for @noFlashcardsInBatch.
  ///
  /// In en, this message translates to:
  /// **'No flashcards in this batch'**
  String get noFlashcardsInBatch;

  /// No description provided for @meaning.
  ///
  /// In en, this message translates to:
  /// **'Meaning'**
  String get meaning;

  /// No description provided for @term.
  ///
  /// In en, this message translates to:
  /// **'Term'**
  String get term;

  /// No description provided for @show.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show;

  /// No description provided for @remembered.
  ///
  /// In en, this message translates to:
  /// **'Remembered'**
  String get remembered;

  /// No description provided for @forgot.
  ///
  /// In en, this message translates to:
  /// **'Forgot'**
  String get forgot;

  /// No description provided for @matchTermsWithMeanings.
  ///
  /// In en, this message translates to:
  /// **'Match terms with their meanings'**
  String get matchTermsWithMeanings;

  /// No description provided for @matchesProgress.
  ///
  /// In en, this message translates to:
  /// **'Matches: {current} / {total}'**
  String matchesProgress(int current, int total);

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get terms;

  /// No description provided for @meanings.
  ///
  /// In en, this message translates to:
  /// **'Meanings'**
  String get meanings;

  /// No description provided for @incorrectMatch.
  ///
  /// In en, this message translates to:
  /// **'Incorrect match. Try again.'**
  String get incorrectMatch;

  /// No description provided for @typeTheTerm.
  ///
  /// In en, this message translates to:
  /// **'Type the term'**
  String get typeTheTerm;

  /// No description provided for @enterYourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Enter your answer'**
  String get enterYourAnswer;

  /// No description provided for @correctAnswer.
  ///
  /// In en, this message translates to:
  /// **'Correct Answer'**
  String get correctAnswer;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get correct;

  /// No description provided for @progressCount.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total}'**
  String progressCount(int current, int total);

  /// No description provided for @toReview.
  ///
  /// In en, this message translates to:
  /// **'To Review: {count}'**
  String toReview(int count);

  /// No description provided for @timerSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} s'**
  String timerSeconds(int seconds);

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorPrefix(String message);

  /// No description provided for @emptyStateTitle.
  ///
  /// In en, this message translates to:
  /// **'No Items Found'**
  String get emptyStateTitle;

  /// No description provided for @emptyStateMessage.
  ///
  /// In en, this message translates to:
  /// **'There are no items to display at the moment.'**
  String get emptyStateMessage;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No Results Found'**
  String get noResultsFound;

  /// No description provided for @noResultsForQuery.
  ///
  /// In en, this message translates to:
  /// **'No results found for \"{query}\"'**
  String noResultsForQuery(String query);

  /// No description provided for @tryAdjustingSearch.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search criteria.'**
  String get tryAdjustingSearch;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get clearSearch;

  /// No description provided for @noFavoritesYet.
  ///
  /// In en, this message translates to:
  /// **'No Favorites Yet'**
  String get noFavoritesYet;

  /// No description provided for @addFavoritesMessage.
  ///
  /// In en, this message translates to:
  /// **'Start adding items to your favorites to see them here.'**
  String get addFavoritesMessage;

  /// No description provided for @browseItems.
  ///
  /// In en, this message translates to:
  /// **'Browse Items'**
  String get browseItems;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No Notifications'**
  String get noNotifications;

  /// No description provided for @allCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up! No new notifications.'**
  String get allCaughtUp;

  /// No description provided for @noConnection.
  ///
  /// In en, this message translates to:
  /// **'No Connection'**
  String get noConnection;

  /// No description provided for @unableToLoadData.
  ///
  /// In en, this message translates to:
  /// **'Unable to load data. Please check your internet connection.'**
  String get unableToLoadData;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionError;

  /// No description provided for @checkInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again.'**
  String get checkInternetConnection;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server Error'**
  String get serverError;

  /// No description provided for @serverErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our end. Please try again later.'**
  String get serverErrorMessage;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Not Found'**
  String get notFound;

  /// No description provided for @notFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'The resource you are looking for could not be found.'**
  String get notFoundMessage;

  /// No description provided for @accessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get accessDenied;

  /// No description provided for @accessDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to access this resource.'**
  String get accessDeniedMessage;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
