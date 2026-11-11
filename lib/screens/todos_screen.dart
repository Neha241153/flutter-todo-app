
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';
import 'add_todo_screen.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodoProvider>().fetchTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TodoProvider>();

    final total = provider.todos.length;
    final completed = provider.completedCount;

    final progress = total == 0 ? 0.0 : completed / total;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FF),

      // APP BAR
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5FF),
        elevation: 0,

        title: const Text(
          'My Tasks',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xFF30264D),
          ),
        ),

        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 18),
            child: CompletedCountBadge(),
          ),
        ],
      ),

      // BODY
      body: Column(
        children: [
          // PROGRESS CARD
          Container(
            margin: const EdgeInsets.all(18),
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF8E7CC3),
                  Color(0xFFB5A4E8),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stay productive ✨',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '$completed out of $total tasks completed',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 18),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),

                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 9,
                    backgroundColor: Colors.white30,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${(progress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // SECTION HEADING
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 5,
            ),

            child: Align(
              alignment: Alignment.centerLeft,

              child: Text(
                'Your Todo List',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF30264D),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // TODO LIST
          Expanded(
            child: provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF8E7CC3),
                    ),
                  )

                : provider.errorMessage != null
                    ? Center(
                        child: Text(
                          provider.errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      )

                    : provider.todos.isEmpty
                        ? const Center(
                            child: Text(
                              'No tasks available!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          )

                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 5,
                            ),

                            itemCount: provider.todos.length,

                            itemBuilder: (context, index) {
                              final todo = provider.todos[index];

                              return Container(
                                margin: const EdgeInsets.only(
                                  bottom: 12,
                                ),

                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(18),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),

                                child: ListTile(
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 7,
                                  ),

                                  // COMPLETED ICON
                                  leading: Icon(
                                    todo.completed
                                        ? Icons.check_circle
                                        : Icons.circle_outlined,

                                    color: todo.completed
                                        ? const Color(0xFF70B99A)
                                        : const Color(0xFFB5A4E8),

                                    size: 28,
                                  ),

                                  // TASK TITLE
                                  title: Text(
                                    todo.title,

                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF30264D),

                                      decoration: todo.completed
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,

                                      decorationColor: Colors.grey,
                                    ),
                                  ),

                                  // TASK ID
                                  subtitle: Text(
                                    'Task #${todo.id}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  trailing: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),

      // ADD TASK BUTTON
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTodoScreen(),
            ),
          );
        },

        backgroundColor: const Color(0xFF8E7CC3),
        foregroundColor: Colors.white,

        icon: const Icon(Icons.add),
        label: const Text(
          'Add Task',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// COMPLETED COUNT USING context.select
class CompletedCountBadge extends StatelessWidget {
  const CompletedCountBadge({super.key});

  @override
  Widget build(BuildContext context) {

    final count = context.select<TodoProvider, int>(
      (provider) => provider.completedCount,
    );

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 8,
        ),

        decoration: BoxDecoration(
          color: const Color(0xFFE9E2FA),
          borderRadius: BorderRadius.circular(20),
        ),

        child: Text(
          'Done: $count',

          style: const TextStyle(
            color: Color(0xFF66539A),
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
