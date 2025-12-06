import 'package:flash_mastery/core/constants/config/view_scopes.dart';
import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/core/router/app_router.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flash_mastery/features/folders/providers.dart';
import 'package:flash_mastery/presentation/screens/folders/widgets/folder_form_dialog.dart';
import 'package:flash_mastery/presentation/widgets/common/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(child: _DashboardScreenBody());
  }
}

class _DashboardScreenBody extends ConsumerWidget {
  const _DashboardScreenBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foldersState = ref.watch(folderListViewModelProvider(ViewScope.dashboard));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(folderListViewModelProvider(ViewScope.dashboard).notifier).load(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: foldersState.when(
          initial: () => const LoadingWidget(),
          loading: () => const LoadingWidget(),
          error: (message) => AppErrorWidget(
            message: message,
            onRetry: () => ref.read(folderListViewModelProvider(ViewScope.dashboard).notifier).load(),
          ),
          success: (folders) {
            final totalFolders = folders.length;
            final totalDecks = folders.fold<int>(0, (sum, f) => sum + f.deckCount);
            final recent = [...folders]..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
            final recentTop = recent.take(4).toList();

            return RefreshIndicator(
              onRefresh: () async => ref.read(folderListViewModelProvider(ViewScope.dashboard).notifier).load(),
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [
                  _HeroBanner(
                    onFolders: () => context.go(AppRouter.folders),
                    onDecks: () => context.go(AppRouter.decks),
                    onCreateFolder: () => _showAddFolderDialog(context, ref, folders),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _InsightGrid(
                    totalFolders: totalFolders,
                    totalDecks: totalDecks,
                    onCreateFolder: () => _showAddFolderDialog(context, ref, folders),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _Highlights(
                    folders: folders,
                    onOpen: (folder) => context.go(AppRouter.decks, extra: folder),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _RecentFolders(
                    folders: recentTop,
                    onOpen: (folder) => context.go(AppRouter.decks, extra: folder),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showAddFolderDialog(BuildContext context, WidgetRef ref, List<Folder> allFolders) async {
    await ref.read(folderListViewModelProvider(ViewScope.dashboard).notifier).load();
    if (!context.mounted) return;
    final folders = ref.read(folderListViewModelProvider(ViewScope.dashboard)).maybeWhen(
          success: (items) => items,
          orElse: () => allFolders,
        );
    await showDialog(
      context: context,
      builder: (context) => FolderFormDialog(
        parentFolder: null,
        allFolders: folders,
        onSubmit: (name, description, color, parentId) async {
          try {
            final errorMessage = await ref.read(folderListViewModelProvider(ViewScope.dashboard).notifier).createFolder(
                  CreateFolderParams(
                    name: name,
                    description: description,
                    color: color,
                    parentId: parentId,
                  ),
                );
            if (context.mounted) {
              Navigator.pop(context);
              if (errorMessage != null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Error: $errorMessage')));
              } else {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Folder created successfully')));
              }
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
            }
          }
        },
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  final VoidCallback onFolders;
  final VoidCallback onDecks;
  final VoidCallback onCreateFolder;

  const _HeroBanner({
    required this.onFolders,
    required this.onDecks,
    required this.onCreateFolder,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.75),
            colorScheme.secondary.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusExtraLarge),
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your flashcard HQ',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Organize knowledge, launch study sessions, and keep momentum.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimary.withValues(alpha: 0.9),
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              FilledButton.icon(
                onPressed: onFolders,
                icon: const Icon(Icons.folder_open),
                label: const Text('Open folders'),
              ),
              FilledButton.icon(
                onPressed: onDecks,
                icon: const Icon(Icons.flash_on),
                label: const Text('Start studying'),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.secondaryContainer,
                  foregroundColor: colorScheme.onSecondaryContainer,
                ),
              ),
              OutlinedButton.icon(
                onPressed: onCreateFolder,
                icon: const Icon(Icons.add),
                label: const Text('New folder'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colorScheme.onPrimary.withValues(alpha: 0.5)),
                  foregroundColor: colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsightGrid extends StatelessWidget {
  final int totalFolders;
  final int totalDecks;
  final VoidCallback onCreateFolder;

  const _InsightGrid({
    required this.totalFolders,
    required this.totalDecks,
    required this.onCreateFolder,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.5,
      ),
      children: [
        _InsightCard(
          title: 'Total folders',
          value: '$totalFolders',
          icon: Icons.folder_special_outlined,
          color: colorScheme.primary,
        ),
        _InsightCard(
          title: 'Total decks',
          value: '$totalDecks',
          icon: Icons.style_outlined,
          color: colorScheme.secondary,
        ),
        _InsightCard(
          title: 'Create now',
          value: 'New folder',
          icon: Icons.create_new_folder_outlined,
          color: colorScheme.tertiary,
          onTap: onCreateFolder,
        ),
        _InsightCard(
          title: 'Stay organized',
          value: 'Jump to folders',
          icon: Icons.space_dashboard_outlined,
          color: colorScheme.error,
          onTap: onCreateFolder,
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _InsightCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppOpacity.low),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color,
            child: Icon(icon, color: Theme.of(context).colorScheme.onPrimary),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.labelMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );

    if (onTap == null) return content;
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      onTap: onTap,
      child: content,
    );
  }
}

class _Highlights extends StatelessWidget {
  final List<Folder> folders;
  final void Function(Folder folder) onOpen;

  const _Highlights({required this.folders, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    if (folders.isEmpty) return const SizedBox.shrink();
    final best = [...folders]..sort((a, b) => b.deckCount.compareTo(a.deckCount));
    final topThree = best.take(3).toList();
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Top folders', style: Theme.of(context).textTheme.titleMedium),
            TextButton(onPressed: () => context.go(AppRouter.folders), child: const Text('View all')),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 140,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: topThree.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (context, index) {
              final folder = topThree[index];
              return SizedBox(
                width: 220,
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                  onTap: () => onOpen(folder),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.folder_open, color: colorScheme.primary),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                folder.name,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${folder.deckCount} deck${folder.deckCount == 1 ? '' : 's'} • ${folder.subFolderCount} subfolder${folder.subFolderCount == 1 ? '' : 's'}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RecentFolders extends StatelessWidget {
  final List<Folder> folders;
  final void Function(Folder folder) onOpen;

  const _RecentFolders({required this.folders, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    if (folders.isEmpty) return const SizedBox.shrink();
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent activity', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        ...folders.map(
          (folder) => Card(
            elevation: AppSpacing.elevationLow,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSpacing.radiusLarge)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: colorScheme.primary.withValues(alpha: AppOpacity.low),
                child: const Icon(Icons.folder, color: Colors.white),
              ),
              title: Text(folder.name),
              subtitle: Text(
                '${folder.deckCount} deck${folder.deckCount == 1 ? '' : 's'} • updated ${folder.updatedAt.toLocal()}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => onOpen(folder),
            ),
          ),
        ),
      ],
    );
  }
}
