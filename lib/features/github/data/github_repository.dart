import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;





class GitHubRepo {
  final String name;
  final String? description;
  final String url;
  final int stars;
  final int forks;
  final String? language;
  final bool isForked;

  const GitHubRepo({
    required this.name,
    this.description,
    required this.url,
    required this.stars,
    required this.forks,
    this.language,
    required this.isForked,
  });

  factory GitHubRepo.fromJson(Map<String, dynamic> json) => GitHubRepo(
        name: json['name'] as String,
        description: json['description'] as String?,
        url: json['html_url'] as String,
        stars: json['stargazers_count'] as int? ?? 0,
        forks: json['forks_count'] as int? ?? 0,
        language: json['language'] as String?,
        isForked: json['fork'] as bool? ?? false,
      );
}

class ContributionDay {
  final DateTime date;
  final int count;
  final int level;

  const ContributionDay({
    required this.date,
    required this.count,
    required this.level,
  });
}

class GitHubStats {
  final List<GitHubRepo> pinnedRepos;
  final List<ContributionDay> contributions;
  final int totalContributions;
  final String? avatarUrl;
  final int followers;
  final int following;
  final int publicRepos;

  const GitHubStats({
    required this.pinnedRepos,
    required this.contributions,
    required this.totalContributions,
    this.avatarUrl,
    required this.followers,
    required this.following,
    required this.publicRepos,
  });
}





class GitHubRepository {
  static const _base = 'https://api.github.com';

  
  
  
  static const _token = String.fromEnvironment('GH_TOKEN', defaultValue: '');

  Future<GitHubStats> fetchStats(String username) async {
    try {
      final authHeaders = _token.isNotEmpty
          ? {'Authorization': 'bearer $_token'}
          : <String, String>{};

      
      final results = await Future.wait([
        
        http.get(
          Uri.parse('$_base/users/$username'),
          headers: {
            'Accept': 'application/vnd.github.v3+json',
            ...authHeaders,
          },
        ),

        
        http.get(
          Uri.parse(
              '$_base/users/$username/repos?sort=stars&per_page=6&type=owner'),
          headers: {
            'Accept': 'application/vnd.github.v3+json',
            ...authHeaders,
          },
        ),

        
        
        
        
        
        http.get(
          Uri.parse(
              'https://github-contributions-api.jogruber.de/v4/$username?y=last'),
          headers: {'Accept': 'application/json'},
        ),
      ]);

      final userRes          = results[0];
      final reposRes         = results[1];
      final contributionsRes = results[2];

      
      Map<String, dynamic> user = {};
      if (userRes.statusCode == 200) {
        user = jsonDecode(userRes.body) as Map<String, dynamic>;
      }

      
      List<GitHubRepo> repos = [];
      if (reposRes.statusCode == 200) {
        final list = jsonDecode(reposRes.body) as List<dynamic>;
        repos = list
            .map((e) => GitHubRepo.fromJson(e as Map<String, dynamic>))
            .where((r) => !r.isForked)
            .take(4)
            .toList();
      }

      
      List<ContributionDay> contributions = [];
      int totalContributions = 0;

      if (contributionsRes.statusCode == 200) {
        final parsed = _parseContributionsProxy(contributionsRes.body);
        contributions = parsed.$1;
        totalContributions = parsed.$2;
      }

      
      if (contributions.isEmpty) {
        contributions = _generateMockContributions();
        totalContributions =
            contributions.fold(0, (sum, d) => sum + d.count);
      }

      return GitHubStats(
        pinnedRepos: repos,
        contributions: contributions,
        totalContributions: totalContributions,
        avatarUrl: user['avatar_url'] as String?,
        followers: user['followers'] as int? ?? 0,
        following: user['following'] as int? ?? 0,
        publicRepos: user['public_repos'] as int? ?? 0,
      );
    } catch (_) {
      final mock = _generateMockContributions();
      return GitHubStats(
        pinnedRepos: const [],
        contributions: mock,
        totalContributions: mock.fold(0, (sum, d) => sum + d.count),
        followers: 0,
        following: 0,
        publicRepos: 0,
      );
    }
  }

  
  
  
  
  
  
  
  
  
  
  
  

  (List<ContributionDay>, int) _parseContributionsProxy(String body) {
    try {
      final json = jsonDecode(body) as Map<String, dynamic>;

      
      int total = 0;
      final totalMap = json['total'] as Map<String, dynamic>?;
      if (totalMap != null) {
        for (final v in totalMap.values) {
          total += (v as int? ?? 0);
        }
      }

      final rawDays = json['contributions'] as List<dynamic>? ?? [];
      final days = <ContributionDay>[];

      for (final item in rawDays) {
        final map     = item as Map<String, dynamic>;
        final dateStr = map['date'] as String?;
        final count   = map['count'] as int? ?? 0;
        final level   = map['level'] as int? ?? 0;

        if (dateStr == null) continue;
        final date = DateTime.tryParse(dateStr);
        if (date == null) continue;

        days.add(ContributionDay(date: date, count: count, level: level));
      }

      
      days.sort((a, b) => a.date.compareTo(b.date));

      
      if (total == 0 && days.isNotEmpty) {
        total = days.fold(0, (sum, d) => sum + d.count);
      }

      return (days, total);
    } catch (_) {
      return (<ContributionDay>[], 0);
    }
  }

  
  
  
  
  

  static List<ContributionDay> _generateMockContributions() {
    final days = <ContributionDay>[];
    final now  = DateTime.now();
    const pattern = [
      0, 0, 1, 2, 0, 3, 0, 1, 5, 2,
      0, 0, 7, 3, 1, 0, 4, 2, 8, 0,
    ];

    for (int i = 365; i >= 0; i--) {
      final date  = now.subtract(Duration(days: i));
      final base  = pattern[(i + date.weekday) % pattern.length];
      final noise = (i * 7 + date.day) % 5;
      final count = (base + (noise > 3 ? noise - 2 : 0)).clamp(0, 12);
      days.add(ContributionDay(
        date:  date,
        count: count,
        level: (count / 2).clamp(0, 5).toInt(),
      ));
    }
    return days;
  }
}





final gitHubRepositoryProvider = Provider<GitHubRepository>((ref) {
  return GitHubRepository();
});

final gitHubStatsProvider =
    FutureProvider.family<GitHubStats, String>((ref, username) async {
  final repo = ref.watch(gitHubRepositoryProvider);
  return repo.fetchStats(username);
});