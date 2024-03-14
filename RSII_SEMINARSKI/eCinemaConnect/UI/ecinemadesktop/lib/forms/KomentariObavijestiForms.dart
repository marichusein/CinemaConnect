import 'package:ecinemadesktop/services/services.dart';
import 'package:flutter/material.dart';

class CommentListWidget extends StatefulWidget {
  @override
  _CommentListWidgetState createState() => _CommentListWidgetState();
}

class _CommentListWidgetState extends State<CommentListWidget> {
  List<CommentN> comments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    try {
      final List<CommentN> fetchedComments = await ApiService.fetchCommentsN();
      setState(() {
        comments = fetchedComments;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching comments: $e');
      // handle error as needed
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteComment(int commentId) async {
    try {
      await ApiService.deleteCommentN(commentId);
      // Refresh comments list after successful deletion
      fetchComments();
    } catch (e) {
      print('Error deleting comment: $e');
      // handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              return ListTile(
                title: Text(comment.tekstKomentara),
                subtitle: FutureBuilder<NotificationDetails>(
                  future: fetchNotificationDetails(comment.obavijestId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final notification = snapshot.data!;
                      return Text('Notification: ${notification.naslov}');
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return CircularProgressIndicator();
                  },
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Comment'),
                        content: Text('Are you sure you want to delete this comment?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              deleteComment(comment.id);
                              Navigator.pop(context);
                            },
                            child: Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('No'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Future<NotificationDetails> fetchNotificationDetails(int notificationId) async {
    try {
      return await ApiService.fetchNotificationDetails(notificationId);
    } catch (e) {
      print('Error fetching notification details: $e');
      throw e; // propagate error
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: CommentListWidget(),
    ),
  ));
}
