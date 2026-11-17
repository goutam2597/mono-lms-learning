class CourseModel {
  final String id;
  final String title;
  final String category;
  final bool categoryIsPurple;
  final String coverImage;
  final bool hasVideoPreview;
  final String instructor;
  final String instructorRole;
  final String? instructorAvatar;
  final String rating;
  final String reviews; // review count, as the web card's "(15 reviews)"
  final String? oldPrice;
  final String ratingSubtitle; // e.g. "· 32 students enrolled" or "· Featured course"
  final String lessons;
  final String duration;
  final String level;
  final String? featuresTitle;
  final String? featuresSubtitle;
  final String aboutTitle;
  final String aboutText;
  final List<String> whatYouLearn;
  final bool hasReassuranceBox;
  final String price;
  final String priceSubtext;
  final String actionButtonText;
  final bool isFree;

  const CourseModel({
    required this.id,
    required this.title,
    required this.category,
    this.categoryIsPurple = false,
    required this.coverImage,
    this.hasVideoPreview = false,
    required this.instructor,
    this.instructorRole = 'Course instructor',
    this.instructorAvatar,
    required this.rating,
    this.reviews = '0',
    this.oldPrice,
    this.ratingSubtitle = '· Featured course',
    this.lessons = '12+ lessons',
    this.duration = '9hr 30min',
    this.level = 'Beginner',
    this.featuresTitle,
    this.featuresSubtitle,
    this.aboutTitle = 'About this course',
    required this.aboutText,
    this.whatYouLearn = const [],
    this.hasReassuranceBox = false,
    required this.price,
    this.priceSubtext = 'One-time payment',
    this.actionButtonText = 'Add to cart',
    this.isFree = false,
  });

  static const freeWebDevCourse = CourseModel(
    id: 'webdev-2',
    title: 'The Complete Web\nDeveloper Course 2.0',
    category: 'Web Development',
    categoryIsPurple: false,
    coverImage: 'assets/images/course_webdev_preview.jpg',
    hasVideoPreview: true,
    instructor: 'Nicole Brown',
    instructorRole: 'Instructor · Web Development',
    instructorAvatar: 'assets/images/instructor_nicole.jpg',
    rating: '4.0',
    ratingSubtitle: '(15 reviews)   ·   32 students enrolled',
    lessons: '12+ lessons',
    duration: '9hr 30min',
    level: 'Beginner',
    aboutTitle: 'About this course',
    aboutText:
        'Learn Web Development by building 25 websites and mobile apps using HTML, CSS, Javascript, PHP, Python',
    whatYouLearn: [],
    hasReassuranceBox: false,
    price: 'FREE',
    priceSubtext: 'Full lifetime access',
    actionButtonText: 'Enroll now',
    isFree: true,
  );

  static const reactJsCourse = CourseModel(
    id: 'reactjs-tech',
    title: 'Learn & Create ReactJS\nTech Fundamentals Apps',
    category: 'Productivity',
    categoryIsPurple: true,
    coverImage: 'assets/images/course_reactjs.jpg',
    hasVideoPreview: false,
    instructor: 'David Benitez',
    instructorRole: 'Course instructor',
    instructorAvatar: null,
    rating: '5.0',
    ratingSubtitle: '·    Featured course',
    lessons: '12+ lessons',
    duration: '9hr 30min',
    level: 'Beginner',
    featuresTitle: 'Learn at your pace',
    featuresSubtitle: 'Mobile access  ·  Lifetime access',
    aboutTitle: 'Build your ReactJS foundation',
    aboutText:
        'Turn your curiosity into practical development skills. Learn the fundamentals and apply them as you build your own apps.',
    whatYouLearn: [
      'Understand components and reusable UI',
      'Work with state and user interactions',
      'Bring your ideas to life with a project',
    ],
    hasReassuranceBox: true,
    price: '\$300',
    priceSubtext: 'One-time payment',
    actionButtonText: 'Add to cart',
    isFree: false,
  );

  static const businessCourse = CourseModel(
    id: 'business-mgmt',
    title: 'The Complete Business and\nManagement Course',
    category: 'Management',
    categoryIsPurple: true,
    coverImage: 'assets/images/course_business.jpg',
    instructor: 'Calvin Johnsen',
    instructorRole: 'Course instructor',
    rating: '5.0',
    ratingSubtitle: '·    Featured course',
    aboutTitle: 'Master Modern Business Management',
    aboutText:
        'Gain real-world management insights, operational leadership principles, and team strategy skills for growth.',
    whatYouLearn: [
      'Master strategic planning and operational workflows',
      'Lead cross-functional teams with confidence',
      'Analyze business metrics and financial health',
    ],
    hasReassuranceBox: true,
    price: '\$355',
    priceSubtext: 'One-time payment',
    actionButtonText: 'Add to cart',
    isFree: false,
  );

  static const sketchCourse = CourseModel(
    id: 'sketch-arts',
    title: 'Build Creative Arts & media\nCourse Completed',
    category: 'Art & Media',
    categoryIsPurple: true,
    coverImage: 'assets/images/course_sketch.jpg',
    instructor: 'David Benitez',
    instructorRole: 'Course instructor',
    rating: '5.0',
    ratingSubtitle: '·    Featured course',
    aboutTitle: 'Creative Media & Visual Arts',
    aboutText:
        'Explore visual design, typography, layout hierarchy, and creative production pipelines from industry mentors.',
    whatYouLearn: [
      'Master industry design standards and composition',
      'Build portfolio-ready visual art assets',
      'Collaborate on real-world creative media briefs',
    ],
    hasReassuranceBox: true,
    price: '\$500',
    priceSubtext: 'One-time payment',
    actionButtonText: 'Add to cart',
    isFree: false,
  );
}
