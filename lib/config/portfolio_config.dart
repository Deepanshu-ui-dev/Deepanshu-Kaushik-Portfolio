class PortfolioConfig {
  static const String initials = 'DK';
  static const String name = 'Deepanshu Kaushik';
  static const String firstName = 'Deepanshu';
  static const int age = 20;
  static const String location = 'Delhi, India';
  static const String role = 'Flutter Developer • Software Engineer';
  static const String email = 'imdeepanshu4work@gmail.com';
  static const String phone = '+91 9582405021';

  static const String githubUrl = 'https://github.com/Deepanshu-ui-dev';
  static const String resumeUrl = 'https://drive.google.com/file/d/1pljNCb9yXzrtyHjMgQpAuhskZcyRy6FW/view?usp=sharing';
  static const String githubUsername = 'Deepanshu-ui-dev';
  static const String linkedinUrl = 'https://www.linkedin.com/in/imdeepanshukaushik/';
  static const String twitterUrl = 'https://x.com/Deepanshu25u';
  static const String websiteUrl = 'https://deepanshui.framer.website/';
  static const String visitorApiUrl = 'https://api.counterapi.dev/v1/deepanshux.tech/visits';

  
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://jqddkjhxjsuskpebqgfr.supabase.co',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpxZGRramh4anN1c2twZWJxZ2ZyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY1OTc1MjksImV4cCI6MjA5MjE3MzUyOX0.LVL9t6ix1z4hOJirqY83pw8M89m_3ZIl9okB0Z7aR5Y',
  );

  static const String bio =
      'I\'m a UI/UX designer and Flutter developer currently pursuing B.Tech in Data Science at ABES Engineering College (2023–2027). '
      'I craft pixel-perfect interfaces and scalable design systems — currently working as Founding Designer at Layerance while freelancing for web and mobile clients worldwide. '
      'I believe great products live at the intersection of clean code, bold design, and deep empathy for users.';

  // ── Editorial home page content ───────────────────────────────────
  static const String shortName = 'Deepanshu';
  static const String phonetic = '/dee · pan · shu/';
  static const String headline = 'Flutter Developer & Software Engineer';

  /// Rotating roles shown under the name in the hero.
  static const List<String> roles = [
    'Flutter Developer',
    'Software Engineer',
    'Full-stack Builder',
    'Design-minded Engineer',
  ];
  static const String timezoneLabel = 'IST';
  static const int utcOffsetMinutes = 330; // India Standard Time, UTC+5:30
  static const String repoUrl =
      'https://github.com/Deepanshu-ui-dev/Deepanshu-Kaushik-Portfolio';
  static const bool openToWork = true;

  static const List<String> aboutBullets = [
    'Recently shipped Codexa (developer analytics across six platforms), QuizForge (timed assessments with server-side grading) and MediAuth AI (multi-agent healthcare automation).',
    'Pursuing B.Tech in Data Science at ABES Engineering College (2023–2027), with 450+ problems solved on LeetCode.',
    'A UI/UX background means what I ship is as considered as it is correct. Open to Flutter and SDE roles.',
  ];

  /// Public-domain recording bundled in assets/audio (Musopen via Wikimedia Commons).
  static const NowPlaying nowPlaying = NowPlaying(
    title: 'Gymnopédie No. 1 ( 1888 )',
    artist: 'Erik Satie · Robin Alciatore',
    asset: 'assets/audio/gymnopedie_1.mp3',
  );

  static const List<RoleItem> experience = [
    RoleItem(
      role: 'Flutter & Full-stack Developer',
      company: 'Independent Projects',
      period: '2024 – Present',
      isCurrent: true,
      summary:
          'Designing, building and shipping production apps end-to-end — from Flutter clients to the services and data layers behind them.',
      phases: [
        RolePhase('Cross-platform apps',
            'Codexa and FinTrack — Flutter apps on Firebase / Cloud Firestore and offline-first Hive storage, with Riverpod for state.'),
        RolePhase('Backend systems',
            'QuizForge — Node.js + Express with Prisma on PostgreSQL, plus Redis and RabbitMQ for timed, server-graded assessments.'),
        RolePhase('Applied AI',
            'MediAuth AI and Meridian — LangGraph multi-agent workflows on FastAPI, and OpenAI-powered job matching.'),
      ],
      tags: ['Flutter', 'Dart', 'Node.js', 'PostgreSQL', 'Redis', 'FastAPI'],
    ),
  ];

  static const List<StatItem> stats = [
    StatItem(10, '+', 'Projects Built'),
    StatItem(null, 'Flutter', 'Primary Stack'),
    StatItem(3, '+', 'Client Projects'),
    StatItem(450, '+', 'LeetCode Solved'),
  ];

  /// Flutter-specific capabilities shown above the tech-stack chips.
  static const List<(String, String)> flutterToolkit = [
    ('State', 'Riverpod'),
    ('Storage', 'Hive · Firestore'),
    ('Backend', 'Firebase · Supabase · REST'),
    ('Platforms', 'Android · iOS · Web'),
    ('UI', 'Custom painters · Animations'),
    ('Tooling', 'Android Studio · Git · Postman'),
  ];

  static const List<String> techCategories = [
    'All', 'Mobile', 'Languages', 'Backend', 'Databases', 'AI / ML', 'Web', 'Tools',
  ];

  /// `icon` is a file in assets/icons/tech (Simple Icons); `hex` is the brand
  /// colour revealed on hover. Items without an icon fall back to [TechItem.glyph].
  static const List<TechItem> techStack = [
    TechItem('Flutter', 'Mobile', icon: 'flutter', hex: 0xFF02569B),
    TechItem('Dart', 'Mobile', icon: 'dart', hex: 0xFF0175C2),
    TechItem('Riverpod', 'Mobile', glyph: 0),
    TechItem('Hive', 'Mobile', glyph: 1),
    TechItem('Android', 'Mobile', icon: 'android', hex: 0xFF3DDC84),
    TechItem('iOS', 'Mobile', icon: 'ios'),
    TechItem('Python', 'Languages', icon: 'python', hex: 0xFF3776AB),
    TechItem('C++', 'Languages', icon: 'cplusplus', hex: 0xFF00599C),
    TechItem('JavaScript', 'Languages', icon: 'javascript', hex: 0xFFF7DF1E),
    TechItem('SQL', 'Languages', glyph: 5),
    TechItem('Node.js', 'Backend', icon: 'nodedotjs', hex: 0xFF5FA04E),
    TechItem('Express', 'Backend', icon: 'express'),
    TechItem('FastAPI', 'Backend', icon: 'fastapi', hex: 0xFF009688),
    TechItem('Firebase', 'Backend', icon: 'firebase', hex: 0xFFDD2C00),
    TechItem('Supabase', 'Backend', icon: 'supabase', hex: 0xFF3FCF8E),
    TechItem('RabbitMQ', 'Backend', icon: 'rabbitmq', hex: 0xFFFF6600),
    TechItem('REST APIs', 'Backend', glyph: 2),
    TechItem('PostgreSQL', 'Databases', icon: 'postgresql', hex: 0xFF4169E1),
    TechItem('Prisma', 'Databases', icon: 'prisma'),
    TechItem('Redis', 'Databases', icon: 'redis', hex: 0xFFFF4438),
    TechItem('Cloud Firestore', 'Databases', icon: 'firebase', hex: 0xFFFFA000),
    TechItem('LangGraph', 'AI / ML', icon: 'langchain'),
    TechItem('OpenAI', 'AI / ML', icon: 'openai'),
    TechItem('Groq', 'AI / ML', glyph: 3),
    TechItem('ChromaDB', 'AI / ML', glyph: 4),
    TechItem('React', 'Web', icon: 'react', hex: 0xFF61DAFB),
    TechItem('HTML5', 'Web', icon: 'html5', hex: 0xFFE34F26),
    TechItem('CSS3', 'Web', icon: 'css3', hex: 0xFF1572B6),
    TechItem('Git', 'Tools', icon: 'git', hex: 0xFFF05032),
    TechItem('GitHub', 'Tools', icon: 'github'),
    TechItem('Android Studio', 'Tools', icon: 'androidstudio', hex: 0xFF3DDC84),
    TechItem('Postman', 'Tools', icon: 'postman', hex: 0xFFFF6C37),
    TechItem('Vercel', 'Tools', icon: 'vercel'),
    TechItem('Figma', 'Tools', icon: 'figma', hex: 0xFFF24E1E),
  ];

  static const String college = 'ABES Engineering College (ABESEC)';
  static const String degree = 'B.Tech — Data Science';
  static const String eduPeriod = '2023 — 2027';

  static const List<ProjectItem> projects = [
    ProjectItem(
      name: 'Codexa',
      tagline: 'Developer analytics',
      year: '2025',
      imageAsset: 'assets/images/proj_codexa.jpg',
      description:
          'A unified coding analytics platform aggregating competitive-programming statistics from six platforms into one dashboard.',
      features: [
        'Multi-platform developer statistics',
        'Performance analytics and submission heatmaps',
        'Contest tracking and rating history',
        'Goal setting and leaderboards',
      ],
      tags: ['Flutter', 'Dart', 'Firebase', 'Cloud Firestore', 'REST APIs'],
      categories: ['Flutter'],
      architecture: ['Flutter client', 'REST adapters x6', 'Firebase Auth', 'Cloud Firestore'],
      badge: 'Live',
      liveUrl: 'https://codexa-app-six.vercel.app/',
      githubUrl: 'https://github.com/Deepanshu-ui-dev/Codexa-App',
      installUrl: 'https://github.com/Deepanshu-ui-dev/Codexa-App/releases/latest/',
    ),
    ProjectItem(
      name: 'QuizForge',
      tagline: 'Teacher & student assessment platform',
      year: '2025',
      imageAsset: null,
      description:
          'A full-stack assessment ecosystem: teachers build quizzes, students sit timed assessments, and the server grades and publishes results.',
      features: [
        'Teacher and student authentication',
        'Quiz and question management',
        'Timed assessments',
        'Server-side evaluation and results',
      ],
      tags: ['Flutter', 'Node.js', 'Express', 'Prisma', 'PostgreSQL', 'Redis', 'RabbitMQ'],
      categories: ['Flutter', 'Full-stack'],
      architecture: ['Flutter client', 'Express API', 'RabbitMQ queue', 'PostgreSQL + Prisma', 'Redis'],
      githubUrl: 'https://github.com/Deepanshu-ui-dev/QuizForge---Teacher-and-Student-Assessment-Platform',
    ),
    ProjectItem(
      name: 'Meridian',
      tagline: 'AI career & hiring platform',
      year: '2025',
      imageAsset: 'assets/images/proj_meridian.jpg',
      description:
          'An AI-powered hiring ecosystem connecting candidates and recruiters — from ATS-ready resumes to recruiter pipelines.',
      features: [
        'AI-powered job matching',
        'ATS resume optimisation',
        'Application tracking',
        'Recruiter dashboards',
        'Applicant screening and hiring pipelines',
      ],
      tags: ['React', 'Node.js', 'Express', 'PostgreSQL', 'OpenAI'],
      categories: ['Full-stack', 'AI / ML'],
      architecture: ['React client', 'Express API', 'OpenAI', 'PostgreSQL'],
      badge: 'Live',
      liveUrl: 'https://meridian-fawn-nu.vercel.app/',
      githubUrl: 'https://github.com/Deepanshu-ui-dev/Meridian',
    ),
    ProjectItem(
      name: 'MediAuth AI',
      tagline: 'Healthcare prior-auth automation',
      year: '2025',
      imageAsset: null,
      description:
          'A multi-agent AI system that automates insurance prior-authorisation — from patient intake to appeal letters.',
      features: [
        'Patient intake and medical analysis',
        'Insurance policy intelligence',
        'Automated authorisation letters',
        'Denial analysis and appeal workflows',
      ],
      tags: ['LangGraph', 'FastAPI', 'Flutter', 'Groq', 'ChromaDB'],
      categories: ['AI / ML', 'Flutter'],
      architecture: ['Flutter client', 'FastAPI', 'LangGraph agents', 'Groq LLM', 'ChromaDB'],
      githubUrl: 'https://github.com/JainRamyak/MediAuth-AI',
    ),
    ProjectItem(
      name: 'FinTrack',
      tagline: 'Offline-first personal finance',
      year: '2025',
      imageAsset: 'assets/images/proj_fintrack.jpg',
      description:
          'A personal finance app built offline-first in Flutter — expense tracking, budget goals, biometric auth and analytics.',
      features: [
        'Expense tracking and budget goals',
        'Biometric authentication',
        'Spending analytics',
        'Works fully offline with Hive',
      ],
      tags: ['Flutter', 'Riverpod', 'Hive', 'FinTech'],
      categories: ['Flutter'],
      architecture: ['Flutter UI', 'Riverpod', 'Hive (local)'],
      githubUrl: 'https://github.com/Deepanshu-ui-dev/Fintrack',
      installUrl: 'https://github.com/Deepanshu-ui-dev/Fintrack/releases/latest/',
    ),
    ProjectItem(
      name: 'Chat App',
      tagline: 'Real-time messaging in Flutter',
      year: '2024',
      imageAsset: 'assets/images/proj_chat.jpg',
      description:
          'A Flutter chat application with real-time messaging and user authentication on a Supabase backend.',
      features: ['Real-time messaging', 'User authentication', 'Clean, minimal chat UI'],
      tags: ['Flutter', 'Supabase', 'Real-time'],
      categories: ['Flutter'],
      architecture: ['Flutter client', 'Supabase Auth', 'Supabase Realtime'],
      githubUrl: 'https://github.com/Deepanshu-ui-dev/Chat-app-flutter',
    ),
    ProjectItem(
      name: 'Document Search Engine',
      tagline: 'Inverted index + TF-IDF',
      year: '2024',
      imageAsset: 'assets/images/proj_searchengine.jpg',
      description:
          'A document search engine using an inverted index and TF-IDF ranking, with fast keyword and phrase queries via positional indexing.',
      features: ['Inverted index', 'TF-IDF ranking', 'Phrase queries via positional indexing', 'CLI interface'],
      tags: ['Python', 'Algorithms', 'NLP', 'CLI'],
      categories: ['Systems'],
      architecture: ['Tokenizer', 'Positional index', 'TF-IDF ranker', 'CLI'],
      githubUrl: 'https://github.com/Deepanshu-ui-dev/Document-Search-Engine',
    ),
    ProjectItem(
      name: 'This Portfolio',
      tagline: 'Flutter Web, built from scratch',
      year: '2026',
      imageAsset: 'assets/images/proj_portfolio.jpg',
      description:
          'This site — Flutter Web with a custom design system, command palette, live GitHub graph, audio player and dark mode.',
      features: ['Custom painters and animations', 'Command palette (Cmd/Ctrl + K)', 'Live GitHub contributions', 'Supabase visitor counter'],
      tags: ['Flutter', 'Dart', 'Riverpod', 'Supabase'],
      categories: ['Flutter'],
      architecture: ['Flutter Web', 'Riverpod', 'Supabase', 'GitHub API'],
      githubUrl: 'https://github.com/Deepanshu-ui-dev/Deepanshu-Kaushik-Portfolio',
      liveUrl: 'https://www.deepanshux.tech/',
    ),
    ProjectItem(
      name: 'BarterNow',
      tagline: 'Sponsorship marketplace — product design',
      year: '2025',
      description:
          'An AI-powered sponsorship marketplace connecting sponsors and event organisers with smart matching and secure payments.',
      tags: ['UI/UX', 'Figma', 'Marketplace'],
      categories: ['Design'],
      figmaUrl: 'https://www.figma.com/design/JSusKlnQlKXZuxwTEDqWn0/BARTERNOW?node-id=0-1&t=niAU5psXEhRhiZFA-1',
    ),
    ProjectItem(
      name: 'Know Your College',
      tagline: 'Admissions journey — product design',
      year: '2024',
      description:
          'Streamlines the admission journey with verified insights, personalised mentorship and real-time data.',
      tags: ['UI/UX', 'Figma', 'EdTech'],
      categories: ['Design'],
      figmaUrl: 'https://www.figma.com/design/fSjnCY31C5NrGjkap5iofA/Know-Your-College?node-id=0-1&t=A3fmcd9PgvB8WXbW-1',
    ),
  ];
}

