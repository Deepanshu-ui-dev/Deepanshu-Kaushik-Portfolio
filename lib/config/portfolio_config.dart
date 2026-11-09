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
  static const String resumeUrl = 'https://drive.google.com/file/d/1pmUJ7YIkmHIeHix5EdRUmW0xJWNAEdqR/view?usp=drivesdk';
  static const String githubUsername = 'Deepanshu-ui-dev';
  static const String linkedinUrl = 'https://www.linkedin.com/in/imdeepanshukaushik/';
  static const String twitterUrl = 'https://x.com/Deepanshu25u';
  static const String websiteUrl = 'https://www.deepanshux.tech/';
  static const String framerUrl = 'https://imdeepanshu.framer.ai/';
  static const String framerHandle = 'imdeepanshu.framer.ai';
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
      'I am a Flutter developer and software engineer pursuing B.Tech in Data Science at ABESEC (2023–2027). '
      'I bridge visual craft with solid engineering currently working as a Frontend Engineer at BarterNow while building full-stack platforms, developer tools, and multi-agent AI systems. '
      'With 350+ algorithmic problems solved on LeetCode and a portfolio of shipped web and mobile applications, I focus on building polished, reliable software that users enjoy.';

  // ── Editorial home page content ───────────────────────────────────
  static const String shortName = 'Deepanshu';
  static const String phonetic = '/dee · pan · shu/';
  static const String headline = 'Flutter Developer & Software Engineer';

  /// Rotating roles shown under the name in the hero.
  static const List<String> roles = [
    'Flutter Developer',
    'UI/UX Developer',
    'Software Engineer',
    'Web Developer',
  ];
  static const String timezoneLabel = 'IST';
  static const int utcOffsetMinutes = 330; // India Standard Time, UTC+5:30
  static const String repoUrl =
      'https://github.com/Deepanshu-ui-dev/Deepanshu-Kaushik-Portfolio';
  static const bool openToWork = true;

  static const List<String> aboutBullets = [
    'Flutter developer experienced with Riverpod state management, custom painters, and cross-platform apps (iOS, Android, Web).',
    'Frontend engineer building responsive React.js interfaces and full-stack systems with Node.js, Express, PostgreSQL, Redis, RabbitMQ, and FastAPI.',
    '350+ algorithmic problems solved on LeetCode; active GDG Co-Organizer passionate about high-craft engineering.',
  ];

  /// Hero "before you hire me" tray — question chip → answer shown in the
  /// avatar's speech bubble. Rewrite these in your own voice.
  static const List<(String, String)> askMe = [
    ('what do you do?',
        'frontend engineer at BarterNow by day, Flutter apps and full-stack side projects the rest of the time.'),
    ('what are you best at?',
        'turning a design into an interface that feels right: Flutter, custom painters, small animations, clean state.'),
    ('are you open to work?',
        'yes. full-time roles and freelance. my email is just below, it copies on click.'),
    ('still studying?',
        'yep, B.Tech in Data Science at ABESEC, graduating 2027.'),
    ('what else do you do?',
        'co-organise GDG events, grind LeetCode (350+), take photos, and keep Satie playing in the background.'),
  ];

  /// What the avatar says when someone pokes it.
  static const List<String> pokeLines = ['hey!', 'that tickles.', 'hi there 👋', 'ask me something below.'];

  /// Short "tl;dr" chat messages for the current role, shown in the
  /// Experience section's chat bubble.
  static const List<String> tldr = [
    'hey 👋',
    'i build the React frontend for BarterNow, a two-sided sponsorship marketplace.',
    'mostly reusable components, API wiring, and turning Figma into production UI.',
    'on the side: Flutter apps, full-stack platforms, and a multi-agent AI pipeline.',
  ];

  /// Public-domain recording bundled in assets/audio (Musopen via Wikimedia Commons).
  static const NowPlaying nowPlaying = NowPlaying(
    title: 'Gymnopédie No. 1 ( 1888 )',
    artist: 'Erik Satie · Robin Alciatore',
    asset: 'assets/audio/gymnopedie_1.mp3',
  );

  static const List<RoleItem> experience = [
    RoleItem(
      role: 'Frontend Engineer',
      company: 'BarterNow',
      period: 'Aug 2026 – Present',
      isCurrent: true,
      summary:
          'Building responsive, scalable frontend features for a two-sided sponsorship marketplace.',
      phases: [
        RolePhase('Frontend Development',
            'Develop responsive, reusable React.js components and features across multiple product workflows, following a scalable component architecture.'),
        RolePhase('API Integration',
            'Integrate REST APIs with backend services and translate design specs and product requirements into maintainable, production-ready interfaces.'),
        RolePhase('Cross-Team Collaboration',
            'Collaborate with backend and design teams to ship features and keep the UI consistent across the product.'),
      ],
      tags: ['React.js', 'JavaScript', 'REST APIs', 'HTML', 'CSS', 'Figma'],
    ),
    RoleItem(
      role: 'Freelance Web & Mobile Application Developer',
      company: 'Freelance',
      period: '2025 – Present',
      isCurrent: true,
      summary:
          'Designing and building web and mobile applications for clients and personal products, from UI design to full-stack implementation.',
      phases: [
        RolePhase('Mobile Applications',
            'Built Flutter apps such as Codexa, a multi-platform coding stats dashboard, and FinTrack, an offline-first personal finance app with Hive storage and biometric authentication.'),
        RolePhase('Full-Stack Platforms',
            'Engineered QuizForge: Node.js, Express, Prisma, and PostgreSQL with RabbitMQ message queues and Redis caching for server-side exam grading.'),
        RolePhase('Web & AI Products',
            'Built Meridian, a React-based AI hiring platform, and MediAuth AI, a multi-agent clinical prior-authorization pipeline using LangGraph, FastAPI, and ChromaDB.'),
        RolePhase('UI/UX & Design Systems',
            'Created component libraries and interface designs in Figma and Framer for client and personal projects.'),
      ],
      tags: ['Flutter', 'Dart', 'React', 'Node.js', 'PostgreSQL', 'Supabase', 'Figma'],
    ),
  ];

  static const List<StatItem> stats = [
    StatItem(350, '+', 'LeetCode Solved'),
    StatItem(750, '+', 'Hackathon Participants'),
    StatItem(1100, '+', 'GDG Community Members'),
    StatItem(40, '', 'Member Team Led'),
  ];

  /// Flutter-specific capabilities shown above the tech-stack chips.
  static const List<(String, String)> flutterToolkit = [
    ('Architecture', 'Layered Clean Architecture · Feature-first'),
    ('State', 'Riverpod · Reactive Streams'),
    ('Storage', 'Hive (Offline-first) · Cloud Firestore'),
    ('Backend', 'Node.js / Express · Supabase · FastAPI'),
    ('Platforms', 'Android · iOS · Web (Single Codebase)'),
    ('UI & Craft', 'Custom Painters · Micro-animations · Tokens'),
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
      tagline: 'Multi-platform developer analytics dashboard',
      year: '2025',
      imageAsset: 'assets/images/proj_codexa.jpg',
      description:
          'A unified developer intelligence platform aggregating competitive programming ratings, submission heatmaps, and contest statistics from six major coding platforms into one real-time dashboard.',
      features: [
        'Real-time metric aggregation across 6 developer platforms',
        'Interactive submission heatmaps and performance velocity tracking',
        'Contest rating histories and multi-platform percentile benchmarks',
        'Custom goal setting, leaderboards, and streak analytics',
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
      tagline: 'Asynchronous assessment engine with server-side grading',
      year: '2025',
      imageAsset: null,
      description:
          'An enterprise assessment ecosystem enabling educators to author dynamic evaluations and students to sit timed exams, backed by RabbitMQ queues and Redis for resilient server-side auto-grading.',
      features: [
        'Role-based authentication & permissions for educators and students',
        'Asynchronous evaluation pipeline powered by RabbitMQ & Redis',
        'Server-side exam auto-grading and detailed analytics reports',
        'Relational data model on PostgreSQL managed with Prisma ORM',
      ],
      tags: ['Flutter', 'Node.js', 'Express', 'Prisma', 'PostgreSQL', 'Redis', 'RabbitMQ'],
      categories: ['Flutter', 'Full-stack'],
      architecture: ['Flutter client', 'Express API', 'RabbitMQ queue', 'PostgreSQL + Prisma', 'Redis'],
      githubUrl: 'https://github.com/Deepanshu-ui-dev/QuizForge---Teacher-and-Student-Assessment-Platform',
    ),
    ProjectItem(
      name: 'Meridian',
      tagline: 'AI hiring ecosystem with semantic ATS matching',
      year: '2025',
      imageAsset: 'assets/images/proj_meridian.jpg',
      description:
          'An AI-driven career matching platform connecting software engineers with recruiters — featuring automated ATS resume parsing, semantic candidate ranking, and streamlined recruiter pipelines.',
      features: [
        'Semantic job-to-candidate matching powered by OpenAI',
        'Real-time ATS resume scoring and keyword gap optimization',
        'Interactive applicant tracking and multi-stage hiring pipelines',
        'High-performance recruiter dashboard with candidate analytics',
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
      tagline: 'Autonomous multi-agent clinical prior-auth',
      year: '2025',
      imageAsset: null,
      description:
          'An autonomous multi-agent AI system that automates medical insurance prior-authorization — orchestrating patient intake, clinical policy retrieval, and automated appeal generation with LangGraph.',
      features: [
        'Autonomous clinical intake parsing and symptom-to-code mapping',
        'Vector-similarity insurance policy retrieval via ChromaDB',
        'Automated medical necessity packet and appeal letter generation',
        'Human-in-the-loop review workflow for healthcare practitioners',
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
          'A privacy-centric personal finance manager engineered offline-first in Flutter, featuring local biometric authentication, reactive budget insights, and fast local persistence via Hive.',
      features: [
        'Offline-first architecture powered by Hive',
        'Hardware-backed biometric authentication (Fingerprint / Face Unlock)',
        'Predictive spending categories and real-time budget burn charts',
        'Deterministic data backup and exportable financial summaries',
      ],
      tags: ['Flutter', 'Riverpod', 'Hive', 'FinTech'],
      categories: ['Flutter'],
      architecture: ['Flutter UI', 'Riverpod', 'Hive (local)'],
      githubUrl: 'https://github.com/Deepanshu-ui-dev/Fintrack',
      installUrl: 'https://github.com/Deepanshu-ui-dev/Fintrack/releases/latest/',
    ),
    ProjectItem(
      name: 'Chat App',
      tagline: 'Reactive real-time messaging on Supabase',
      year: '2024',
      imageAsset: 'assets/images/proj_chat.jpg',
      description:
          'A sleek real-time chat client built on Supabase Realtime channels with optimistic UI dispatch, presence detection, and low-latency message synchronization.',
      features: [
        'Low-latency message delivery using Supabase Realtime',
        'Optimistic UI delivery with immediate feedback loops',
        'Presence detection, typing status, and read receipt tracking',
        'Clean responsive typography following modern messaging ergonomics',
      ],
      tags: ['Flutter', 'Supabase', 'Real-time'],
      categories: ['Flutter'],
      architecture: ['Flutter client', 'Supabase Auth', 'Supabase Realtime'],
      githubUrl: 'https://github.com/Deepanshu-ui-dev/Chat-app-flutter',
    ),
    ProjectItem(
      name: 'Document Search Engine',
      tagline: 'Inverted index & TF-IDF relevance ranking',
      year: '2024',
      imageAsset: 'assets/images/proj_searchengine.jpg',
      description:
          'An algorithmic information retrieval engine implementing inverted indices, phrase lookup via positional postings, and TF-IDF relevance ranking built from first principles in Python.',
      features: [
        'Inverted index with positional posting lists',
        'TF-IDF scoring for document relevance and query ranking',
        'Exact phrase matching and boolean query operators',
        'Fast command-line interface for query execution',
      ],
      tags: ['Python', 'Algorithms', 'NLP', 'CLI'],
      categories: ['Systems'],
      architecture: ['Tokenizer', 'Positional index', 'TF-IDF ranker', 'CLI'],
      githubUrl: 'https://github.com/Deepanshu-ui-dev/Document-Search-Engine',
    ),
    ProjectItem(
      name: 'This Portfolio',
      tagline: 'Tactile editorial Flutter Web experience',
      year: '2026',
      imageAsset: 'assets/images/proj_portfolio.jpg',
      description:
          'A bespoke editorial portfolio engineered in Flutter Web, showcasing custom render painters, an instant fuzzy command palette (⌘K), live GitHub commit graph streaming, and fluid dark mode.',
      features: [
        'Custom canvas painters for hatched gutters, grids, and tactile chrome',
        'Instant command palette (⌘K) with keyboard shortcuts and deep routing',
        'Real-time GitHub contribution graph with year-by-year inspection',
        'Audio player, visitor telemetry, and responsive editorial layout',
      ],
      tags: ['Flutter', 'Dart', 'Riverpod', 'Supabase'],
      categories: ['Flutter'],
      architecture: ['Flutter Web', 'Riverpod', 'Supabase', 'GitHub API'],
      githubUrl: 'https://github.com/Deepanshu-ui-dev/Deepanshu-Kaushik-Portfolio',
      liveUrl: 'https://www.deepanshux.tech/',
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