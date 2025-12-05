import 'package:flash_mastery/core/constants/constants.dart';
import 'package:flash_mastery/core/router/app_router.dart';
import 'package:flash_mastery/domain/entities/folder.dart';
import 'package:flash_mastery/features/folders/providers.dart';
import 'package:flash_mastery/presentation/screens/folders/widgets/folder_form_dialog.dart';
import 'package:flash_mastery/presentation/widgets/common/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final folderState = ref.watch(folderListViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(folderListViewModelProvider.notifier).load(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: folderState.when(
        initial: () => const LoadingWidget(),
        loading: () => const LoadingWidget(),
        error: (message) => AppErrorWidget(
          message: message,
          onRetry: () => ref.read(folderListViewModelProvider.notifier).load(),
        ),
        success: (folders) {
          final totalFolders = folders.length;
          final totalDecks = folders.fold<int>(0, (sum, f) => sum + f.deckCount);
          final recent = [...folders]..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          final recentTop = recent.take(3).toList();

          return RefreshIndicator(
            onRefresh: () async => ref.read(folderListViewModelProvider.notifier).load(),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                _HeroCard(
                  onFolders: () => context.go(AppRouter.folders),
                  onDecks: () => context.go(AppRouter.decks),
                  onCreateFolder: () => _showAddFolderDialog(context, ref, folders),
                ),
                const SizedBox(height: AppSpacing.lg),
                _StatsRow(totalFolders: totalFolders, totalDecks: totalDecks),
                const SizedBox(height: AppSpacing.lg),
                _QuickActions(
                  onFolders: () => context.go(AppRouter.folders),
                  onDecks: () => context.go(AppRouter.decks),
                  onCreateFolder: () => _showAddFolderDialog(context, ref, folders),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (recentTop.isNotEmpty)
                  _RecentFolders(
                    folders: recentTop,
                    onOpen: (folder) => context.go(AppRouter.decks, extra: folder),
                  )
                else
                  const EmptyStateWidget(
                    icon: Icons.folder_outlined,
                    title: 'No folders yet',
                    message: 'Create your first folder to get started',
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddFolderDialog(
          context,
          ref,
          ref.read(folderListViewModelProvider).maybeWhen(success: (folders) => folders, orElse: () => const []),
        ),
        icon: const Icon(Icons.create_new_folder),
        label: const Text('New Folder'),
      ),
    );
  }

  Future<void> _showAddFolderDialog(BuildContext context, WidgetRef ref, List<Folder> allFolders) async {
    await ref.read(folderListViewModelProvider.notifier).load();
    if (!context.mounted) return;
    final folders = ref.read(folderListViewModelProvider).maybeWhen(
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
            final errorMessage = await ref.read(folderListViewModelProvider.notifier).createFolder(
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

class _HeroCard extends StatelessWidget {
  final VoidCallback onFolders;
  final VoidCallback onDecks;
  final VoidCallback onCreateFolder;

  const _HeroCard({
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
          colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.6)],
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
            'Flash Mastery',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Organize folders, build decks, and keep learning.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              FilledButton.icon(
                onPressed: onFolders,
                icon: const Icon(Icons.folder_open),
                label: const Text('Open Folders'),
              ),
              OutlinedButton.icon(
                onPressed: onDecks,
                icon: const Icon(Icons.style),
                label: const Text('Go to Decks'),
                style: OutlinedButton.styleFrom(foregroundColor: colorScheme.onPrimary),
              ),
              TextButton.icon(
                onPressed: onCreateFolder,
                icon: const Icon(Icons.create_new_folder),
                label: const Text('New Folder'),
                style: TextButton.styleFrom(foregroundColor: colorScheme.onPrimary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int totalFolders;
  final int totalDecks;

  const _StatsRow({required this.totalFolders, required this.totalDecks});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.folder_outlined,
            label: 'Folders',
            value: '$totalFolders',
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _StatCard(
            icon: Icons.style_outlined,
            label: 'Decks',
            value: '$totalDecks',
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppOpacity.low),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            ),
            child: Icon(icon, color: colorScheme.onPrimary),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelMedium),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  final VoidCallback onFolders;
  final VoidCallback onDecks;
  final VoidCallback onCreateFolder;

  const _QuickActions({
    required this.onFolders,
    required this.onDecks,
    required this.onCreateFolder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick actions', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          children: [
            FilledButton.icon(
              onPressed: onCreateFolder,
              icon: const Icon(Icons.create_new_folder),
              label: const Text('New Folder'),
            ),
            OutlinedButton.icon(
              onPressed: onFolders,
              icon: const Icon(Icons.folder_open),
              label: const Text('View Folders'),
            ),
            OutlinedButton.icon(
              onPressed: onDecks,
              icon: const Icon(Icons.style),
              label: const Text('View Decks'),
            ),
          ],
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
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent folders', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        ...folders.map(
          (folder) => Card(
            elevation: AppSpacing.elevationLow,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: colorScheme.primary.withValues(alpha: AppOpacity.low),
                child: const Icon(Icons.folder, color: Colors.white),
              ),
              title: Text(folder.name),
              subtitle: Text('${folder.deckCount} deck${folder.deckCount == 1 ? '' : 's'}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => onOpen(folder),
            ),
          ),
        ),
      ],
    );
  }
}
