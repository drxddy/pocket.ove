import 'package:flutter/material.dart';
import 'package:pocket/domain/utils/utils.dart';
import 'package:table_calendar/table_calendar.dart';

class PocketApp extends StatefulWidget {
  const PocketApp({super.key});

  @override
  _PocketAppState createState() => _PocketAppState();
}

class _PocketAppState extends State<PocketApp> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          _isExpanded ? Container() : HomeScreen(),

          // Bottom draggable panel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.velocity.pixelsPerSecond.dy < 0) {
                  // Swipe up
                  setState(() {
                    _isExpanded = true;
                  });
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: _isExpanded ? MediaQuery.of(context).size.height : 60,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: _isExpanded
                      ? BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )
                      : BorderRadius.zero,
                ),
                child: _isExpanded
                    ? RecordingScreen(
                        onClose: () {
                          setState(() {
                            _isExpanded = false;
                          });
                        },
                      )
                    : BottomBar(),
              ),
            ),
          ),

          // Top swipe down indicator (when expanded)
          if (_isExpanded)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SwipeDownIndicator(),
            ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime calendarStart = DateTime(2025, 1, 1);
  final DateTime calendarEnd = DateTime(2025, 12, 31);
  DateTime selectedDay = DateTime.now();

  DateTime focusedDay = DateTime.now();
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = focusedDay;
    });
  }

  void onPageChanged(DateTime focusedDay) {
    setState(() {
      this.focusedDay = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App bar with title, search and profile
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pocket',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Good morning, Sayan',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[200],
                      child: Icon(Icons.search, color: Colors.black),
                    ),
                    SizedBox(width: 10),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[200],
                      // In a real app, this would be a network image
                      child: Icon(Icons.person, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Category chips
          Container(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                CategoryChip(
                  title: 'Mettings',
                  gradientColors: [Colors.pink[100]!, Colors.blue[100]!],
                ),
                SizedBox(width: 16),
                CategoryChip(
                  title: 'Chats',
                  gradientColors: [Colors.green[100]!, Colors.blue[100]!],
                ),
                SizedBox(width: 16),
                CategoryChip(
                  title: 'Thoughts',
                  gradientColors: [Colors.purple[100]!, Colors.blue[100]!],
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Your conversations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          SizedBox(height: 16),

          // Date selector
          TableCalendar(
            firstDay: calendarStart,
            focusedDay: focusedDay,
            headerVisible: false,
            lastDay: calendarEnd,
            calendarFormat: CalendarFormat.week,
            availableCalendarFormats: const {
              CalendarFormat.week: 'Week',
            },
            calendarBuilders: const CalendarBuilders(),
            eventLoader: (day) => [if (day.isToday) 1],
            pageJumpingEnabled: true,
            pageAnimationEnabled: true,
            selectedDayPredicate: (day) {
              return isSameDay(selectedDay, day);
            },
            onDaySelected: onDaySelected,
            onPageChanged: onPageChanged,
            pageAnimationDuration: const Duration(milliseconds: 300),
            pageAnimationCurve: Curves.ease,
            daysOfWeekStyle: const DaysOfWeekStyle(
                decoration: BoxDecoration(),
                weekdayStyle: TextStyle(fontSize: 13, color: Colors.white54),
                weekendStyle: TextStyle(fontSize: 13, color: Colors.white54)),
            headerStyle: const HeaderStyle(
                formatButtonShowsNext: true,
                formatButtonVisible: true,
                formatButtonDecoration: BoxDecoration(
                    color: AppColors.onSurface,
                    borderRadius: BorderRadius.all(Radius.circular(12))),
                formatButtonPadding: EdgeInsets.all(5),
                leftChevronMargin: EdgeInsets.zero,
                rightChevronMargin: EdgeInsets.zero,
                headerPadding: EdgeInsets.only(left: 20, bottom: 10),
                leftChevronVisible: false,
                rightChevronVisible: false),
            calendarStyle: CalendarStyle(
                markersMaxCount: 1,
                weekendTextStyle: const TextStyle(color: Colors.grey),
                markerDecoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12)),
                selectedDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    border: Border.all(color: AppColors.background, width: 2)),
                todayDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: AppColors.background.withOpacity(.2))),
            formatAnimationDuration: const Duration(milliseconds: 300),
            formatAnimationCurve: Curves.ease,
          ),

          // Conversation list
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                DateSection(
                  date: 'Tuesday, Jan 6 \'25',
                  conversations: [
                    ConversationItem(
                      title: 'Morning thoughts',
                      subtitle: '08:45',
                      gradientColors: [Colors.blue[200]!, Colors.purple[200]!],
                    ),
                    ConversationItem(
                      title: '1:1 w/ Akshay',
                      subtitle:
                          'Conversation with\nAkshay about product features',
                      gradientColors: [Colors.red[400]!, Colors.orange[300]!],
                      hasActionButton: true,
                    ),
                    ConversationItem(
                      title: '2025 predications',
                      subtitle: 'Thoughts on tech trends for\n2025',
                      gradientColors: [Colors.purple[300]!, Colors.pink[200]!],
                      hasActionButton: true,
                    ),
                  ],
                ),
                DateSection(
                  date: 'Monday, Jan 5 \'25',
                  conversations: [
                    Row(
                      children: [
                        Expanded(
                          child: ConversationItem(
                            title: 'Daily standup',
                            subtitle: 'Discussion on open\ntasks for the week',
                            gradientColors: [
                              Colors.pink[100]!,
                              Colors.purple[100]!
                            ],
                            isSmall: true,
                            hasActionButton: true,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ConversationItem(
                            title: 'Design brainstorm',
                            subtitle: 'Chat about visual\ndesign ideas',
                            gradientColors: [
                              Colors.green[200]!,
                              Colors.teal[100]!
                            ],
                            isSmall: true,
                            hasActionButton: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                DateSection(
                  date: 'Friday, Jan 2 \'25',
                  conversations: [
                    ConversationItem(
                      title: 'All hands meet',
                      subtitle:
                          'Discussion on overall org wide\nupdates on performance',
                      gradientColors: [Colors.purple[400]!, Colors.pink[300]!],
                      hasActionButton: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String title;
  final List<Color> gradientColors;

  const CategoryChip({
    Key? key,
    required this.title,
    required this.gradientColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: gradientColors[0].withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class DateSection extends StatelessWidget {
  final String date;
  final List<Widget> conversations;

  const DateSection({
    Key? key,
    required this.date,
    required this.conversations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '6 >',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        ...conversations
            .map((conversation) => Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: conversation,
                ))
            .toList(),
      ],
    );
  }
}

class ConversationItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final bool isSmall;
  final bool hasActionButton;

  const ConversationItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    this.isSmall = false,
    this.hasActionButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: isSmall ? 80 : 100,
          height: isSmall ? 80 : 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (hasActionButton) Icon(Icons.keyboard_arrow_right),
                ],
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "Sayan's pocket",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text(
                "Connected · 75%",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.mic, size: 16),
                SizedBox(width: 8),
                Text(
                  "Record",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SwipeDownIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 40, bottom: 20),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.keyboard_arrow_down, size: 20),
            SizedBox(width: 8),
            Text(
              "Swipe down to go home",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecordingScreen extends StatelessWidget {
  final VoidCallback onClose;

  const RecordingScreen({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Swipe down hint
        SwipeDownIndicator(),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title and timer
                Column(
                  children: [
                    Text(
                      "New memory",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "00:08.55",
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),

                // Waveform
                Row(
                  children: [
                    RotatedBox(
                      quarterTurns: -1,
                      child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            "TO POCKET",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 60,
                        child: CustomPaint(
                          painter: WaveformPainter(),
                          size: Size(double.infinity, 60),
                        ),
                      ),
                    ),
                  ],
                ),

                // Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[800],
                      child: Icon(Icons.shield, color: Colors.white, size: 20),
                    ),
                    SizedBox(width: 24),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.pause, color: Colors.black, size: 24),
                    ),
                    SizedBox(width: 24),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey[800],
                      child: Icon(Icons.stop, color: Colors.white, size: 20),
                    ),
                  ],
                ),

                // Connection status
                Text(
                  "Connected · 75%",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Custom painter for audio waveform
class WaveformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Generate random heights for the waveform
    final random = List.generate(
        40,
        (index) => (index % 3 == 0)
            ? size.height * 0.8
            : size.height * 0.2 + (index % 5) * size.height * 0.1);

    final barWidth = size.width / (random.length * 2);

    for (int i = 0; i < random.length; i++) {
      final x = i * barWidth * 2 + barWidth / 2;
      final height = random[i];

      // Draw the line from center to up and down
      canvas.drawLine(
        Offset(x, size.height / 2 - height / 2),
        Offset(x, size.height / 2 + height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Chat with Tasha screen (second image)
class ChatSaveScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Swipe down hint
            SwipeDownIndicator(),

            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Gradient square
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [Colors.purple[400]!, Colors.blue[300]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Chat title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Chat with Tasha",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "|",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    // Tag indicator
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "saving to: ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            "#general",
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.arrow_drop_down,
                              color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom buttons and keyboard
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Text(
                              "Discard",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Center(
                            child: Text(
                              "Save",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Keyboard suggestion bar
                Container(
                  height: 40,
                  color: Colors.grey[900],
                  child: Row(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        margin: EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          "\"The\"",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "the",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        margin: EdgeInsets.only(right: 8),
                        child: Text(
                          "to",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Keyboard (simulated)
                Container(
                  height: 220,
                  color: Colors.grey[850],
                  child: Column(
                    children: [
                      buildKeyboardRow(
                          ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p']),
                      buildKeyboardRow(
                          ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l']),
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            margin: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(Icons.arrow_upward,
                                color: Colors.white, size: 20),
                          ),
                          ...['z', 'x', 'c', 'v', 'b', 'n', 'm']
                              .map((key) => Container(
                                    width: 34,
                                    height: 40,
                                    margin: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[700],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Center(
                                      child: Text(
                                        key,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                          Container(
                            width: 40,
                            height: 40,
                            margin: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(Icons.backspace,
                                color: Colors.white, size: 20),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 40,
                            margin: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                "ABC",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 40,
                              margin: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey[700],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Text(
                                  "space",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 80,
                            height: 40,
                            margin: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Text(
                                "return",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            margin: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(Icons.emoji_emotions_outlined,
                                color: Colors.white, size: 24),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            margin: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child:
                                Icon(Icons.mic, color: Colors.white, size: 24),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildKeyboardRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys
          .map((key) => Container(
                width: 34,
                height: 40,
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    key,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
