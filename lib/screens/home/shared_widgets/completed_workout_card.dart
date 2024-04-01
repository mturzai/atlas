import 'package:atlas/models/workout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:atlas/screens/home/profile_page/profile_picture_service.dart';

/* A card widget that displays information about a completed workout. */
class CompletedWorkoutCard extends StatelessWidget {
  final CompletedWorkout workout;

  /// Constructs a [CompletedWorkoutCard] with the given [workout].
  const CompletedWorkoutCard({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    /* Calculate the time difference between the current time and the time the workout was completed */
    final DateTime now = DateTime.now();
    final DateTime timestampDate = workout.completedTime.toDate();
    final Duration timeDifference = now.difference(timestampDate);

    String formattedTimestamp;
    if (timeDifference.inDays > 1) {
      formattedTimestamp = DateFormat('h:mm a MMMM d, y')
          .format(timestampDate); // Format timestamp for more than 1 day ago
    } else if (timeDifference.inDays == 1) {
      formattedTimestamp =
          'Yesterday at ${DateFormat('h:mm a').format(timestampDate)}'; // Format timestamp for yesterday
    } else if (timeDifference.inHours >= 1) {
      formattedTimestamp =
          'Today at ${DateFormat('h:mm a').format(timestampDate)}'; // Format timestamp for today
    } else {
      formattedTimestamp =
          '${timeDifference.inMinutes} minutes ago'; // Format timestamp for less than 1 hour ago
    }

    return Card(
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              /* Row containing User image + name + time completed */
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* Column for image */
                Column(
                  children: [
                    FutureBuilder<String>(
                      future: ProfilePictureService()
                          .getProfilePicture(workout.completedBy.uid),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        Widget imageWidget;
                        if (snapshot.connectionState ==
                                ConnectionState.waiting ||
                            !snapshot.hasData) {
                          imageWidget = const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey, // Placeholder color
                          );
                        } else {
                          imageWidget = CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(snapshot.data!),
                          );
                        }
                        return imageWidget;
                      },
                    ),
                  ],
                ),
                const SizedBox(
                    width:
                        16), // Add spacing between image column and text column
                /* Column for name and time completed */
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${workout.completedBy.firstName} ${workout.completedBy.lastName}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 2),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        /* Check mark */
                        const Icon(Icons.task_alt, size: 12),
                        /* aesthetic space */
                        const SizedBox(width: 2),
                        Text(
                          formattedTimestamp,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              workout.workoutName,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(workout.description),
            const SizedBox(height: 8),
            Text(
              'Created by: ${workout.createdBy.firstName} ${workout.createdBy.lastName}',
            ),
          ],
        ),
      ),
    );
  }
}
