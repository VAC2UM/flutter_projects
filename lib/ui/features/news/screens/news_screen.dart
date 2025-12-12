import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../delegates/news_cubit.dart';
import '../delegates/news_state.dart';
import '../widgets/news_article_tile.dart';
import '../../../shared/empty_state.dart';
import '../../../shared/theme_state.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  int _selectedTab = 0;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchMode = false;

  @override
  void initState() {
    super.initState();
    // Загружаем новости о кино при открытии экрана
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsCubit>().loadMoviesNews();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      context.read<NewsCubit>().search(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ThemeState.of(context);
    final cubit = context.read<NewsCubit>();

    return Scaffold(
      appBar: AppBar(
        title: _isSearchMode
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(
                  color: themeState.currentTheme.colorScheme.onPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Поиск новостей...',
                  hintStyle: TextStyle(
                    color: themeState.currentTheme.colorScheme.onPrimary
                        .withOpacity(0.7),
                  ),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: _performSearch,
                    color: themeState.currentTheme.colorScheme.onPrimary,
                  ),
                ),
                onSubmitted: (_) => _performSearch(),
              )
            : const Text('Новости о кино'),
        backgroundColor: themeState.currentTheme.colorScheme.primary,
        foregroundColor: themeState.currentTheme.colorScheme.onPrimary,
        leading: IconButton(
          icon: Icon(_isSearchMode ? Icons.close : Icons.arrow_back),
          onPressed: () {
            if (_isSearchMode) {
              setState(() {
                _isSearchMode = false;
                _searchController.clear();
              });
              // Возвращаемся к предыдущей вкладке
              if (_selectedTab == 0) {
                cubit.loadMoviesNews();
              } else if (_selectedTab == 1) {
                cubit.loadTopHeadlines();
              }
            } else {
              context.pop();
            }
          },
        ),
        actions: [
          if (!_isSearchMode) ...[
            IconButton(
              icon: const Icon(Icons.source),
              onPressed: () => _showSourceDialog(context, cubit),
              tooltip: 'По источнику',
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _showDateRangeDialog(context, cubit),
              tooltip: 'За период',
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearchMode = true;
                });
              },
            ),
          ],
        ],
        bottom: _isSearchMode
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTabButton(context, 'О кино', 0, () {
                        setState(() => _selectedTab = 0);
                        cubit.loadMoviesNews();
                      }),
                    ),
                    Expanded(
                      child: _buildTabButton(context, 'Топ новости', 1, () {
                        setState(() => _selectedTab = 1);
                        cubit.loadTopHeadlines();
                      }),
                    ),
                  ],
                ),
              ),
      ),
      body: BlocBuilder<NewsCubit, NewsState>(
        builder: (context, state) {
          if (state is NewsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NewsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NewsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: themeState.currentTheme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: themeState.currentTheme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      if (_isSearchMode && _searchController.text.isNotEmpty) {
                        cubit.search(_searchController.text);
                      } else if (_selectedTab == 0) {
                        cubit.loadMoviesNews();
                      } else if (_selectedTab == 1) {
                        cubit.loadTopHeadlines();
                      }
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state is NewsLoaded) {
            if (state.articles.isEmpty) {
              return EmptyState(
                icon: Icons.article,
                title: 'Нет новостей',
                subtitle: 'Новости не найдены',
                themeState: themeState,
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                if (_isSearchMode && _searchController.text.isNotEmpty) {
                  cubit.search(_searchController.text);
                } else if (_selectedTab == 0) {
                  cubit.loadMoviesNews();
                } else if (_selectedTab == 1) {
                  cubit.loadTopHeadlines();
                }
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.articles.length,
                itemBuilder: (context, index) {
                  final article = state.articles[index];
                  return NewsArticleTile(article: article);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context,
    String label,
    int index,
    VoidCallback onTap,
  ) {
    final themeState = ThemeState.of(context);
    final isSelected = _selectedTab == index;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? themeState.currentTheme.colorScheme.primaryContainer
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? themeState.currentTheme.colorScheme.primary
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected
                ? themeState.currentTheme.colorScheme.onPrimaryContainer
                : themeState.currentTheme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  void _showSourceDialog(BuildContext context, NewsCubit cubit) {
    final sourceController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Новости по источнику'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: sourceController,
              decoration: const InputDecoration(
                labelText: 'ID источника',
                hintText: 'Например: bbc-news, techcrunch',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Популярные источники:\nbbc-news, techcrunch, the-verge, wired',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final source = sourceController.text.trim();
              if (source.isNotEmpty) {
                Navigator.of(dialogContext).pop();
                setState(() {
                  _selectedTab = -1; // Специальный индекс для источника
                });
                cubit.loadBySource(source);
              }
            },
            child: const Text('Загрузить'),
          ),
        ],
      ),
    );
  }

  void _showDateRangeDialog(BuildContext context, NewsCubit cubit) {
    final fromController = TextEditingController();
    final toController = TextEditingController();

    // Устанавливаем значения по умолчанию (последние 7 дней)
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    toController.text =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    fromController.text =
        '${weekAgo.year}-${weekAgo.month.toString().padLeft(2, '0')}-${weekAgo.day.toString().padLeft(2, '0')}';

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Новости за период'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: fromController,
              decoration: const InputDecoration(
                labelText: 'От (YYYY-MM-DD)',
                hintText: '2024-01-01',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: toController,
              decoration: const InputDecoration(
                labelText: 'До (YYYY-MM-DD)',
                hintText: '2024-01-07',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Отмена'),
          ),
          ElevatedButton(
            onPressed: () {
              final from = fromController.text.trim();
              final to = toController.text.trim();
              if (from.isNotEmpty && to.isNotEmpty) {
                Navigator.of(dialogContext).pop();
                setState(() {
                  _selectedTab = -2; // Специальный индекс для дат
                });
                cubit.loadByDateRange(from, to);
              }
            },
            child: const Text('Загрузить'),
          ),
        ],
      ),
    );
  }
}