class ProjectItem {
  final String name;
  final String description;
  final List<String> tags;
  final String? year;
  final String? imageAsset;
  final String? badge;
  final String? githubUrl;
  final String? liveUrl;
  final String? installUrl;
  final String? figmaUrl;
  final String? tagline;
  final List<String> features;
  final List<String> categories;
  final List<String> architecture;

  const ProjectItem({
    required this.name,
    required this.description,
    required this.tags,
    this.tagline,
    this.features = const [],
    this.categories = const [],
    this.architecture = const [],
    this.year,
    this.imageAsset,
    this.badge,
    this.githubUrl,
    this.liveUrl,
    this.installUrl,
    this.figmaUrl,
  });
}

class NowPlaying {
  final String title;
  final String artist;
  final String asset;
  const NowPlaying({required this.title, required this.artist, required this.asset});
}

class RolePhase {
  final String title;
  final String body;
  const RolePhase(this.title, this.body);
}

class RoleItem {
  final String role;
  final String company;
  final String period;
  final bool isCurrent;
  final String summary;
  final List<RolePhase> phases;
  final List<String> tags;
  const RoleItem({
    required this.role,
    required this.company,
    required this.period,
    required this.summary,
    required this.phases,
    this.tags = const [],
    this.isCurrent = false,
  });
}

class StatItem {
  /// When non-null the value counts up on scroll; otherwise [suffix] is shown as-is.
  final int? value;
  final String suffix;
  final String label;
  const StatItem(this.value, this.suffix, this.label);
}

class TechItem {
  final String label;
  final String category;
  final String? icon;
  final int? hex;

  /// Fallback glyph index for tools without a brand icon (see TechLogo).
  final int? glyph;
  const TechItem(this.label, this.category, {this.icon, this.hex, this.glyph});
}

class ExperienceItem {
  final String company;
  final String duration;
  final bool isCurrent;
  final List<String> bullets;
  final List<String> tags;

  const ExperienceItem({
    required this.company,
    required this.duration,
    required this.bullets,
    required this.tags,
    this.isCurrent = false,
  });
}